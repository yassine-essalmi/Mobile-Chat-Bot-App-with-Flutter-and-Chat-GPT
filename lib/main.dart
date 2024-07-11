import 'package:chat_app/chat.page.dart';
import 'package:flutter/material.dart';
import 'home.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"/chat": (context) => ChatPage()},
      theme: ThemeData(
        primaryColor: Colors.greenAccent,
        indicatorColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}
