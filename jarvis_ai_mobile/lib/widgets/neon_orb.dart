import 'dart:math';

import 'package:flutter/material.dart';
import '../../features/voice/domain/models/voice_state.dart';

class NeonOrb extends StatefulWidget {
  final double size;
  final VoiceState state;
  const NeonOrb({Key? key, this.size = 120, this.state = VoiceState.idle}) : super(key: key);

  @override
  State<NeonOrb> createState() => _NeonOrbState();
}

class _NeonOrbState extends State<NeonOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double rotation = 0;
        double scale = 1.0;
        double glow = 0.0;

        switch (widget.state) {
          case VoiceState.listening:
            scale = 1.06 + sin(_controller.value * 2 * pi) * 0.02; // pulse
            glow = 0.7;
            break;
          case VoiceState.processing:
            rotation = _controller.value * 0.5 * 2 * pi; // slow rotation
            glow = 0.4;
            break;
          case VoiceState.speaking:
            scale = 1.12 + sin(_controller.value * 2 * pi) * 0.06; // stronger pulse
            glow = 1.0;
            break;
          case VoiceState.idle:
          default:
            scale = 1.0 + sin(_controller.value * 2 * pi) * 0.01; // breathing
            glow = 0.2;
            break;
        }

        return Transform.rotate(
          angle: rotation,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [Colors.blueAccent.withOpacity(0.9 + glow * 0.1), Colors.transparent]),
              boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.6 + glow * 0.2), blurRadius: 24 + glow * 10, spreadRadius: 6 + glow * 4)],
            ),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Colors.blue.shade100, Colors.blueAccent]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
