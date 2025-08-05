import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:med_document/provider/control_provider.dart';

import '../config/app_color.dart';
import '../provider/doctor_provider.dart';
import '../provider/user_provider.dart';

class AddControlPage extends ConsumerStatefulWidget {
  const AddControlPage({super.key});

  @override
  ConsumerState<AddControlPage> createState() => _AddControlPageState();
}

class _AddControlPageState extends ConsumerState<AddControlPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String? doctorController;
  String? appointmentController;
  String? rujukController;

  String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  String setDate = DateFormat("EEE, dd MMMM yyyy").format(DateTime.now());

  Future<void> insertControl() async {
    final userId = ref.read(userProvider).value?.id ?? 1;
    final doctorName = doctorController ?? '';
    final title = titleController.text ?? '';
    final date = currentDate;
    final time = timeController.text;
    final description = descriptionController.text;
    final appointment = appointmentController;
    final rujuk = int.parse(rujukController ?? '0');

    ref
        .read(controlProvider.notifier)
        .insertControl(
          userId,
          title,
          doctorName,
          date,
          time,
          description,
          appointment,
          rujuk,
        );

    Navigator.pop(context, true); // Kembali ke halaman sebelumnya
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorProvider);

    Future<void> getDate(BuildContext context) async {
      final DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2200),
      );

      if (date != null) {
        setState(() {
          currentDate = DateFormat("yyyy-MM-dd").format(date);
          print(currentDate);
          setDate = DateFormat("EEEE, dd MMMM yyyy").format(date);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Control'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Jam',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColor.primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColor.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColor.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          child: Text(
                            setDate,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        getDate(context);
                      },
                      icon: Icon(Icons.date_range),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Jam',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColor.primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColor.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonHideUnderline(
                  child: FormField<String>(
                    validator: (value) {
                      if (doctorController == null ||
                          doctorController!.isEmpty) {
                        return 'Dokter tidak boleh kosong';
                      }
                      return null;
                    },
                    builder: (FormFieldState<String> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Dokter',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  items: doctorState.when(
                                    data: (data) {
                                      if (data.isEmpty) {
                                        return ['Tidak ada dokter']
                                            .map(
                                              (String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(item),
                                                  ),
                                            )
                                            .toList();
                                      }
                                      return data
                                          .map(
                                            (item) => DropdownMenuItem<String>(
                                              value: item.name,
                                              child: Text(
                                                item.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList();
                                    },
                                    error: (error, StackTrace) {
                                      return ['Error: $error']
                                          .map(
                                            (String item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                ),
                                          )
                                          .toList();
                                    },
                                    loading: () {
                                      return ['Loading...']
                                          .map(
                                            (String item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                ),
                                          )
                                          .toList();
                                    },
                                  ),

                                  value: doctorController,
                                  onChanged: (value) {
                                    setState(() {
                                      doctorController = value;
                                    });
                                    state.didChange(value);
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                      left: 14,
                                      right: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColor.primaryColor,
                                        width: 2,
                                      ),
                                      color: AppColor.backgroundPrimaryColor,
                                    ),
                                    elevation: 2,
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 20,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding: EdgeInsets.only(
                                      left: 14,
                                      right: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 5),
                              child: Text(
                                state.errorText ?? '',
                                style: TextStyle(
                                  color: AppColor.error,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColor.primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColor.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                DropdownButtonHideUnderline(
                  child: FormField<String>(
                    validator: (value) {
                      if (doctorController == null ||
                          doctorController!.isEmpty) {
                        return 'Dokter tidak boleh kosong';
                      }
                      return null;
                    },
                    builder: (FormFieldState<String> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Rujuk',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  items:
                                      [
                                            {'value': '1', 'nama': 'Ya'},
                                            {'value': '2', 'nama': 'Tidak'},
                                          ]
                                          .map(
                                            (item) => DropdownMenuItem<String>(
                                              value: item['value']!,
                                              child: Text(item['nama']!),
                                            ),
                                          )
                                          .toList(),

                                  value: rujukController,
                                  onChanged: (value) {
                                    setState(() {
                                      rujukController = value;
                                    });
                                    state.didChange(value);
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                      left: 14,
                                      right: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColor.primaryColor,
                                        width: 2,
                                      ),
                                      color: AppColor.backgroundPrimaryColor,
                                    ),
                                    elevation: 2,
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 20,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding: EdgeInsets.only(
                                      left: 14,
                                      right: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 5),
                              child: Text(
                                state.errorText ?? '',
                                style: TextStyle(
                                  color: AppColor.error,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonHideUnderline(
                  child: FormField<String>(
                    validator: (value) {
                      if (doctorController == null ||
                          doctorController!.isEmpty) {
                        return 'Dokter tidak boleh kosong';
                      }
                      return null;
                    },
                    builder: (FormFieldState<String> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Doker Rujukan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  items: doctorState.when(
                                    data: (data) {
                                      if (data.isEmpty) {
                                        return ['Tidak ada dokter']
                                            .map(
                                              (String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(item),
                                                  ),
                                            )
                                            .toList();
                                      }
                                      return data
                                          .map(
                                            (item) => DropdownMenuItem<String>(
                                              value: item.name,
                                              child: Text(
                                                item.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList();
                                    },
                                    error: (error, StackTrace) {
                                      return ['Error: $error']
                                          .map(
                                            (String item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                ),
                                          )
                                          .toList();
                                    },
                                    loading: () {
                                      return ['Loading...']
                                          .map(
                                            (String item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                ),
                                          )
                                          .toList();
                                    },
                                  ),

                                  value: appointmentController,
                                  onChanged: (value) {
                                    setState(() {
                                      appointmentController = value;
                                    });
                                    state.didChange(value);
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                      left: 14,
                                      right: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColor.primaryColor,
                                        width: 2,
                                      ),
                                      color: AppColor.backgroundPrimaryColor,
                                    ),
                                    elevation: 2,
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 20,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding: EdgeInsets.only(
                                      left: 14,
                                      right: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 5),
                              child: Text(
                                state.errorText ?? '',
                                style: TextStyle(
                                  color: AppColor.error,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: insertControl,
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
