import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/models/voice_state.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../services/silence_detector.dart';
import '../../../ai/data/providers/gemini_provider.dart';
import '../../../ai/domain/repositories/ai_repository.dart';
import 'package:hive/hive.dart';

class VoiceService {
  final SpeechService _speech;
  final TtsService _tts;
  final SilenceDetector _silenceDetector;
  final Reader _read;

  VoiceService(this._speech, this._tts, this._silenceDetector, this._read);

  Future<void> start(Function(String) onRecognized, Function(String) onError) async {
    await _speech.startListening(onResult: (text, isFinal) {
      // reset silence detector on every partial or final result
      _silenceDetector.reset();
      if (isFinal && text.trim().isNotEmpty) {
        onRecognized(text.trim());
      }
    });

    // When silence detected, stop listening and forward the last recognized text via onRecognized
    _silenceDetector.reset();
  }

  Future<void> stop() async {
    await _speech.stopListening();
  }

  Future<void> speakAndMaybeSave(String text, {bool saveToHistory = true}) async {
    // Save assistant message
    if (saveToHistory) {
      final box = Hive.box('conversations');
      box.add({'role': 'assistant', 'text': text, 'ts': DateTime.now().toIso8601String()});
    }

    await _tts.speak(text);
  }

  Future<String> sendToAi(String message) async {
    // get repository from provider
    final repoAsync = _read(aiRepositoryProvider);
    if (repoAsync == null) throw Exception('AI repository not available');

    final result = await repoAsync.sendMessage(message);
    return result;
  }

  void dispose() {
    _silenceDetector.dispose();
    _tts.dispose();
  }
}
