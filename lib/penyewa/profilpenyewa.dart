import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_projek/SharedPreferencesUtil.dart';
import 'package:mobile_projek/penyewa/editprofilpenyewa.dart';
import 'package:mobile_projek/users/landingPage.dart';

class ProfilPenyewa extends StatefulWidget {
  @override
  State<ProfilPenyewa> createState() => _ProfilPenyewaState();
}

class _ProfilPenyewaState extends State<ProfilPenyewa> {
  bool _isMounted = true;

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _logout(context) async {
    await SharedPreferencesUtil.clearUserDetails();

    // Tampilkan dialog konfirmasi logout
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Tampilkan snackbar dengan pesan logout berhasil
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Anda telah logout.'),
                    duration: Duration(seconds: 2),
                  ),
                );
                // Arahkan pengguna ke halaman login atau halaman awal
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _hapusAkun() async {
    try {
      if (!_isMounted) return;

      String? token = await SharedPreferencesUtil.getUserToken();
      String? idPenyewa = await SharedPreferencesUtil.getIdPenyewa();

      if (token == null || idPenyewa == null) {
        if (!_isMounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Anda belum login.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hapus Akun'),
            content: Text('Anda yakin ingin menghapus akun?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  if (_isMounted) {
                    final response = await http.delete(
                      Uri.parse('http://10.0.2.2:8000/api/akunpn/$idPenyewa'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                    );

                    if (!_isMounted) return;

                    if (response.statusCode == 200) {
                      // Hapus data penyewa dari SharedPreferences
                      await SharedPreferencesUtil.clearUserDetails();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Akun berhasil dihapus.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LandingPage()),
                      );
                    } else {
                      Map<String, dynamic> responseBody =
                          jsonDecode(response.body);
                      String errorMessage = responseBody['message'] ??
                          'Terjadi kesalahan saat menghapus akun.';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                child: Text('Hapus'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      if (!_isMounted) return;

      print('Error during account deletion: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat menghapus akun.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(216, 216, 218, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Profil',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(39, 40, 41, 1),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Container(
              height: 500,
              width: 350,
              decoration: BoxDecoration(
                color: Color.fromRGBO(216, 216, 218, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Container(
                      width: 280,
                      child: InkWell(
                        onTap: () {
                          _logout(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(39, 40, 41, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(),
                        ),
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Container(
                        width: 280,
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(39, 40, 41, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Container(
                      width: 280,
                      child: InkWell(
                        onTap: () {
                          _hapusAkun();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(39, 40, 41, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Hapus akun',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
