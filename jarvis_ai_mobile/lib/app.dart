import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/splash_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart';

class JarvisApp extends ConsumerWidget {
  final String initialLocation;
  JarvisApp({Key? key, this.initialLocation = '/splash'}) : super(key: key);

  late final GoRouter _router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/setup', builder: (context, state) => const FirstSetupScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'JARVIS AI',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.dark().copyWith(primary: Colors.blueAccent),
        scaffoldBackgroundColor: Colors.black,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
