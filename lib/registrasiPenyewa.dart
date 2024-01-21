import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'loginPenyewa.dart';

class RegistrasiPenyewa extends StatefulWidget {
  RegistrasiPenyewa({Key? key}) : super(key: key);

  @override
  _RegistrasiPenyewaState createState() => _RegistrasiPenyewaState();
}

class _RegistrasiPenyewaState extends State<RegistrasiPenyewa> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noHPController = TextEditingController();
  String? noHPError;
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? passerror;

  Future<void> registerPenyewa(BuildContext context, String email, String noHP,
      String alamat, String password) async {
    if (email.isEmpty || noHP.isEmpty || alamat.isEmpty || password.isEmpty) {
      // Menampilkan pesan jika semua kolom belum diisi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Semua kolom harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/registrasipenyewa'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'noHP': noHP,
          'alamat': alamat,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print('Registrasi penyewa berhasil!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPenyewa()),
        );
        print('Registrasi penyewa berhasil!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPenyewa()),
        );
      } else {
        // Registrasi gagal, tampilkan pesan kesalahan kepada pengguna
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String errorMessage = responseData['error'];

        if (errorMessage.toLowerCase().contains('email')) {
          // Tampilkan pesan khusus jika kesalahan terkait email sudah terdaftar
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Registrasi Gagal'),
                content: Text('Email sudah terdaftar. Gunakan email lain.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Tampilkan pesan kesalahan umum
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Registrasi Gagal'),
                content: Text(errorMessage),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (error) {
      print('Error during registration: $error');

      // Tampilkan pesan kesalahan kepada pengguna
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registrasi Gagal'),
            content: Text('Terjadi kesalahan. Coba lagi nanti.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  String getEmailValue() => emailController.text;
  String getNoHPValue() => noHPController.text;
  String getAlamatValue() => alamatController.text;
  String getPasswordValue() => passwordController.text;

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
                builder: ((context) => LoginPenyewa()),
              ),
            );
          },
          icon: Image.asset('assets/images/arrow.png'),
        ),
        title: Text(
          'Registrasi penyewa',
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
                          // Setiap kali nilai berubah, periksa apakah panjangnya kurang dari 10
                          // Jika iya, tampilkan pesan kesalahan, jika tidak, hapus pesan kesalahan
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
                          // Setiap kali nilai berubah, periksa apakah panjangnya kurang dari 10
                          // Jika iya, tampilkan pesan kesalahan, jika tidak, hapus pesan kesalahan
                          if (value.length < 6) {
                            passerror =
                                'Password setidaknya harus memiliki 6 karakter.';
                          } else {
                            passerror = null;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        errorText: passerror,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 1, top: 1, right: 50, left: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          String email = getEmailValue();
                          String noHP = getNoHPValue();
                          String alamat = getAlamatValue();
                          String password = getPasswordValue();

                          registerPenyewa(
                              context, email, noHP, alamat, password);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(
                              top: 3, bottom: 3, right: 80, left: 80),
                          backgroundColor: const Color.fromRGBO(40, 48, 72, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: Text(
                          "Daftar",
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
                  Container(
                    padding: EdgeInsets.only(
                        top: 1, bottom: 50, left: 80, right: 80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sudah punya Akun?",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPenyewa()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[500],
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromRGBO(60, 139, 23, 1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
