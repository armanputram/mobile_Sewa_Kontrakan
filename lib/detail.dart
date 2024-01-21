import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expandable_text/expandable_text.dart';

class Detail extends StatefulWidget {
  final Map<String, dynamic> properti;

  const Detail({Key? key, required this.properti}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool isBookmarked = false;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _loadBookmarkStatus();
  }

  void didUpdateWidget(Detail oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadBookmarkStatus();
  }

  void _loadBookmarkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBookmarked = prefs
              .getStringList('bookmarked_properties')
              ?.contains(json.encode(widget.properti)) ??
          false;
    });
  }

  void _toggleBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isBookmarked = !isBookmarked;
    });

    List<String>? bookmarkedProperties =
        prefs.getStringList('bookmarked_properties') ?? [];
    String propertiJson = json.encode(widget.properti);

    if (isBookmarked && !bookmarkedProperties.contains(propertiJson)) {
      bookmarkedProperties.add(propertiJson);
    } else if (!isBookmarked && bookmarkedProperties.contains(propertiJson)) {
      bookmarkedProperties.remove(propertiJson);
    }

    prefs.setStringList('bookmarked_properties', bookmarkedProperties);
  }

  void _removeFromBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkedProperties =
        prefs.getStringList('bookmarked_properties') ?? [];

    String propertiJson = json.encode(widget.properti);

    if (bookmarkedProperties.contains(propertiJson)) {
      bookmarkedProperties.remove(propertiJson);
      prefs.setStringList('bookmarked_properties', bookmarkedProperties);

      // Perbarui status bookmark
      _loadBookmarkStatus();
    }
  }

  Widget build(BuildContext context) {
    // Format harga menggunakan NumberFormat
    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 10,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(40, 48, 72, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: _buildMainPhoto(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.properti['nama'] ?? 'Nama Properti',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  // Format harga menggunakan NumberFormat
                                  numberFormat
                                      .format(widget.properti['harga'] ?? 0),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Icon(Icons.map_sharp,
                                    size: 20, color: Colors.lightBlue),
                                Text(
                                  widget.properti['alamat'] ??
                                      'Alamat Properti',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        'Foto',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: _buildPhotoList(),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ExpandableText(
                        widget.properti['deskripsi'] ??
                            'Deskripsi tidak tersedia',
                        expandText: 'Lihat Selengkapnya',
                        collapseText: 'Sembunyikan',
                        maxLines: 5,
                        linkColor: Colors.blue,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 200,
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            setState(() {
                              mapController = controller;
                            });
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              widget.properti['latitude'] ?? 0.0,
                              widget.properti['longitude'] ?? 0.0,
                            ), // Example coordinates
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId('property_location'),
                              position: LatLng(
                                widget.properti['latitude'] ?? 0.0,
                                widget.properti['longitude'] ?? 0.0,
                              ), // Example coordinates
                              infoWindow: InfoWindow(
                                title:
                                    widget.properti['nama'] ?? 'Nama Properti',
                              ),
                            ),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                // logika untuk menangani transaksi/sewa di sini
                // _handleSewaButtonPressed();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(60, 79, 137, 1),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart),
                    SizedBox(width: 10),
                    Text(
                      'Sewa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPhoto() {
    List<String>? photoList = widget.properti['foto'] is String
        ? List<String>.from(json.decode(widget.properti['foto']))
        : null;

    String? mainPhotoUrl = photoList?.isNotEmpty == true
        ? photoList![0].replaceAll('"', '')
        : null;

    return mainPhotoUrl != null
        ? Stack(
            children: [
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      'http://10.0.2.2:8000/images/$mainPhotoUrl',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset('assets/images/ardet.png'),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 35,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {
                    if (isBookmarked) {
                      _removeFromBookmarks();
                    } else {
                      _toggleBookmark();
                    }
                  },
                ),
              )
            ],
          )
        : Container();
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.contain, // Sesuaikan dengan kebutuhan Anda
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoList() {
    List<String>? photoList = widget.properti['foto'] is String
        ? List<String>.from(json.decode(widget.properti['foto']))
        : null;

    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (photoList?.length ?? 0),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              String imageUrl =
                  'http://10.0.2.2:8000/images/${photoList[index].replaceAll('"', '')}';
              _showFullScreenImage(imageUrl);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      'http://10.0.2.2:8000/images/${photoList![index].replaceAll('"', '')}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
