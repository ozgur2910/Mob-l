import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

const _apiKeyStorageKey = 'gemini_api_key';

class FirstSetupScreen extends StatefulWidget {
  const FirstSetupScreen({Key? key}) : super(key: key);

  @override
  State<FirstSetupScreen> createState() => _FirstSetupScreenState();
}

class _FirstSetupScreenState extends State<FirstSetupScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _secureStorage = const FlutterSecureStorage();
  bool _saving = false;

  Future<void> _saveKey() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await _secureStorage.write(key: _apiKeyStorageKey, value: _controller.text.trim());
    setState(() => _saving = false);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  void initState() {
    super.initState();
    _checkExisting();
  }

  Future<void> _checkExisting() async {
    final val = await _secureStorage.read(key: _apiKeyStorageKey);
    if (val != null && val.isNotEmpty) {
      if (!mounted) return;
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Welcome to JARVIS AI', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('To get started, paste your Gemini API key below.'),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Gemini API Key',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter API key' : null,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saving ? null : _saveKey,
                      child: _saving ? const CircularProgressIndicator() : const Text('Save & Continue'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
