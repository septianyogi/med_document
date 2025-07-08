import 'package:flutter/material.dart';
import 'package:med_document/page/dashboard/home_page.dart';
import 'package:med_document/page/dashboard/setting_page.dart';

class AppConstant {
  static const appName = 'Medical Document';

  static const _host = 'http://192.168.0.102:8000';

  // 103.175.220.65

  /// ``` baseURL = 'http://192.168.0.102:8000/api'
  static const baseURL = '$_host/api';

  /// ``` baseURL = 'http://192.168.0.102:8000/storage'
  static const baseImageURL = '$_host/storage';

  
  static List<Map> dashboardMenu = [
    {'icon': Icons.home, 'title': 'Home', 'route': HomePage()},
    {'icon': Icons.settings, 'title': 'Setting', 'route': SettingPage()},
  ];
}
