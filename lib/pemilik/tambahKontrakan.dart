import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_projek/pemilik/MapScreen.dart';
import 'package:mobile_projek/pemilik/landingPemilik.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TambahKontrakan extends StatefulWidget {
  const TambahKontrakan({Key? key}) : super(key: key);

  @override
  _TambahKontrakanState createState() => _TambahKontrakanState();
}

class _TambahKontrakanState extends State<TambahKontrakan> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController noHandphoneController = TextEditingController();
  String? noHandphoneError;
  final TextEditingController deskripsiController = TextEditingController();
  List<File> _images = [];

  final LatLng _initialPosition = LatLng(-6.2088, 106.8456);
  LatLng? _selectedPosition; // Ubah ke nullable LatLng

  GoogleMapController? _mapController;

  bool _isLocationSelected = false;

  Future<void> _getImage() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _submitData() async {
    if (_selectedPosition == null) {
      // Handle jika lokasi belum dipilih
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih lokasi pada peta terlebih dahulu'),
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    final uri = Uri.parse('http://10.0.2.2:8000/api/inputkontrakan');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['nama'] = namaController.text
      ..fields['alamat'] = alamatController.text
      ..fields['harga'] = hargaController.text
      ..fields['no_handphone'] = noHandphoneController.text
      ..fields['deskripsi'] = deskripsiController.text
      ..fields['latitude'] = _selectedPosition!.latitude.toString()
      ..fields['longitude'] = _selectedPosition!.longitude.toString();

    for (int i = 0; i < _images.length; i++) {
      String fieldName = 'foto[$i]';
      request.files.add(await http.MultipartFile.fromPath(
        fieldName,
        _images[i].path,
      ));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        print('Properti berhasil ditambahkan');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Properti berhasil diajukan'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPagePemilik()),
        );
      } else {
        print('Gagal menambahkan properti. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  bool _isValidForm() {
    return namaController.text.isNotEmpty &&
        alamatController.text.isNotEmpty &&
        hargaController.text.isNotEmpty &&
        noHandphoneController.text.isNotEmpty &&
        deskripsiController.text.isNotEmpty &&
        _images.isNotEmpty &&
        _isLocationSelected;
  }

  Widget _buildMap() {
    return Container(
      height: 200,
      child: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        markers: {
          if (_selectedPosition != null)
            Marker(
              markerId: MarkerId('selected_position'),
              position: _selectedPosition!,
            ),
        },
        onTap: (LatLng position) {
          _updateSelectedPosition(position);
        },
      ),
    );
  }

  Future<void> _selectLocationOnMap() async {
    LatLng? selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapScreen(
          initialPosition: _selectedPosition ?? _initialPosition,
          onLocationSelected: (LatLng location) {
            setState(() {
              _selectedPosition = location;
              _isLocationSelected = true;
            });
          },
        ),
      ),
    );

    if (selectedLocation != null) {
      _updateSelectedPosition(selectedLocation);
    }
  }

  void _updateSelectedPosition(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _isLocationSelected = true;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Tambah kontrakan',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(29, 77, 79, 1),
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama
                      Text(
                        'Nama Kontrakan',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(29, 77, 79, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: namaController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, bottom: 5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),

                      // Alamat
                      Text(
                        'Alamat',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(29, 77, 79, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: alamatController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, bottom: 5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),

                      // Harga
                      Text(
                        'Harga',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(29, 77, 79, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: hargaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, bottom: 5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),

                      // Nomor Handphone
                      Text(
                        'Nomor Handphone',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(29, 77, 79, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: noHandphoneController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            if (value.length < 10 || value.length > 12) {
                              noHandphoneError =
                                  'Nomor handphone harus memiliki 10-12 digit.';
                            } else {
                              noHandphoneError = null;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, bottom: 5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 2),
                          ),
                          errorText: noHandphoneError,
                        ),
                      ),

                      // Deskripsi
                      Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(29, 77, 79, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: deskripsiController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, bottom: 5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),

                      // Gambar
                      SizedBox(height: 20),
                      Text(
                        'Foto',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(29, 77, 79, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildImageList(),

                      // Peta
                      SizedBox(height: 20),
                      Text(
                        'Pilih Lokasi Kontrakan',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(29, 77, 79, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildMap(),

                      // Tombol Pilih Lokasi
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _selectLocationOnMap,
                        child: Text('Pilih Lokasi di Peta',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                      ),

                      // Tombol Submit
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isValidForm() ? _submitData : null,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Text(
                              'Ajukan',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(40, 48, 72, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageList() {
    return Row(
      children: [
        for (File image in _images) ...[
          Container(
            margin: EdgeInsets.only(right: 8),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        ElevatedButton(
          onPressed: _getImage,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 30, left: 0, right: 0),
            child: Text(
              'Tambah Foto',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
