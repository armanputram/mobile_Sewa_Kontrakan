import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_projek/propertiItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkPenyewa extends StatefulWidget {
  @override
  State<BookmarkPenyewa> createState() => _BookmarkState();
}

class _BookmarkState extends State<BookmarkPenyewa> {
  List<Map<String, dynamic>> bookmarkedProperties = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarkedProperties();
  }

  void _loadBookmarkedProperties() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkedPropertiesJson =
        prefs.getStringList('bookmarked_properties');

    if (bookmarkedPropertiesJson != null) {
      setState(() {
        bookmarkedProperties = bookmarkedPropertiesJson
            .map((jsonString) => json.decode(jsonString))
            .toList()
            .cast<Map<String, dynamic>>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Bookmark',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(29, 77, 79, 1),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView.builder(
          itemCount: bookmarkedProperties.length,
          itemBuilder: (context, index) {
            return PropertiItem(properti: bookmarkedProperties[index]);
          },
        ),
      ),
    );
  }
}
