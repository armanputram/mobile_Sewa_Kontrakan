import 'package:flutter/material.dart';

class ChatPenyewa extends StatefulWidget {
  @override
  State<ChatPenyewa> createState() => _ChatPenyewaState();
}

class _ChatPenyewaState extends State<ChatPenyewa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 10,
      ),
      body: Center(
        child: Text(
          'ChatPenyewa',
        ),
      ),
    );
  }
}
