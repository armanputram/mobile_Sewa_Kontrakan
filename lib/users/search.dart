import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final Function(String) onChanged;

  const Search({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  size: 35,
                  color: Color.fromRGBO(29, 77, 79, 1),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _showFilterDrawer(context);
          },
          child: Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Color.fromRGBO(13, 45, 58, 1),
                width: 1.0,
              ),
            ),
            child: Icon(
              Icons.filter_alt_rounded,
              color: Color.fromRGBO(13, 45, 58, 1),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
}
