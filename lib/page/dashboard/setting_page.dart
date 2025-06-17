import 'package:flutter/material.dart';
import 'package:med_document/config/app_color.dart';
import 'package:med_document/widget/button_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Column(
        children: [
          Row(children: [Expanded(child: ButtonWidget(text: 'User'))]),

          Row(children: [Expanded(child: ButtonWidget(text: 'Doctor'))]),
        ],
      ),
    );
  }
}
