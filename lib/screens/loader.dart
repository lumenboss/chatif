import 'package:flutter/material.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({super.key});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("chat screen"),
        actions: const [Icon(Icons.person)],
      ),
      body: const Center(child: Text("Loading")),
    );
  }
}
