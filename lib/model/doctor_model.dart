class DoctorModel {
  int? id;
  String name;
  String? specialty;

  DoctorModel({
    this.id,
    required this.name,
    this.specialty,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'],
      name: map['name'],
      specialty: map['specialty'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
    };
  }
}