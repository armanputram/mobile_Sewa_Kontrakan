import 'package:flutter/material.dart';
import 'package:mobile_projek/pemilik/berandaPemilik.dart';
import 'package:mobile_projek/pemilik/chatPemilik.dart';
import 'package:mobile_projek/pemilik/notifPemilik.dart';
import 'package:mobile_projek/pemilik/profilPemilik.dart';
import 'package:mobile_projek/pemilik/tambahKontrakan.dart';

class LandingPagePemilik extends StatefulWidget {
  @override
  State<LandingPagePemilik> createState() => _LandingPagePemilikState();
}

class _LandingPagePemilikState extends State<LandingPagePemilik> {
  int _bottomNavCurrentIndex = 2;
  List<Widget> _container = [
    new TambahKontrakan(),
    new ChatPemilik(),
    new BerandaPemilik(),
    new NotifPemilik(),
    new ProfilPemilik()
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
                child: Icon(Icons.add_circle_rounded, size: 35),
              ),
              label: 'Tambah',
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
