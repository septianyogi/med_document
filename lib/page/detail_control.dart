import 'package:flutter/material.dart';
import 'package:med_document/config/app_color.dart';
import 'package:med_document/config/app_format.dart';
import 'package:med_document/model/control_model.dart';

class DetailControlPage extends StatefulWidget {
  const DetailControlPage({super.key, required this.control});
  final ControlModel control;

  @override
  State<DetailControlPage> createState() => _DetailControlPageState();
}

class _DetailControlPageState extends State<DetailControlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Text(
          AppFormat.Date(widget.control.date!),
          style: const TextStyle(
            fontSize: 20,
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 40,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Icon(Icons.person, size: 70, color: Colors.white),
                        SizedBox(height: 20),
                        Text(
                          'dr. ${widget.control.doctorName}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Tanggal: ${AppFormat.Date(widget.control.date!)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColor.primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Waktu: ${widget.control.time}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColor.primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Deskripsi: ${widget.control.description}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColor.primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Rujuk: ${widget.control.rujuk == 1 ? "Ya" : "Tidak"}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColor.primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.control.appointment != null &&
                      widget.control.appointment!.isNotEmpty)
                    Text(
                      'Janji: ${widget.control.appointment}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColor.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Obat',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Icon(Icons.add, size: 20, weight: 5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
