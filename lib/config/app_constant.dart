import 'package:flutter/material.dart';
import 'package:med_document/page/dashboard/home_page.dart';
import 'package:med_document/page/dashboard/setting_page.dart';

class AppConstant {
  static List<Map> dashboardMenu = [
    {'icon': Icons.home, 'title': 'Home', 'route': HomePage()},
    {'icon': Icons.settings, 'title': 'Setting', 'route': SettingPage()},
  ];
}
