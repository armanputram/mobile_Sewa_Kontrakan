import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_projek/SharedPreferencesUtil.dart';
import 'package:mobile_projek/getLandingPageByRole.dart';
import 'package:mobile_projek/users/landingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Launcher(),
    );
  }
}

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    startLaunching() async {
      const duration = Duration(seconds: 3);
      Timer(duration, () async {
        String? userRole = await SharedPreferencesUtil.getUserRole();
        if (userRole != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => getLandingPageByRole(userRole)),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => LandingPage()),
          );
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startLaunching();
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/Log1.png'),
                fit: BoxFit.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
