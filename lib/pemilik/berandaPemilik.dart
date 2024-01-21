import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_projek/SharedPreferencesUtil.dart';
import 'package:mobile_projek/pemilik/propertiItemP.dart';

class BerandaPemilik extends StatefulWidget {
  @override
  State<BerandaPemilik> createState() => _BerandaPemilikState();
}

class _BerandaPemilikState extends State<BerandaPemilik> {
  late List<Map<String, dynamic>> propertiList = [];
  late String currentUserRole;

  @override
  void initState() {
    super.initState();
    fetchData();
    loadCurrentUserRole();
  }

  Future<void> fetchData() async {
    try {
      String? token = await SharedPreferencesUtil.getUserToken();

      if (token == null) {
        print('User token not available. Redirect to login.');
        return;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/databyid'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          propertiList = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
        });
      } else {
        print(
            'Failed to load properti data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during data fetching: $error');
    }
  }

  Future<void> loadCurrentUserRole() async {
    String? role = await SharedPreferencesUtil.getUserRole();
    if (role != null) {
      setState(() {
        currentUserRole = role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Text(
                'Properti Saya',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(29, 77, 79, 1),
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 26),
              ListView.builder(
                shrinkWrap: true, // Important to prevent rendering errors
                physics: NeverScrollableScrollPhysics(), // Disable scrolling
                itemCount: propertiList.length,
                itemBuilder: (context, index) {
                  return PropertiItemP(properti: propertiList[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
