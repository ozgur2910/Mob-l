import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../features/voice/domain/models/voice_state.dart';

class NeonOrb extends StatefulWidget {
  final double size;
  final VoiceState state;
  const NeonOrb({Key? key, this.size = 220, this.state = VoiceState.idle}) : super(key: key);

  @override
  State<NeonOrb> createState() => _NeonOrbState();
}

class _NeonOrbState extends State<NeonOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double rotation = 0;
          double scale = 1.0;
          double glow = 0.2;

          switch (widget.state) {
            case VoiceState.listening:
              scale = 1.06 + (0.03 * (0.5 + 0.5 * (sin(_controller.value * 2 * 3.1415)))); // pulse
              glow = 0.7;
              break;
            case VoiceState.processing:
              rotation = _controller.value * 0.5 * 2 * 3.1415; // slow rotation
              glow = 0.45;
              break;
            case VoiceState.speaking:
              scale = 1.12 + (0.06 * (0.5 + 0.5 * (sin(_controller.value * 2 * 3.1415)))); // stronger pulse
              glow = 1.0;
              break;
            case VoiceState.idle:
            default:
              scale = 1.0 + (0.01 * (0.5 + 0.5 * (sin(_controller.value * 2 * 3.1415)))); // breathing
              glow = 0.18;
              break;
          }

          return Transform.rotate(
            angle: rotation,
            child: Transform.scale(
              scale: scale,
              child: CustomPaint(
                size: Size(size, size),
                painter: _OrbPainter(glow: glow),
                child: Center(
                  child: Container(
                    width: size * 0.52,
                    height: size * 0.52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Colors.blue.shade100, Colors.blueAccent.shade400],
                        center: Alignment(-0.2, -0.2),
                        focal: Alignment(-0.1, -0.1),
                        focalRadius: 2,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.blueAccent.withOpacity(0.8 * glow), blurRadius: 30 * glow, spreadRadius: 6 * glow),
                      ],
                    ),
                  ).animate().fade(duration: 600.ms, curve: Curves.easeOut),
                ),
              ),
            ),
          );
        },
      ).animate().scale(duration: 600.ms, curve: Curves.easeOut),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double glow;
  _OrbPainter({this.glow = 0.3});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer soft glow
    final glowPaint = Paint()
      ..shader = RadialGradient(colors: [Colors.blueAccent.withOpacity(0.25 * glow), Colors.transparent]).createShader(Rect.fromCircle(center: center, radius: radius * 1.6))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, radius * 1.6, glowPaint);

    // Outer ring
    final ringPaint = Paint()
      ..shader = SweepGradient(colors: [Colors.blueAccent.withOpacity(0.9), Colors.blue.shade200.withOpacity(0.4)], startAngle: 0, endAngle: 6.28).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 6, ringPaint);

    // Inner gradient overlay
    final innerPaint = Paint()
      ..shader = RadialGradient(colors: [Colors.blue.shade50.withOpacity(0.9), Colors.blueAccent.shade700.withOpacity(0.6)]).createShader(Rect.fromCircle(center: center, radius: radius * 0.8))
      ..blendMode = BlendMode.screen;
    canvas.drawCircle(center, radius * 0.8, innerPaint);

    // Subtle wireframe lines
    final wirePaint = Paint()..color = Colors.blueAccent.withOpacity(0.06)..style = PaintingStyle.stroke..strokeWidth = 1;
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * (0.5 + i * 0.12), wirePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) => oldDelegate.glow != glow;
}
