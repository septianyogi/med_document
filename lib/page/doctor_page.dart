import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/page/add_doctor_page.dart';
import 'package:med_document/provider/doctor_provider.dart';
import 'package:med_document/provider/supabase/doctor_supabase_provider.dart';
import 'package:med_document/widget/alert_dialog.dart';

import '../config/app_color.dart';

class DoctorPage extends ConsumerStatefulWidget {
  const DoctorPage({super.key});

  @override
  ConsumerState<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends ConsumerState<DoctorPage> {
  deleteDoctor(String uuId) {
    showAlertDialog(
      context: context,
      title: 'Hapus',
      content: 'Apakah anda yakin ingin menghapus dokter ini?',
      isConfirm: true,
      onConfirm: () {
        ref.read(doctorProvider.notifier).deleteDoctor(uuId).then((_) {
          ref.read(doctorSupabaseProvider.notifier).deleteDoctor(uuId);
          // Setelah menghapus, ambil ulang data dokter
          setState(() {
            ref.read(doctorProvider.notifier).getDoctor();
          });
        });
        Navigator.pop(context);
      },
    );
  }

  insertDoctorToSupabase(String uuId, String name, String specialty) {
    ref
        .read(doctorSupabaseProvider.notifier)
        .insertDoctor(uuId, name, specialty);
    ref.read(doctorProvider.notifier).updateDoctorSync(uuId);
    setState(() {
      ref.read(doctorProvider.notifier).getDoctor();
    });
  }

  syncDoctor() {
    ref.read(doctorProvider.notifier).syncDoctorFromSupabase();
    setState(() {
      ref.read(doctorProvider.notifier).getDoctor();
    });
  }

  @override
  void initState() {
    syncDoctor();
    super.initState();
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
            return const Center(child: Text('Doctor is empty'));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${doctor.name}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            '${doctor.specialty!}${doctor.id}${doctor.uuId}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
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
                                        deleteDoctor(doctor.uuId!);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColor.error,
                                      ),
                                    ),
                                  ],
                                ),
                                doctor.synced == true
                                    ? Container()
                                    : ElevatedButton(
                                      onPressed: () {
                                        insertDoctorToSupabase(
                                          doctor.uuId!,
                                          doctor.name,
                                          doctor.specialty!,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                      ),
                                      child: Text(
                                        'Synchronize',
                                        style: TextStyle(
                                          color: AppColor.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
              ref.read(doctorSupabaseProvider.notifier).getDoctor();
            });
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: AppColor.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
