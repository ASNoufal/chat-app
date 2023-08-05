import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatelessWidget {
  const NewMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: ((context, chatsnapshot) {
          if (chatsnapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
              itemCount: chatsnap.length,
              itemBuilder: (context, index) {
                return Text(chatsnap[index].data()['text']);
              });
        }));
  }
}
