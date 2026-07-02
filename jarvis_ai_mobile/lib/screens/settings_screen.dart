import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

const _apiKeyStorageKey = 'gemini_api_key';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _secureStorage = const FlutterSecureStorage();
  late Box _settingsBox;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box('settings');
  }

  Future<void> _clearApiKey() async {
    await _secureStorage.delete(key: _apiKeyStorageKey);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API key removed')));
  }

  Future<void> _clearConversations() async {
    await Hive.box('conversations').clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conversations cleared')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            title: const Text('Clear API Key'),
            subtitle: const Text('Remove the stored Gemini API key'),
            trailing: IconButton(onPressed: _clearApiKey, icon: const Icon(Icons.delete)),
          ),
          ListTile(
            title: const Text('Clear Conversations'),
            subtitle: const Text('Delete local conversation history'),
            trailing: IconButton(onPressed: _clearConversations, icon: const Icon(Icons.delete_forever)),
          ),
        ],
      ),
    );
  }
}
