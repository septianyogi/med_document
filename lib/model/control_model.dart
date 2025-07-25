import 'package:med_document/model/medicine_model.dart';

class ControlModel {
  int? id;
  String uuId;
  int userId;
  String? doctorName;
  String? date;
  String? time;
  String? description;
  String? appointment;
  int rujuk;
  bool synced;
  // List<MedicineModel> medicine;

  ControlModel({
    this.id,
    required this.uuId,
    required this.userId,
    this.doctorName,
    this.date,
    this.time,
    this.description,
    this.appointment,
    this.rujuk = 0,
    required this.synced,
    // this.medicine = const [],
  });

  factory ControlModel.fromJson(Map<String, dynamic> map) {
    return ControlModel(
      id: map['id'],
      uuId: map['uuId'],
      userId: map['userId'],
      doctorName: map['doctorName'],
      date: map['date'],
      time: map['time'],
      description: map['description'],
      appointment: map['appointment'],
      rujuk: map['rujuk'] ?? 0,
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuId': uuId,
      'userId': userId,
      'doctorName': doctorName,
      'date': date,
      'time': time,
      'description': description,
      'appointment': appointment,
      'rujuk': rujuk,
      'synced': synced ? 1 : 0,
    };
  }
}
