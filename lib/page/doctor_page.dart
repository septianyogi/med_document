import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/page/add_doctor_page.dart';
import 'package:med_document/provider/doctor_provider.dart';
import 'package:med_document/widget/alert_dialog.dart';

import '../config/app_color.dart';

class DoctorPage extends ConsumerStatefulWidget {
  const DoctorPage({super.key});

  @override
  ConsumerState<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends ConsumerState<DoctorPage> {
  deleteDoctor(int id) {
    showAlertDialog(
      context: context,
      title: 'Hapus',
      content: 'Apakah anda yakin ingin menghapus dokter ini?',
      isConfirm: true,
      onConfirm: () {
        ref.read(doctorProvider.notifier).deleteDoctor(id).then((_) {
          setState(() {
            ref.read(doctorProvider.notifier).getDoctor();
          });
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorProvider);
    return Scaffold(
      backgroundColor: AppColor.backgroundPrimaryColor,
      appBar: AppBar(
        title: const Text('Doctor'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: doctorState.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('Belum ada doctor'));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final doctor = data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.backgroundWhiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'dr. ${doctor.name}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        doctor.specialty!,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColor.royalBlue,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteDoctor(doctor.id!);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColor.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: data.length,
                  ),
                ),
              ],
            ),
          );
        },
        error: (e, StackTrace) {
          return Center(child: Text(e.toString()));
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final value = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDoctorPage()),
          );

          if (value == true) {
            setState(() {
              ref.read(doctorProvider.notifier).getDoctor();
            });
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
