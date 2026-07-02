import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/neon_orb.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum AiStatus { ready, listening, thinking, speaking }

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  AiStatus _status = AiStatus.ready;
  int _selectedIndex = 0;

  void _onMicPressed() {
    setState(() => _status = AiStatus.listening);
    Future.delayed(const Duration(seconds: 1), () => setState(() => _status = AiStatus.thinking));
    Future.delayed(const Duration(seconds: 3), () => setState(() => _status = AiStatus.speaking));
    Future.delayed(const Duration(seconds: 5), () => setState(() => _status = AiStatus.ready));
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        // home
        break;
      case 1:
        context.go('/chat');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }

  String get _statusText {
    switch (_status) {
      case AiStatus.listening:
        return 'Listening';
      case AiStatus.thinking:
        return 'Thinking';
      case AiStatus.speaking:
        return 'Speaking';
      case AiStatus.ready:
      default:
        return 'Ready';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const NeonOrb(size: 220),
              const SizedBox(height: 20),
              Text(_statusText, style: const TextStyle(fontSize: 20, color: Colors.blueAccent)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _onMicPressed,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(colors: [Colors.blueAccent, Colors.transparent]),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 20, spreadRadius: 4)],
                  ),
                  child: const Icon(Icons.mic, size: 40, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
