import 'package:flutter/material.dart';

class NotifPemilik extends StatefulWidget {
  @override
  State<NotifPemilik> createState() => _NotifPemilikState();
}

class _NotifPemilikState extends State<NotifPemilik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 246, 224, 1),
        toolbarHeight: 10,
      ),
      body: Center(
        child: Text(
          'NotifPemilik',
        ),
      ),
    );
  }
}
