import 'package:chatiffy/custom_widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth
        .instance.currentUser!; //getting currently authenticated user
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('timeSent', descending: true)
            .snapshots(), // getting a stream of chats from firebase
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), // showing circula loading spinner if chats are still loading
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                  "No messages available."), // return message if stream has no data
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                  "Something is wrong. Please try again later."), // return this text if stream emits and error
            );
          }

          final loadedMessages = snapshot.data!.docs;
          return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(
                  bottom: 40, left: 16, right: 16, top: 30),
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {
                final chatMessage = loadedMessages[index].data();
                final nextChatMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;
                final currentMessageuid = chatMessage['uid'];
                final nextMessageuid =
                    nextChatMessage != null ? nextChatMessage['uid'] : null;
                final nextUserIsSame = nextMessageuid == currentMessageuid;
                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'],
                      isMe: authenticatedUser.uid == currentMessageuid);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['path_to_image'],
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: authenticatedUser.uid == currentMessageuid);
                }
              });
        });
  }
}
