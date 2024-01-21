import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class PropertiItemP extends StatelessWidget {
  final Map<String, dynamic> properti;

  const PropertiItemP({required this.properti});

  @override
  Widget build(BuildContext context) {
    List<String> fotoList = properti['foto'] != null
        ? List<String>.from(json.decode(properti['foto']))
        : [];

    String mainPhotoUrl =
        fotoList.isNotEmpty ? fotoList[0].replaceAll('"', '') : '';

    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp');

    // Tentukan warna berdasarkan nilai status
    Color statusColor = Colors.green; // Default warna untuk status 'setuju'
    if (properti['status'] == 'menunggu') {
      statusColor = Colors.grey;
    } else if (properti['status'] == 'tolak') {
      statusColor = Colors.red;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(40, 48, 72, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            child: InkWell(
              onTap: () {
                // Handle onTap event
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        "http://10.0.2.2:8000/images/$mainPhotoUrl",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    properti['nama'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  numberFormat.format(properti['harga']),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.map_sharp,
                  color: Colors.lightBlue,
                  size: 20,
                ),
              ),
              Text(
                properti['alamat'] ?? '',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: Colors.lightBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Text(
                  'Status:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                properti['status'] ?? '',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
