import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static const String keyRole = 'user_role';
  static const String keyToken = 'token';
  static const String keyIdPenyewa = 'id_penyewa';
  static const String keyIdPemilik = 'id_pemilik';

  static Future<void> saveUserRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyRole, role);
  }

  static Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRole);
  }

  static Future<void> saveUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, token);
  }

  static Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }

  static Future<void> clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyRole);
    await prefs.remove(keyToken);
    // Jika Anda ingin menghapus id_penyewa juga saat membersihkan detail pengguna:
    await prefs.remove(keyIdPenyewa);
    await prefs.remove(keyIdPemilik);
  }

  static Future<void> saveIdPenyewa(String idPenyewa) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyIdPenyewa, idPenyewa);
  }

  // Metode ini tidak perlu parameter
  static Future<String?> getIdPenyewa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyIdPenyewa);
  }

  static Future<void> saveIdPemilik(String idPemilik) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyIdPemilik, idPemilik);
  }

  // Metode ini tidak perlu parameter
  static Future<String?> getIdPemilik() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyIdPemilik);
  }
}
