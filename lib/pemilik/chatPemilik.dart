import 'package:flutter/material.dart';

class ChatPemilik extends StatefulWidget {
  @override
  State<ChatPemilik> createState() => _ChatPemilikState();
}

class _ChatPemilikState extends State<ChatPemilik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 10,
      ),
      body: Center(
        child: Text(
          'ChatPemilik',
        ),
      ),
    );
  }
}
