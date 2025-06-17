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
      appBar: AppBar(
        title: const Text('Control'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: controlState.when(
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
                    return ListTile(
                      title: Text(control.date!),
                      subtitle: Text(control.id!.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/controlForm',
                                arguments: control,
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // deleteDoctor(doctor.id!);
                            },
                          ),
                        ],
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
