import 'package:flutter/material.dart';
import 'package:mobile_projek/loginPemilik.dart';
import 'package:mobile_projek/loginPenyewa.dart';
import 'package:mobile_projek/users/landingPage.dart';

class PilihRole extends StatelessWidget {
  const PilihRole({Key? key});

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
                builder: ((context) => LandingPage()),
              ),
            );
          },
          icon: Image.asset('assets/images/arrow.png'),
        ),
        title: Text(
          'Login Sebagai',
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
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: constraints.maxHeight * 0.1,
                    ),
                    child: Container(
                      child: Image.asset('assets/images/Log1.png'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the penyewa screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPenyewa()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: Offset(
                            -constraints.maxWidth * 0.1,
                            -constraints.maxHeight * 0.05,
                          ),
                          child: SizedBox(
                            width: constraints.maxWidth * 0.4,
                            height: constraints.maxHeight * 0.1,
                            child: Transform.scale(
                              scale: 1.7,
                              child: Image.asset('assets/images/penyewa.png'),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(-constraints.maxWidth * 0.05, 0),
                          child: Text(
                            'Penyewa',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: constraints.maxWidth * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(40, 48, 72, 1.0),
                      padding: EdgeInsets.all(constraints.maxWidth * 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the pemilik screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginPemilik())),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.translate(
                            offset: Offset(constraints.maxWidth * 0.05, 0),
                            child: Text(
                              'Pemilik',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: constraints.maxWidth * 0.05,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(
                              constraints.maxWidth * 0.1,
                              -constraints.maxHeight * 0.059,
                            ),
                            child: SizedBox(
                              width: constraints.maxWidth * 0.45, //lebar button
                              height:
                                  constraints.maxHeight * 0.1, //tinggi button
                              child: Transform.scale(
                                scale: 2,
                                child:
                                    Image.asset('assets/images/pemilik2.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(40, 48, 72, 1.0),
                        padding: EdgeInsets.all(constraints.maxWidth * 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
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
