import 'package:chatapp/widget/chatBuble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatelessWidget {
  const NewMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: ((context, chatsnapshot) {
          if (chatsnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatsnapshot.hasData || chatsnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("no messages"),
            );
          }

          if (chatsnapshot.hasError) {
            return const Center(child: Text("found Error"));
          }
          final chatsnap = chatsnapshot.data!.docs;
          return ListView.builder(
              reverse: true,
              itemCount: chatsnap.length,
              itemBuilder: (context, index) {
                final chatmessage = chatsnap[index].data();
                final nextchatmesssage = index + 1 < chatsnap.length
                    ? chatsnap[index + 1].data()
                    : null;

                final currantmessageuserid = chatmessage['userId'];
                final newmessageuserid = nextchatmesssage != null
                    ? nextchatmesssage['userId']
                    : null;
                final nextusersame = currantmessageuserid == newmessageuserid;

                if (nextusersame) {
                  return MessageBubble.next(
                      message: chatmessage['text'],
                      isMe: auth.uid == currantmessageuserid);
                } else {
                  return MessageBubble.first(
                      userImage: chatmessage['userimages'],
                      username: chatmessage['usernames'],
                      message: chatmessage['text'],
                      isMe: auth.uid == currantmessageuserid);
                }
              });
        }));
  }
}
