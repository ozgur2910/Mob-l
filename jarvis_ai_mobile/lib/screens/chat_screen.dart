import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  late Box _conversations;

  @override
  void initState() {
    super.initState();
    _conversations = Hive.box('conversations');
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _conversations.add({'role': 'user', 'text': text, 'ts': DateTime.now().toIso8601String()});
    _messageController.clear();
    setState(() {});
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
                  IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
