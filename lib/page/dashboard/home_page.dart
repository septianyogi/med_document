import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/config/app_color.dart';
import 'package:med_document/page/add_control_page.dart';
import 'package:med_document/provider/control_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final control = data[index];
                      return Padding(
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
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(control.date.toString()),
                                    Text(control.doctorId.toString()),
                                  ],
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
