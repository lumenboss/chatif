import 'package:chatiffy/screens/authentication.dart';
import 'package:chatiffy/screens/chat.dart';
import 'package:chatiffy/screens/loader.dart';
import 'package:chatiffy/themes/theme_manager.dart';
import 'package:chatiffy/themes/themes_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

ThemeManager _themeManager = ThemeManager();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return MaterialApp(
      title: 'Chatiffy',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadScreen();
            }
            if (snapshot.hasData) {
              return const ChatScreen();
            }
            return const Authentication();
          }),
    );
  }
}
