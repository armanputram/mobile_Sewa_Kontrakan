import 'package:flutter/material.dart';

class NotifPenyewa extends StatefulWidget {
  @override
  State<NotifPenyewa> createState() => _NotifPenyewaState();
}

class _NotifPenyewaState extends State<NotifPenyewa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 10,
      ),
      body: Center(
        child: Text(
          'NotifPenyewa',
        ),
      ),
    );
  }
}
