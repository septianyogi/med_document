import 'package:med_document/model/medicine_model.dart';

class ControlModel {
  int? id;
  int userId;
  String? doctorName;
  String? date;
  String? time;
  String? description;
  String? appointment;
  int rujuk;
  // List<MedicineModel> medicine;

  ControlModel({
    this.id,
    required this.userId,
    this.doctorName,
    this.date,
    this.time,
    this.description,
    this.appointment,
    this.rujuk = 0,
    // this.medicine = const [],
  });

  factory ControlModel.fromJson(Map<String, dynamic> map) {
    return ControlModel(
      id: map['id'],
      userId: map['userId'],
      doctorName: map['doctorName'],
      date: map['date'],
      time: map['time'],
      description: map['description'],
      appointment: map['appointment'],
      rujuk: map['rujuk'] ?? 0,
      // medicine:
      //     (map['medicine'] as List<dynamic>?)
      //         ?.map(
      //           (item) => MedicineModel.fromJson(item as Map<String, dynamic>),
      //         )
      //         .toList() ??
      //     [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorName': doctorName,
      'date': date,
      'time': time,
      'description': description,
      'appointment': appointment,
      'rujuk': rujuk,
      // 'medicine': medicine.map((m) => m.toJson()).toList(),
    };
  }
}
