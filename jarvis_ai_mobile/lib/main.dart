import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';

const _apiKeyStorageKey = 'gemini_api_key';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // Open default boxes used by the app
  await Hive.openBox('settings');
  await Hive.openBox('conversations');

  final secureStorage = const FlutterSecureStorage();
  final apiKey = await secureStorage.read(key: _apiKeyStorageKey);

  final initialRoute = (apiKey == null || apiKey.isEmpty) ? '/setup' : '/home';

  runApp(ProviderScope(child: JarvisApp(initialLocation: initialRoute)));
}
