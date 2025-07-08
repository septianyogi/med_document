import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';


class AppSession {
  static Future<UserModel?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    String? userString = pref.getString('user');
    if (userString == null) return null;

    var userMap = jsonDecode(userString);
    return UserModel.fromJson(userMap);
  }

  static Future<bool> setUser(Map userMap) async {
    final pref = await SharedPreferences.getInstance();
    String userString = jsonEncode(userMap);
    bool success = await pref.setString('user', userString);
    return success;
  }

  static Future<bool> removeUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');
    return success;
  }
  
  static Future<String?> getAccessToken() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString('accessToken');
    return token;
  }

  static Future<bool> setAccessToken(String accessToken) async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.setString('accessToken', accessToken);
    return success;
  }

  static Future<bool> removeAccessToken() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('accessToken');
    return success;
  }


  // Refresh Token 
  static Future<String?> getRefreshToken() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString('refreshToken');
    return token;
  }

  static Future<bool> setRefreshToken(String refreshToken) async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.setString('refreshToken', refreshToken);
    return success;
  }

  static Future<bool> removeRefreshToken() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('refreshToken');
    return success;
  }
}