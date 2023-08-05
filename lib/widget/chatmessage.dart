import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final sendmessagecontroller = TextEditingController();
  @override
  void dispose() {
    sendmessagecontroller.dispose();
    super.dispose();
  }

  void onsubmitbutton() async {
    final sendmessge = sendmessagecontroller.text;
    if (sendmessge.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    sendmessagecontroller.clear();
    final userid = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(userid.uid)
        .get();
    final data = userData.data();
    FirebaseFirestore.instance.collection('chat').add({
      'text': sendmessge,
      'createdAt': Timestamp.now(),
      'userId': userid.uid,
      'userimages': data!['userimage'],
      'usernames': data['username'],
    });
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
