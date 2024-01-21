import 'package:flutter/material.dart';
import 'package:mobile_projek/penyewa/berandapenyewa.dart';
import 'package:mobile_projek/penyewa/bookmarkpenyewa.dart';
import 'package:mobile_projek/penyewa/chatpenyewa.dart';
import 'package:mobile_projek/penyewa/notifpenyewa.dart';
import 'package:mobile_projek/penyewa/profilpenyewa.dart';

class LandingPagePenyewa extends StatefulWidget {
  @override
  State<LandingPagePenyewa> createState() => _LandingPagePenyewaState();
}

class _LandingPagePenyewaState extends State<LandingPagePenyewa> {
  int _bottomNavCurrentIndex = 2;
  List<Widget> _container = [
    BookmarkPenyewa(),
    ChatPenyewa(),
    BerandaPenyewa(),
    NotifPenyewa(),
    ProfilPenyewa()
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
