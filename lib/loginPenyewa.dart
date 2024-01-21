import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_projek/SharedPreferencesUtil.dart';
import 'package:mobile_projek/penyewa/landingpagePenyewa.dart';
import 'package:mobile_projek/pilihRole.dart';
import 'package:mobile_projek/registrasiPenyewa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPenyewa extends StatefulWidget {
  const LoginPenyewa({Key? key}) : super(key: key);

  @override
  _LoginPenyewaState createState() => _LoginPenyewaState();
}

class _LoginPenyewaState extends State<LoginPenyewa> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/loginpenyewa'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final String token = responseData['token'];
      final String idPenyewa = responseData['id_penyewa'].toString();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('id_penyewa', idPenyewa);

      if (responseData.containsKey('role')) {
        final String role = responseData['role'];
        await SharedPreferencesUtil.saveUserRole(role);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPagePenyewa()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal. Status Code: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Login gagal. Status Code: ${response.statusCode}');
    }
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
                builder: (context) => PilihRole(),
              ),
            );
          },
          icon: Image.asset('assets/images/arrow.png'),
        ),
        title: Text(
          'Login Penyewa',
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
                    child: Image.asset('assets/images/Log1.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 20, right: 20),
                    child: Text(
                      "Alamat email",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Color.fromRGBO(29, 77, 79, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        top: 20, bottom: 5, left: 20, right: 20),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        hintText: "password",
                        hintStyle: TextStyle(color: Colors.grey[300]),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () async {
                          String email = emailController.text;
                          String password = passwordController.text;

                          await loginUser(context, email, password);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(40, 48, 72, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Login",
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
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Belum punya akun?",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => RegistrasiPenyewa()),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[500],
                            ),
                            child: const Text(
                              "Daftar",
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
