import 'package:flutter/material.dart';

class VoiceWave extends StatelessWidget {
  final bool visible;
  const VoiceWave({Key? key, this.visible = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 220,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + index * 100),
            curve: Curves.easeInOut,
            width: 6,
            height: 20 + (index * 6).toDouble(),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
