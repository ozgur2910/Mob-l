import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ConversationPreview extends StatelessWidget {
  final int maxItems;
  const ConversationPreview({Key? key, this.maxItems = 3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('conversations');
    final items = box.values.toList().cast<Map>().reversed.take(maxItems).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var item in items) _ConversationRow(role: item['role'] ?? 'unknown', text: item['text'] ?? ''),
        if (items.isEmpty) Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('No recent conversations', style: TextStyle(color: Colors.white.withOpacity(0.6))),
        )
      ],
    );
  }
}

class _ConversationRow extends StatelessWidget {
  final String role;
  final String text;
  const _ConversationRow({Key? key, required this.role, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = role == 'user';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isUser ? Colors.blueAccent : Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(isUser ? Icons.person : Icons.smart_toy, size: 18, color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: Colors.white.withOpacity(0.9))))
        ],
      ),
    );
  }
}
