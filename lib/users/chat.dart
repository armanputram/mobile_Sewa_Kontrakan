import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 246, 224, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 246, 224, 1),
        toolbarHeight: 10,
      ),
      body: Center(
        child: Text(
          'ChatPage',
        ),
      ),
    );
  }
}
