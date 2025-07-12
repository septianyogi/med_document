class DoctorModel {
  int? id;
  String name;
  String? specialty;
  bool synced;

  DoctorModel({
    this.id,
    required this.name,
    this.specialty,
    required this.synced,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'],
      name: map['name'],
      specialty: map['specialty'],
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'synced': synced ? 1 : 0,
    };
  }
}
