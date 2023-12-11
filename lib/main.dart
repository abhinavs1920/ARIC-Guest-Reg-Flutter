// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(userId: 'abhishek',), // Replace with the starting screen of each app
    );
  }
}
