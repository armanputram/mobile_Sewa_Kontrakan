import 'package:flutter/material.dart';
import 'package:mobile_projek/propertiItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_projek/users/search.dart';

// Kelas untuk menyimpan opsi filter
class _FilterOptions {
  int? minHarga;
  int? maxHarga;
  String selectedKategori = '';
}

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  // List untuk menyimpan data properti
  late List<Map<String, dynamic>> propertiList = [];
  late List<Map<String, dynamic>> propertiFilteredList = [];
  bool showNoResults = false; // Flag untuk menampilkan pesan "No Results"

  // Global key untuk widget scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Instance opsi filter
  _FilterOptions filterOptions = _FilterOptions();

  @override
  void initState() {
    super.initState();
    clearFilter(); // Panggil fungsi clearFilter untuk mengatur ulang filter
    fetchData(); // Ambil data properti dari API
  }

  // Fungsi untuk mengatur ulang filter
  void clearFilter() {
    setState(() {
      filterOptions.minHarga = null;
      filterOptions.maxHarga = null;
      filterOptions.selectedKategori = '';
      propertiFilteredList = propertiList;
      showNoResults = false;
    });
  }

  // Fungsi untuk mengambil data properti dari API
  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/data'));

      if (response.statusCode == 200) {
        setState(() {
          propertiList = List<Map<String, dynamic>>.from(
              json.decode(response.body)['data']);
          propertiFilteredList = propertiList;
        });
      } else {
        // Tangani kesalahan saat memuat data properti
        print('Gagal memuat data properti');
      }
    } catch (error) {
      // Tangani kesalahan jaringan atau lainnya saat pengambilan data
      print('Error saat mengambil data: $error');
    }
  }

  // Fungsi untuk melakukan pencarian berdasarkan input pengguna
  void search(String query) {
    setState(() {
      propertiFilteredList = propertiList
          .where((properti) => (properti['nama'] as String)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });

    // Fungsi tunggu 2 detik sebelum menampilkan pesan jika tidak ada data yang ditemukan
    Future.delayed(const Duration(seconds: 2), () {
      if (propertiFilteredList.isEmpty) {
        setState(() {
          propertiFilteredList =
              []; // Hapus data yang mungkin telah dimuat sebelumnya
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
            // Widget Pencarian
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
            // Widget Kategori
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
            // Tampilkan properti dalam bentuk list
            propertiFilteredList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: propertiFilteredList.length,
                    itemBuilder: (context, index) {
                      if (propertiFilteredList[index].containsKey('error')) {
                        // Tampilkan pesan jika tidak ada data yang ditemukan
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

  // Widget untuk membangun drawer filter
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

  // Widget untuk membangun tombol kategori
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

  // Fungsi untuk menerapkan filter
  void _applyFilter() {
    List<Map<String, dynamic>> filteredList = propertiList.where((properti) {
      int harga = properti['harga'] ?? 0;

      // Periksa jika minHarga diatur dan terapkan filter
      bool minHargaCondition =
          filterOptions.minHarga == null || harga >= filterOptions.minHarga!;

      // Periksa jika maxHarga diatur dan terapkan filter
      bool maxHargaCondition =
          filterOptions.maxHarga == null || harga <= filterOptions.maxHarga!;

      // Periksa jika kategori diatur dan terapkan filter
      bool kategoriMatched = filterOptions.selectedKategori.isEmpty ||
          (properti['nama'] as String?)!
              .toLowerCase()
              .contains(filterOptions.selectedKategori.toLowerCase());

      // Gabungkan semua kondisi
      return minHargaCondition && maxHargaCondition && kategoriMatched;
    }).toList();

    // Perbarui filtered list dan flag showNoResults
    setState(() {
      propertiFilteredList = filteredList;
      showNoResults = filteredList.isEmpty;
    });

    // Tutup drawer filter
    Navigator.pop(context);
  }

  // Fungsi untuk menerapkan filter kategori
  void _applyCategoryBodyFilter(String category) {
    setState(() {
      filterOptions.selectedKategori = category;
    });
  }

  // Fungsi untuk mereset semua filter
  void _resetFilter() {
    // Panggil clearFilter untuk mereset filter
    clearFilter();

    // Tutup drawer filter
    Navigator.pop(context);
  }
}
