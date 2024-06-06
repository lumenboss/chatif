import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// widget class for createing a new text message
class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final messageController = TextEditingController();

// method to clear chat widget after sending text
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

// method to send message to firebase after user writes
  void sendTextMessage() async {
    if (messageController.text.trim().isEmpty) {
      return; // if message controller is empty, exit function and send nothing to firebase
    }

    FocusScope.of(context).unfocus();

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // sending text message, timestamp and user id to firebase chat collection with firebasefirestore global object
    FirebaseFirestore.instance.collection('chat').add({
      'text': messageController.text,
      'timeSent': Timestamp.now(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'username': userData.data()!['username'],
      'path_to_image': userData.data()!['url_image']
    });
    messageController
        .clear(); // clear controller of any content if it contains no text
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 2, bottom: 50),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            style: const TextStyle(color: Colors.purple),
            controller: messageController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(labelText: "Send Message ..."),
          )),

          // button to send text after user composes it
          IconButton(
            onPressed: sendTextMessage,
            icon: const Icon(Icons.send),
            color: Colors.purple,
          )
        ],
      ),
    );
  }
}
