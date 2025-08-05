import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:med_document/config/app_color.dart';
import 'package:med_document/page/add_control_page.dart';
import 'package:med_document/page/detail_control.dart';
import 'package:med_document/provider/control_provider.dart';
import 'package:med_document/provider/supabase/control_supabase_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  insertControlToSupabase(
    String uuId,
    String doctorName,
    String title,
    String date,
    String time,
    String description,
    int rujuk,
    String appointment,
  ) {
    ref
        .read(controlSupabaseProvider.notifier)
        .insertControl(
          uuId,
          doctorName,
          title,
          date,
          time,
          description,
          rujuk == 1,
          appointment,
        )
        .then((_) {
          ref.read(controlProvider.notifier).updateControlSync(uuId);
        });
  }

  @override
  Widget build(BuildContext context) {
    final controlState = ref.watch(controlProvider);
    return Scaffold(
      backgroundColor: AppColor.backgroundPrimaryColor,
      appBar: AppBar(
        title: const Text('Control'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: controlState.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('Belum ada Data'));
            }
            List sortedData = List.from(data)..sort((a, b) {
              final dateA = a.date is String ? DateTime.parse(a.date!) : a.date;
              final dateB = b.date is String ? DateTime.parse(b.date!) : b.date;
              return dateB.compareTo(dateA);
            });

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedData.length,
                    itemBuilder: (context, index) {
                      final control = sortedData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      DetailControlPage(control: control),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.backgroundWhiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${control.doctorName!}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            Text(
                                              '${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(control.date!))} (${control.time})',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  control.synced == true
                                      ? Container()
                                      : ElevatedButton(
                                        onPressed: () {
                                          insertControlToSupabase(
                                            control.uuId,
                                            control.doctorName!,
                                            control.title,
                                            control.date!,
                                            control.time!,
                                            control.description!,
                                            control.rujuk,
                                            control.appointment!,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColor.primaryColor,
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          error: (e, StackTrace) {
            return Center(child: Text(e.toString()));
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final value = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddControlPage()),
          );

          if (value == true) {
            setState(() {
              // ref.read(doctorProvider.notifier).getDoctor();
            });
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: AppColor.primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
