import 'package:med_document/model/medicine_model.dart';

class Control {
  int? id;
  int userId;
  int doctorId;
  int medicineId;
  String? date;
  String? time;
  String? description;
  String? appointment;
  int rujuk;
  List<MedicineModel> medicine;

  Control({
    this.id,
    required this.userId,
    required this.doctorId,
    required this.medicineId,
    this.date,
    this.time,
    this.description,
    this.appointment,
    this.rujuk = 0,
    this.medicine = const [],
  });

  factory Control.fromJson(Map<String, dynamic> map) {
    return Control(
      id: map['id'],
      userId: map['userId'],
      doctorId: map['doctorId'],
      medicineId: map['medicineId'],
      date: map['date'],
      time: map['time'],
      description: map['description'],
      appointment: map['appointment'],
      rujuk: map['rujuk'] ?? 0,
      medicine:
          (map['medicine'] as List<dynamic>?)
              ?.map(
                (item) => MedicineModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'medicineId': medicineId,
      'date': date,
      'time': time,
      'description': description,
      'appointment': appointment,
      'rujuk': rujuk,
      'medicine': medicine.map((m) => m.toJson()).toList(),
    };
  }
}
