import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/config/app_color.dart';
import 'package:med_document/config/app_format.dart';
import 'package:med_document/model/control_model.dart';
import 'package:med_document/model/medicine_model.dart';
import 'package:med_document/page/add_medicine_page.dart';
import 'package:med_document/provider/medicine_provider.dart';

class DetailControlPage extends ConsumerStatefulWidget {
  const DetailControlPage({super.key, required this.control});
  final ControlModel control;

  @override
  ConsumerState<DetailControlPage> createState() => _DetailControlPageState();
}

class _DetailControlPageState extends ConsumerState<DetailControlPage> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(medicineProvider.notifier)
          .getMedicineByControlId(widget.control.uuId!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final medicineState = ref.watch(medicineProvider);
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
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
            Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 40,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Icon(Icons.person, size: 50, color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        '${widget.control.doctorName}',
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
            ),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  decoration: BoxDecoration(
                    color: AppColor.backgroundPrimaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.backgroundWhiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Waktu Kontrol',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    size: 20,
                                    color: AppColor.primaryColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Tanggal ${AppFormat.Date(widget.control.date!)}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColor.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.watch_later_outlined,
                                    size: 20,
                                    color: AppColor.primaryColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Pukul ${widget.control.time}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColor.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.backgroundWhiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deskripsi',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${widget.control.description}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: AppColor.primaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.control.appointment != null &&
                          widget.control.appointment!.isNotEmpty)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColor.backgroundWhiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rujuk Internal',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${widget.control.appointment}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: AppColor.primaryTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.backgroundWhiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Obat',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => AddMedicinePage(
                                                controlId: widget.control.uuId,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      weight: 5,
                                      color: AppColor.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              medicineState.when(
                                data: (data) {
                                  if (data.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'Tidak ada obat',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColor.primaryTextColor,
                                        ),
                                      ),
                                    );
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final medicine = data[index];
                                      return ListTile(
                                        title: Text(
                                          medicine.name!,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: AppColor.primaryTextColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Dosis: ${medicine.dosage}, Frekuensi: ${medicine.frequency} x 1',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColor.primaryTextColor,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                error: (error, StackTrace) {
                                  return Container();
                                },
                                loading:
                                    () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
