import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:go_router/go_router.dart';

import '../widgets/neon_orb.dart';
import '../features/voice/presentation/providers/voice_controller.dart';
import '../features/voice/domain/models/voice_state.dart';
import '../features/voice/widgets/voice_wave.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Initialize voice engine
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceControllerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceControllerProvider).state;
    final voiceController = ref.read(voiceControllerProvider.notifier);

    // If permission error, show a dialog
    final vcState = ref.watch(voiceControllerProvider);
    if (vcState.state == VoiceState.error && vcState.errorMessage != null && vcState.errorMessage!.contains('permission')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Microphone permission required'),
            content: const Text('This app needs microphone access to function as a voice assistant.'),
            actions: [
              TextButton(onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(voiceControllerProvider.notifier).initialize();
              }, child: const Text('Retry')),
              TextButton(onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              }, child: const Text('Open Settings')),
            ],
          ),
        );
      });
    }

    final isListening = voiceState == VoiceState.listening;
    final isProcessing = voiceState == VoiceState.processing;
    final isSpeaking = voiceState == VoiceState.speaking;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black54,
        currentIndex: 0,
        onTap: (index) {
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
        },
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
              NeonOrb(size: 220, state: voiceState),
              const SizedBox(height: 16),
              Text(
                vcState.state == VoiceState.idle ? 'Ready' : vcState.state.toString().split('.').last.capitalize(),
                style: const TextStyle(fontSize: 20, color: Colors.blueAccent),
              ),
              const SizedBox(height: 16),
              VoiceWave(visible: isListening),
              const SizedBox(height: 20),
              if (isProcessing) const CircularProgressIndicator(color: Colors.blueAccent),
              if (isSpeaking) const Icon(Icons.volume_up, size: 36, color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}

extension _Cap on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
