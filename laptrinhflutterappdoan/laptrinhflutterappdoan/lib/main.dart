import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laptrinhflutterappdoan/auth/auth.dart';
import 'package:laptrinhflutterappdoan/theme/dark_mode.dart';
import 'package:laptrinhflutterappdoan/theme/light_mode.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: AuthPage(),
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
      theme: LightMode,
      darkTheme: darkMode,
    );
  }
}