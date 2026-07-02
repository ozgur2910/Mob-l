---
layout: file
---

Voice feature implemented (V1) with speech-to-text, tts, silence detection and a Riverpod controller.

Files added:
- lib/features/voice/domain/models/voice_state.dart
- lib/features/voice/data/services/silence_detector.dart
- lib/features/voice/data/services/speech_service.dart
- lib/features/voice/data/services/tts_service.dart
- lib/features/voice/data/services/voice_service.dart
- lib/features/voice/presentation/providers/voice_controller.dart
- lib/features/voice/widgets/voice_wave.dart
- lib/features/voice/widgets/voice_wave_placeholder.dart (aux)

Home screen now auto-initializes the voice engine and reflects states in the NeonOrb and VoiceWave.
