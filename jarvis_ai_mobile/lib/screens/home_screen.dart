import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/neon_orb.dart';
import '../widgets/glass_panel.dart';
import '../widgets/status_card.dart';
import '../widgets/conversation_preview.dart';
import '../widgets/jarvis_bottom_navigation.dart';
import '../features/voice/presentation/providers/voice_controller.dart';
import '../features/voice/domain/models/voice_state.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceControllerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vc = ref.watch(voiceControllerProvider);
    final voiceState = vc.state;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final isPortrait = height > width;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                children: [
                  // Top: Title and status
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('JARVIS', style: TextStyle(color: Colors.blueAccent, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.6)),
                          const SizedBox(height: 4),
                          Text(vc.state == VoiceState.idle ? 'Ready' : vc.state.toString().split('.').last.capitalize(), style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      Icon(Icons.circle, color: Colors.blueAccent.withOpacity(0.2))
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Center: Orb and Status card
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NeonOrb(size: isPortrait ? 220 : 180, state: voiceState),
                          const SizedBox(height: 18),
                          GlassPanel(
                            child: SizedBox(
                              width: isPortrait ? width * 0.86 : width * 0.48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StatusCard(state: voiceState, subtitle: vc.lastTranscript ?? ''),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          GlassPanel(
                            child: SizedBox(
                              width: isPortrait ? width * 0.86 : width * 0.48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('Recent', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  ),
                                  ConversationPreview(maxItems: 3),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Bottom nav
                  JarvisBottomNavigation(currentIndex: _selectedIndex, onTap: (i) {
                    setState(() => _selectedIndex = i);
                    switch (i) {
                      case 0:
                        break;
                      case 1:
                        context.go('/chat');
                        break;
                      case 2:
                        context.go('/settings');
                        break;
                    }
                  })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

extension _Cap on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
