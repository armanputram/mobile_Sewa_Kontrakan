import 'package:flutter/material.dart';
import 'package:mobile_projek/users/beranda.dart';
import 'package:mobile_projek/users/bookmark.dart';
import 'package:mobile_projek/users/chat.dart';
import 'package:mobile_projek/users/notif.dart';
import 'package:mobile_projek/users/profil.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _bottomNavCurrentIndex = 2;
  List<Widget> _container = [
    new Bookmark(),
    new ChatPage(),
    new Beranda(),
    new NotifPage(),
    new Profil()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _container[_bottomNavCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(241, 243, 245, 1),
          selectedItemColor: Colors.black,
          unselectedItemColor: Color.fromRGBO(149, 160, 190, 1),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _bottomNavCurrentIndex = index;
            });
          },
          currentIndex: _bottomNavCurrentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(Icons.bookmark, size: 35),
              ),
              label: 'Bookmark',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(Icons.message, size: 35),
              ),
              label: 'Pesan',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(Icons.home, size: 35),
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(Icons.notifications, size: 35),
              ),
              label: 'Notifikasi',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(Icons.person, size: 35),
              ),
              label: 'Profil',
            ),
          ]),
    );
  }
}
