import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.inputType = TextInputType.text,
  });
  final TextEditingController controller;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.width,
      this.textInputType = TextInputType.text,
      this.labelText = "",
      required this.prefixIcon,
      this.obscureText = false,
      this.radius = const Radius.circular(40),
      this.obscureCharacter = "*",
      required this.validator});

  final TextEditingController controller;
  final double width;
  final TextInputType textInputType;
  final String labelText;
  final Widget prefixIcon;
  final Radius radius;
  final bool obscureText;
  final String obscureCharacter;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: TextFormField(
          validator: validator,
          cursorHeight: 30,
          obscureText: obscureText,
          obscuringCharacter: obscureCharacter,
          style: const TextStyle(height: 1.8),
          controller: controller,
          keyboardType: textInputType,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(height: 1.8),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            prefixIcon: prefixIcon,
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(),
                borderRadius: BorderRadius.all(radius)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(),
                borderRadius: BorderRadius.all(radius)),
          ),
        ));
  }
}

// image picker

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onSelectedImage});

  final void Function(File selectedImage) onSelectedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? selectedImageFile;
  void selectImage() async {
    final selectedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 55, maxWidth: 150);

    if (selectedImage == null) {
      return;
    }

    setState(() {
      selectedImageFile = File(selectedImage.path);
    });

    widget.onSelectedImage(selectedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.deepPurpleAccent,
          foregroundImage:
              selectedImageFile == null ? null : FileImage(selectedImageFile!),
        ),
        TextButton.icon(
            onPressed: () {
              selectImage();
            },
            icon: const Icon(Icons.image),
            label: const Text("Add image"))
      ],
    );
  }
}
