import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // Open default boxes used by the app
  await Hive.openBox('settings');
  await Hive.openBox('conversations');

  runApp(ProviderScope(child: JarvisApp(initialLocation: '/splash')));
}
