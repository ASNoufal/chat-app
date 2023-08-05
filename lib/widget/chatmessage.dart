import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  var sendmessagecontroller = TextEditingController();
  @override
  void dispose() {
    sendmessagecontroller.dispose();
    super.dispose();
  }

  void onsubmitbutton() {
    final sendmessge = sendmessagecontroller.text;
    if (sendmessge.isEmpty) {
      return;
    }
    sendmessagecontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: sendmessagecontroller,
              decoration: const InputDecoration(label: Text("send a message")),
            ),
          ),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: onsubmitbutton,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
