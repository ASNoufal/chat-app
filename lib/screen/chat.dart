import 'package:chatapp/widget/chatmessage.dart';
import 'package:chatapp/widget/newmessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void getnotification() async {
    final fn = FirebaseMessaging.instance;
    await fn.requestPermission();
    await fn.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    getnotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("flutter chat"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: const Column(
        children: [Expanded(child: NewMessage()), ChatMessage()],
      ),
    );
  }
}
