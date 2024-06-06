import 'dart:io';

import 'package:chatiffy/custom_widgets/buttons.dart';
import 'package:chatiffy/custom_widgets/input_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  File? selectedImage;

  final formKey = GlobalKey<FormState>();

// on pressed fucntion for signup button
  void signUp(BuildContext context) async {
    final isValidate = formKey.currentState!.validate();
    if (isValidate) {
      formKey.currentState!.save();
    }

    // creating user's account with email and passord using logic from firebase
    try {
      final userCredentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // using firebase cloud storage to store image in cloud and get url to image
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredentials.user!.uid}.jpg');
      await storageReference.putFile(selectedImage!);
      final imageUrl = await storageReference.getDownloadURL();

      // using firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': usernameController.text,
        'email': emailController.text,
        'url_image': imageUrl
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Weak password")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "An account associated with this email address already exists")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // sign up form

    return Form(
        key: formKey,
        child: Expanded(
          child: ListView(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "Create an account ",
                    style: TextStyle(fontSize: 30, color: Colors.purple),
                  ),
                ),
              ),

              // email field
              Align(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.trim().contains('@')) {
                          return "Enter a proper email please";
                        }
                        return null;
                      },
                      textInputType: TextInputType.emailAddress,
                      labelText: 'Email',
                      controller: emailController,
                      width: screenWidth * 0.8,
                      prefixIcon: const Icon(Icons.email_rounded)),
                ),
              ),

              //username
              Align(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                      labelText: "Username",
                      controller: usernameController,
                      width: screenWidth * 0.8,
                      prefixIcon: const Icon(Icons.person),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 6) {
                          return "Enter a user name of at least six characters";
                        }
                        return null;
                      }),
                ),
              ),

              // password field
              Align(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 6) {
                          return "Enter a password of at least six (6) characters";
                        }
                        return null;
                      },
                      controller: passwordController,
                      labelText: 'Password',
                      width: screenWidth * 0.8,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.password_rounded)),
                ),
              ),

              // widget for user to select an image for upload
              UserImagePicker(
                onSelectedImage: (pickedImage) {
                  selectedImage = pickedImage;
                },
              ),

              // signup button
              Align(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomElevatedButton(
                      onpressed: () {
                        signUp(context);
                      },
                      content: "Sign up"),
                ),
              )
            ],
          ),
        ));
  }
}

//login class
class SignIn extends StatelessWidget {
  SignIn({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void login(BuildContext context) async {
    formKey.currentState!.validate();
    if (!context.mounted) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      print("good boy");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("No user associated with the provided email exists")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong password")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Form(
        key: formKey,
        child: Expanded(
          child: ListView(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 30, color: Colors.purple),
                  ),
                ),
              ),

              // email field
              Align(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.trim().contains('@')) {
                          return "Enter a proper email please";
                        }
                        return null;
                      },
                      textInputType: TextInputType.emailAddress,
                      labelText: 'Email',
                      controller: emailController,
                      width: screenWidth * 0.8,
                      prefixIcon: const Icon(Icons.email_rounded)),
                ),
              ),

              // password field
              Align(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 6) {
                          return "Enter a password of at least six (6) characters";
                        }
                        return null;
                      },
                      controller: passwordController,
                      labelText: 'Password',
                      width: screenWidth * 0.8,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.password_rounded)),
                ),
              ),

              // signin button
              Align(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomElevatedButton(
                      onpressed: () {
                        login(context);
                      },
                      content: "Log in"),
                ),
              )
            ],
          ),
        ));
  }
}

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool login = true;
  void toggleLogin() {
    setState(() {
      login = !login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepPurple),
      body: Column(
        children: [
          login ? SignIn() : SignUp(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.00),
            child: CustomTextButton(
                onpressed: toggleLogin,
                content: login
                    ? "Don't have an account. Signup"
                    : "Already have an account. Sign in"),
          )
        ],
      ),
    );
  }
}
