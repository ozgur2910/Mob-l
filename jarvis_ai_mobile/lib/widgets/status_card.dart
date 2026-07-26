import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../features/voice/domain/models/voice_state.dart';

class StatusCard extends StatelessWidget {
  final VoiceState state;
  final String subtitle;

  const StatusCard({Key? key, required this.state, this.subtitle = ''}) : super(key: key);

  Color get _accent {
    switch (state) {
      case VoiceState.listening:
        return Colors.blueAccent;
      case VoiceState.processing:
        return Colors.cyanAccent;
      case VoiceState.speaking:
        return Colors.lightBlueAccent;
      case VoiceState.error:
        return Colors.redAccent;
      case VoiceState.idle:
      default:
        return Colors.blueGrey;
    }
  }

  IconData get _icon {
    switch (state) {
      case VoiceState.listening:
        return Icons.hearing;
      case VoiceState.processing:
        return Icons.autorenew;
      case VoiceState.speaking:
        return Icons.volume_up;
      case VoiceState.error:
        return Icons.error;
      case VoiceState.idle:
      default:
        return Icons.power_settings_new;
    }
  }

  String get _label {
    switch (state) {
      case VoiceState.listening:
        return 'Listening';
      case VoiceState.processing:
        return 'Thinking';
      case VoiceState.speaking:
        return 'Speaking';
      case VoiceState.error:
        return 'Error';
      case VoiceState.idle:
      default:
        return 'Ready';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [_accent.withOpacity(0.95), _accent.withOpacity(0.35)]),
              boxShadow: [BoxShadow(color: _accent.withOpacity(0.3), blurRadius: 12, spreadRadius: 4)],
            ),
            child: Icon(_icon, color: Colors.black87, size: 30),
          ).animate().scale(begin: 0.9, end: 1.02, duration: 600.ms).then().shake(duration: 800.ms, hz: 2),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                ]
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white38)
        ],
      ),
    );
  }
}
