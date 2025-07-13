class DoctorModel {
  int? id;
  String? uuId;
  String name;
  String? specialty;
  bool synced;

  DoctorModel({
    this.id,
    this.uuId,
    required this.name,
    this.specialty,
    required this.synced,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'],
      uuId: map['uuId'] ?? '',
      name: map['name'],
      specialty: map['specialty'],
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuId': uuId,
      'name': name,
      'specialty': specialty,
      'synced': synced ? 1 : 0,
    };
  }
}
