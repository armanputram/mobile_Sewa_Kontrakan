import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransaksiPage extends StatelessWidget {
  final String idPenyewa;
  final String idProperti;
  final String tanggalMulai;
  final String tanggalSelesai;
  final int totalBiaya;
  final String status;
  final List<String> foto;

  TransaksiPage({
    required this.idPenyewa,
    required this.idProperti,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.totalBiaya,
    required this.status,
    required this.foto,
  });

  @override
  Widget build(BuildContext context) {
    // Implementasikan UI halaman transaksi sesuai kebutuhan
    // Misalnya, tampilkan informasi yang diterima dari parameter.
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Transaksi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ID Penyewa: $idPenyewa',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'ID Properti: $idProperti',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Tanggal Mulai: $tanggalMulai',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Tanggal Selesai: $tanggalSelesai',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Total Biaya: $totalBiaya',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Status: $status',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                _handleCompleteTransaction(context);
              },
              child: Text('Selesaikan Transaksi'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCompleteTransaction(BuildContext context) async {
    // Implementasikan logika untuk menyelesaikan transaksi di sini
    // Misalnya, tampilkan dialog konfirmasi atau lakukan pemrosesan transaksi.

    // Kirim data transaksi ke backend
    await _sendTransactionDataToBackend(context);

    // Setelah transaksi selesai, kembali ke halaman sebelumnya (Detail)
    Navigator.pop(context);
  }

  Future<void> _sendTransactionDataToBackend(BuildContext context) async {
    try {
      // Kirim data transaksi ke backend (gunakan endpoint KontrakController)
      String apiUrl =
          'http://10.0.2.2:8000/api/kontrak'; // Ganti sesuai URL backend Anda
      Map<String, dynamic> transactionData = {
        'id_penyewa': idPenyewa,
        'id_properti': idProperti,
        'tanggal_mulai': tanggalMulai,
        'tanggal_selesai': tanggalSelesai,
        'total_biaya': totalBiaya,
        'status': 'selesai', // Sesuaikan dengan logika backend Anda
        'foto': foto,
      };

      await http.post(Uri.parse(apiUrl), body: transactionData);

      // Tampilkan pesan sukses jika diperlukan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaksi berhasil disimpan'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Tampilkan pesan kesalahan jika terjadi error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat menyimpan transaksi'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
