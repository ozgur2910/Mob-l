import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/voice_state.dart';
import '../../data/services/speech_service.dart';
import '../../data/services/tts_service.dart';
import '../../data/services/silence_detector.dart';
import '../../data/services/voice_service.dart';

class VoiceControllerState {
  final VoiceState state;
  final String? lastTranscript;
  final String? errorMessage;
  final bool initialized;

  VoiceControllerState({required this.state, this.lastTranscript, this.errorMessage, this.initialized = false});

  VoiceControllerState copyWith({VoiceState? state, String? lastTranscript, String? errorMessage, bool? initialized}) {
    return VoiceControllerState(
      state: state ?? this.state,
      lastTranscript: lastTranscript ?? this.lastTranscript,
      errorMessage: errorMessage ?? this.errorMessage,
      initialized: initialized ?? this.initialized,
    );
  }
}

class VoiceController extends StateNotifier<VoiceControllerState> {
  final Reader read;
  late final SpeechService _speechService;
  late final TtsService _ttsService;
  late final SilenceDetector _silenceDetector;
  VoiceService? _voiceService;

  Timer? _restartTimer;

  VoiceController(this.read) : super(VoiceControllerState(state: VoiceState.idle)) {
    _speechService = SpeechService();
    _ttsService = TtsService();
    _silenceDetector = SilenceDetector(onSilence: _onSilenceDetected);
  }

  Future<void> initialize() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      state = state.copyWith(state: VoiceState.error, errorMessage: 'Microphone permission denied');
      return;
    }

    final ok = await _speechService.init();
    if (!ok) {
      state = state.copyWith(state: VoiceState.error, errorMessage: 'Microphone unavailable');
      return;
    }

    await _ttsService.init();

    // Create voice service passing a Reader for provider access
    _voiceService = VoiceService(_speechService, _ttsService, _silenceDetector, read);

    state = state.copyWith(initialized: true, state: VoiceState.idle);

    // Auto start listening if enabled in settings (default true)
    final settings = Hive.box('settings');
    final autoListen = settings.get('auto_listen', defaultValue: true) as bool;
    if (autoListen) {
      await startListening();
    }
  }

  Future<void> startListening() async {
    if (state.state == VoiceState.listening) return;
    if (!state.initialized) {
      await initialize();
      if (!state.initialized) return;
    }
    state = state.copyWith(state: VoiceState.listening, errorMessage: null);

    await _voiceService?.start((transcript) async {
      // Got recognized text
      state = state.copyWith(lastTranscript: transcript, state: VoiceState.processing);
      // Save user message locally
      final box = Hive.box('conversations');
      box.add({'role': 'user', 'text': transcript, 'ts': DateTime.now().toIso8601String()});

      try {
        final response = await _voiceService?.sendToAi(transcript);
        if (response != null) {
          state = state.copyWith(state: VoiceState.speaking);
          await _voiceService?.speakAndMaybeSave(response);
        }
      } catch (e) {
        state = state.copyWith(state: VoiceState.error, errorMessage: e.toString());
      } finally {
        // Restart listening after speaking
        _scheduleRestartListening();
      }
    }, (err) {
      state = state.copyWith(state: VoiceState.error, errorMessage: err);
    });
  }

  Future<void> stopListening() async {
    await _speechService.stopListening();
    state = state.copyWith(state: VoiceState.idle);
  }

  Future<void> restartListening() async {
    await stopListening();
    await Future.delayed(const Duration(milliseconds: 300));
    await startListening();
  }

  Future<void> speak(String text) async {
    state = state.copyWith(state: VoiceState.speaking);
    try {
      await _ttsService.speak(text);
    } catch (e) {
      state = state.copyWith(state: VoiceState.error, errorMessage: e.toString());
    } finally {
      _scheduleRestartListening();
    }
  }

  Future<void> cancelSpeaking() async {
    await _ttsService.stop();
    state = state.copyWith(state: VoiceState.idle);
  }

  void _onSilenceDetected() async {
    // Stop speech_to_text and treat as final
    await _speechService.stopListening();
  }

  void _scheduleRestartListening() {
    _restartTimer?.cancel();
    _restartTimer = Timer(const Duration(milliseconds: 500), () async {
      await startListening();
    });
  }

  @override
  void dispose() {
    _restartTimer?.cancel();
    _speechService.cancel();
    _ttsService.dispose();
    _silenceDetector.dispose();
    super.dispose();
  }
}

final voiceControllerProvider = StateNotifierProvider<VoiceController, VoiceControllerState>((ref) {
  return VoiceController(ref.read);
});
