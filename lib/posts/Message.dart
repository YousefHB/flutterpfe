import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  

  @override
  State<Message> createState() => _NotifState();
}

class _NotifState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Message"),
      ),
    );
  }
}