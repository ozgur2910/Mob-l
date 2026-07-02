import 'package:flutter/material.dart';

class NeonOrb extends StatelessWidget {
  final double size;
  const NeonOrb({Key? key, this.size = 120}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [Colors.blueAccent.withOpacity(0.9), Colors.transparent]),
        boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.6), blurRadius: 24, spreadRadius: 6)],
      ),
      child: Center(
        child: Container(
          width: size * 0.6,
          height: size * 0.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent,
            gradient: LinearGradient(colors: [Colors.blue.shade100, Colors.blueAccent]),
          ),
        ),
      ),
    );
  }
}
