import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  final AudioSession _audioSession = AudioSession.instance as AudioSession;
  Completer<void>? _completer;

  Future<void> init({String? language, double? rate, double? pitch}) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    if (language != null) {
      await _tts.setLanguage(language);
    }
    if (rate != null) await _tts.setSpeechRate(rate);
    if (pitch != null) await _tts.setPitch(pitch);

    _tts.setStartHandler(() {
      // no-op
    });
    _tts.setCompletionHandler(() {
      _completer?.complete();
      _completer = null;
    });
    _tts.setErrorHandler((msg) {
      _completer?.completeError(Exception(msg));
      _completer = null;
    });
  }

  Future<void> speak(String text) async {
    _completer = Completer<void>();
    await _tts.speak(text);
    return _completer!.future;
  }

  Future<void> stop() async {
    _completer?.complete();
    _completer = null;
    await _tts.stop();
  }

  Future<void> setLanguage(String language) async {
    await _tts.setLanguage(language);
  }

  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  void dispose() {
    // nothing to dispose for FlutterTts
  }
}
