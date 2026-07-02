import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/neon_orb.dart';

const _apiKeyStorageKey = 'gemini_api_key';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1400), _goNext);
  }

  Future<void> _goNext() async {
    final apiKey = await _secureStorage.read(key: _apiKeyStorageKey);
    if (apiKey != null && apiKey.isNotEmpty) {
      if (!mounted) return;
      context.go('/home');
    } else {
      if (!mounted) return;
      context.go('/setup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            NeonOrb(size: 160),
            SizedBox(height: 24),
            Text('JARVIS AI', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
