import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart' as stt;

typedef OnSpeechResult = void Function(String text, bool isFinal);

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _available = false;
  OnSpeechResult? _onResult;

  Future<bool> init() async {
    _available = await _speech.initialize(onStatus: (_) {}, onError: (_) {});
    return _available;
  }

  bool get isAvailable => _available;

  Future<void> startListening({required OnSpeechResult onResult}) async {
    _onResult = onResult;
    if (!_available) {
      final ok = await init();
      if (!ok) return;
    }

    await _speech.listen(
      onResult: (result) {
        final text = result.recognizedWords;
        final isFinal = result.finalResult;
        _onResult?.call(text, isFinal);
      },
      listenMode: stt.ListenMode.confirmation,
      partialResults: true,
      onSoundLevelChange: (level) {},
    );
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  Future<void> cancel() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
  }

  double get soundLevel => _speech.lastLevel;
}
