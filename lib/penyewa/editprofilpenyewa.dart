import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_projek/SharedPreferencesUtil.dart';

import 'package:mobile_projek/penyewa/landingpagePenyewa.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noHPController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? noHPError;
  String? passError;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    noHPController.dispose();
    alamatController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> editProfile() async {
    setState(() {
      isLoading = true;
    });

    String? token = await SharedPreferencesUtil.getUserToken();
    String? idPenyewa = await SharedPreferencesUtil.getIdPenyewa();

    if (token == null || idPenyewa == null) {
      // Handle ketika token atau ID Penyewa tidak ditemukan
      print('Token atau ID Penyewa tidak ditemukan. Silakan login kembali.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Token atau ID Penyewa tidak ditemukan. Silakan login kembali.',
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    Map<String, dynamic> body = {};

    // Tambahkan data ke body hanya jika pengguna mengisi field tersebut
    if (emailController.text.isNotEmpty) {
      body['email'] = emailController.text;
    }

    if (noHPController.text.isNotEmpty) {
      body['noHP'] = noHPController.text;
    }

    if (alamatController.text.isNotEmpty) {
      body['alamat'] = alamatController.text;
    }

    if (passwordController.text.isNotEmpty) {
      body['password'] = passwordController.text;
    }

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/editprofilpenyewa/$idPenyewa'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Profil berhasil diperbarui.');
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      print('Gagal memperbarui profil. Status Code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui profil. Coba lagi nanti.'),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => LandingPagePenyewa()),
              ),
            );
          },
          icon: Image.asset('assets/images/arrow.png'),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color.fromRGBO(29, 77, 79, 1.0),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/images/Log1.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 20, right: 20),
                    child: Text(
                      "Alamat Email",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Color.fromRGBO(29, 77, 79, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "user@gmail.com",
                        hintStyle: TextStyle(color: Colors.grey[300]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1, bottom: 5, left: 20, right: 20),
                    child: Text(
                      "No. Handphone",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Color.fromRGBO(29, 77, 79, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: noHPController,
                      onChanged: (value) {
                        setState(() {
                          if (value.length < 10) {
                            noHPError =
                                'Nomor handphone harus memiliki setidaknya 10 digit.';
                          } else {
                            noHPError = null;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "No. Handphone",
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        errorText: noHPError,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1, bottom: 5, left: 20, right: 20),
                    child: Text(
                      "Alamat",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Color.fromRGBO(29, 77, 79, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      controller: alamatController,
                      decoration: InputDecoration(
                        hintText: "Alamat",
                        hintStyle: TextStyle(color: Colors.grey[300]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1, bottom: 5, left: 20, right: 20),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Color.fromRGBO(29, 77, 79, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1, bottom: 5, left: 20, right: 20),
                    child: TextField(
                      controller: passwordController,
                      onChanged: (value) {
                        setState(() {
                          if (value.length < 6) {
                            passError =
                                'Password setidaknya harus memiliki 6 karakter.';
                          } else {
                            passError = null;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        errorText: passError,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 1, top: 1, right: 50, left: 50),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : editProfile,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(
                              top: 3, bottom: 3, right: 80, left: 80),
                          backgroundColor: const Color.fromRGBO(40, 48, 72, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: Text(
                          "Simpan",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
