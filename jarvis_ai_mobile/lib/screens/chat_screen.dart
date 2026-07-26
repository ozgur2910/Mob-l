import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../features/ai/data/providers/gemini_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  late Box _conversations;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _conversations = Hive.box('conversations');
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Save user message locally first
    _conversations.add({'role': 'user', 'text': text, 'ts': DateTime.now().toIso8601String()});
    _messageController.clear();
    setState(() => _loading = true);

    // Resolve the repository provider (may be null if API key missing)
    final repoAsync = ref.read(aiRepositoryProvider);

    final repo = await repoAsync.when(
      data: (value) => value,
      loading: () async => null,
      error: (err, _) => null,
    );

    if (repo == null) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gemini API key missing or invalid. Please setup your API key.')));
      return;
    }

    try {
      final response = await repo.sendMessage(text);
      _conversations.add({'role': 'assistant', 'text': response, 'ts': DateTime.now().toIso8601String()});
    } catch (e) {
      // Add an assistant message indicating an error
      final msg = e.toString();
      _conversations.add({'role': 'assistant', 'text': 'Error: $msg', 'ts': DateTime.now().toIso8601String()});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AI error: $msg')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _conversations.values.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final i = items[items.length - 1 - index];
                final isUser = i['role'] == 'user';
                return ListTile(
                  title: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(i['text'] ?? ''),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_loading) const LinearProgressIndicator(minHeight: 3),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(hintText: 'Say something...'),
                    ),
                  ),
                  IconButton(onPressed: _loading ? null : _sendMessage, icon: const Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
