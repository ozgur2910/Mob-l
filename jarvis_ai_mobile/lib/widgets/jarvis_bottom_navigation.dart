import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class JarvisBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const JarvisBottomNavigation({Key? key, this.currentIndex = 0, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(3, (index) {
          final items = [Icons.home, Icons.chat_bubble, Icons.settings];
          final labels = ['Home', 'Chat', 'Settings'];
          final active = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? Colors.blueAccent.withOpacity(0.16) : Colors.transparent,
                    boxShadow: active ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.24), blurRadius: 12, spreadRadius: 2)] : null,
                  ),
                  child: Icon(items[index], color: active ? Colors.blueAccent : Colors.white38),
                ).animate().scale(begin: active ? 1.0 : 0.96, end: active ? 1.06 : 0.98, duration: 400.ms),
                const SizedBox(height: 6),
                Text(labels[index], style: TextStyle(color: active ? Colors.blueAccent : Colors.white38, fontSize: 12))
              ],
            ),
          );
        }),
      ),
    );
  }
}
