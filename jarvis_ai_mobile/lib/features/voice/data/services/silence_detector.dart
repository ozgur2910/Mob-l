import 'dart:async';

/// Simple silence detector: call reset() whenever audio activity is detected.
/// When no activity is detected for [silenceDuration], the onSilence callback fires.
class SilenceDetector {
  final Duration silenceDuration;
  final VoidCallback onSilence;
  Timer? _timer;

  SilenceDetector({required this.onSilence, this.silenceDuration = const Duration(milliseconds: 800)});

  void reset() {
    _timer?.cancel();
    _timer = Timer(silenceDuration, onSilence);
  }

  void dispose() {
    _timer?.cancel();
  }
}
