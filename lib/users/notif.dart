import 'package:flutter/material.dart';

class NotifPage extends StatefulWidget {
  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
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
          'NotifPage',
        ),
      ),
    );
  }
}
