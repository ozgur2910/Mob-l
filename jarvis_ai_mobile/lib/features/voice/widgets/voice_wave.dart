import 'dart:math';

import 'package:flutter/material.dart';

class VoiceWave extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final bool visible;

  const VoiceWave({Key? key, this.width = 200, this.height = 60, this.color = Colors.blueAccent, this.visible = true}) : super(key: key);

  @override
  State<VoiceWave> createState() => _VoiceWaveState();
}

class _VoiceWaveState extends State<VoiceWave> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WavePainter(progress: _controller.value, color: widget.color),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final Color color;
  _WavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.7)..style = PaintingStyle.fill;
    final path = Path();
    final waveHeight = size.height / 2;
    path.moveTo(0, size.height / 2);
    for (int i = 0; i <= size.width.toInt(); i++) {
      final x = i.toDouble();
      final y = size.height / 2 + sin((x / size.width * 2 * pi) + (progress * 2 * pi)) * waveHeight * 0.3;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => oldDelegate.progress != progress;
}
