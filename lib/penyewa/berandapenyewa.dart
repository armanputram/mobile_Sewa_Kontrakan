import 'package:flutter/material.dart';
import 'package:mobile_projek/propertiItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_projek/users/search.dart';

class _FilterOptions {
  int? minHarga;
  int? maxHarga;
  String selectedKategori = '';
}

class BerandaPenyewa extends StatefulWidget {
  @override
  _BerandaPenyewaState createState() => _BerandaPenyewaState();
}

class _BerandaPenyewaState extends State<BerandaPenyewa> {
  late List<Map<String, dynamic>> propertiList = [];
  late List<Map<String, dynamic>> propertiFilteredList = [];
  bool showNoResults = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _FilterOptions filterOptions = _FilterOptions();

  @override
  void initState() {
    super.initState();
    clearFilter();
    fetchData();
  }

  void clearFilter() {
    setState(() {
      filterOptions.minHarga = null;
      filterOptions.maxHarga = null;
      filterOptions.selectedKategori = '';
      propertiFilteredList = propertiList;
      showNoResults = false;
    });
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/data'));

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> tempPropertiList =
            List<Map<String, dynamic>>.from(json.decode(response.body)['data']);

        tempPropertiList.shuffle();

        setState(() {
          propertiList = tempPropertiList;
          propertiFilteredList = propertiList;
        });
      } else {
        print('Gagal memuat data properti');
      }
    } catch (error) {
      print('Error saat mengambil data: $error');
    }
  }

  void search(String query) {
    setState(() {
      propertiFilteredList = propertiList
          .where((properti) => (properti['nama'] as String)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (propertiFilteredList.isEmpty) {
        setState(() {
          propertiFilteredList = [];
          propertiFilteredList.add({'error': 'Hasil tidak ditemukan'});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 10,
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: Icon(Icons.filter_alt_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Search(onChanged: search),
            SizedBox(height: 16),
            Text(
              "Kategori",
              style: TextStyle(
                color: Color.fromRGBO(13, 45, 58, 1),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                fontSize: 28,
                letterSpacing: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryButton("Kontrakan"),
                    _buildCategoryButton("Kos"),
                    _buildCategoryButton("Apartemen"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            propertiFilteredList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: propertiFilteredList.length,
                    itemBuilder: (context, index) {
                      if (propertiFilteredList[index].containsKey('error')) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: Text(
                              propertiFilteredList[index]['error'] ?? '',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Tampilkan item properti
                        return PropertiItem(
                            properti: propertiFilteredList[index]);
                      }
                    },
                  )
                : Center(
                    child: showNoResults
                        ? Text(
                            'Hasil tidak ditemukan',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.red,
                            ),
                          )
                        : CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
      endDrawer: _buildFilterDrawer(),
    );
  }

  Widget _buildFilterDrawer() {
    TextEditingController minHargaController =
        TextEditingController(text: filterOptions.minHarga?.toString() ?? '');
    TextEditingController maxHargaController =
        TextEditingController(text: filterOptions.maxHarga?.toString() ?? '');

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(40, 48, 72, 1),
            ),
            child: Text(
              'Filter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Harga Minimum'),
            subtitle: TextField(
              controller: minHargaController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                filterOptions.minHarga =
                    value.isNotEmpty ? int.tryParse(value) : null;
              },
              decoration: InputDecoration(
                hintText: 'Masukkan harga minimum',
              ),
            ),
          ),
          ListTile(
            title: Text('Harga Maksimum'),
            subtitle: TextField(
              controller: maxHargaController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                filterOptions.maxHarga =
                    value.isNotEmpty ? int.tryParse(value) : null;
              },
              decoration: InputDecoration(
                hintText: 'Masukkan harga maksimum',
              ),
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton("Kontrakan"),
                _buildCategoryButton("Kos"),
                _buildCategoryButton("Apartemen"),
              ],
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text('Terapkan Filter'),
            onTap: () {
              _applyFilter();
            },
          ),
          ListTile(
            title: Text('Hapus Filter'),
            onTap: () {
              _resetFilter();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {
          _applyCategoryBodyFilter(category);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: filterOptions.selectedKategori == category
              ? Colors.green
              : const Color.fromRGBO(40, 48, 72, 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _applyFilter() {
    List<Map<String, dynamic>> filteredList = propertiList.where((properti) {
      int harga = properti['harga'] ?? 0;

      bool minHargaCondition =
          filterOptions.minHarga == null || harga >= filterOptions.minHarga!;

      bool maxHargaCondition =
          filterOptions.maxHarga == null || harga <= filterOptions.maxHarga!;

      bool kategoriMatched = filterOptions.selectedKategori.isEmpty ||
          (properti['nama'] as String?)!
              .toLowerCase()
              .contains(filterOptions.selectedKategori.toLowerCase());

      return minHargaCondition && maxHargaCondition && kategoriMatched;
    }).toList();

    setState(() {
      propertiFilteredList = filteredList;
      showNoResults = filteredList.isEmpty;
    });

    Navigator.pop(context);
  }

  void _applyCategoryBodyFilter(String category) {
    setState(() {
      filterOptions.selectedKategori = category;
    });
  }

  void _resetFilter() {
    clearFilter();

    Navigator.pop(context);
  }
}
