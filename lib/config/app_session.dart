import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class AppSession {
  static const String _keyUser = 'user';

  /// Menyimpan user ke SharedPreferences
  static Future<bool> setUser(UserModel user) async {
    final pref = await SharedPreferences.getInstance();
    String userString = jsonEncode(user.toJson());
    return await pref.setString(_keyUser, userString);
  }

  /// Mengambil user dari SharedPreferences
  static Future<UserModel?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final userString = pref.getString(_keyUser);

    if (userString == null) {
      return null; // Tidak ada data
    }

    try {
      final decoded = jsonDecode(userString);
      if (decoded is Map<String, dynamic>) {
        return UserModel.fromJson(decoded);
      }
      return null;
    } catch (e) {
      print("❌ Error decoding user: $e");
      return null;
    }
  }

  /// Menghapus user dari SharedPreferences
  static Future<bool> removeUser() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove(_keyUser);
  }

  static Future<String?> getAccessToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('accessToken');
  }

  static Future<bool> setAccessToken(String accessToken) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString('accessToken', accessToken);
  }

  static Future<bool> removeAccessToken() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove('accessToken');
  }

  static Future<String?> getRefreshToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('refreshToken');
  }

  static Future<bool> setRefreshToken(String refreshToken) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString('refreshToken', refreshToken);
  }

  static Future<bool> removeRefreshToken() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove('refreshToken');
  }
}
