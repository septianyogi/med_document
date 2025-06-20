import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/config/app_color.dart';
import 'package:med_document/page/doctor_page.dart';
import 'package:med_document/provider/user_provider.dart';
import 'package:med_document/widget/button_widget.dart';

import '../add_user_page.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userState.when(
              data: (data) {
                if (data == null) {
                  return const Center(child: Text('No user data found'));
                }
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RM: ${data.rm}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryTextColor,
                        ),
                      ),
                      Text(
                        'Name: ${data.id}',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Name: ${data.name}',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Tanggal Lahir: ${data.dob}',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Alamat: ${data.address}',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Jenis Kelamin: ${data.sex}',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
              error: (error, stackTrace) {
                return Center(child: Text('Error: $error'));
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddUserPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(14),
                    ),
                    child: Text(
                      'User',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColor.secondaryTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(14),
                    ),
                    child: Text(
                      'Doctor',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColor.secondaryTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
