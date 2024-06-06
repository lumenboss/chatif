import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key, required this.onpressed, required this.content});

  final void Function()? onpressed;
  final String content;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onpressed, child: Text(content));
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key, required this.onpressed, required this.content});

  final void Function()? onpressed;
  final String content;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onpressed,
      style: const ButtonStyle(),
      child: Text(content),
    );
  }
}
