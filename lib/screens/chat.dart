import 'package:chatiffy/custom_widgets/chat_messages.dart';
import 'package:chatiffy/custom_widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("chat screen"), actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_rounded))
        ]),
        body: const Column(
          children: [Expanded(child: ChatMessages()), NewMessage()],
        ));
  }
}
