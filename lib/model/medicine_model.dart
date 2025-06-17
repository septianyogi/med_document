class MedicineModel {
  int? id;
  String? name;
  String? dosage;
  String? frequency;
  int? userId;

  MedicineModel({
    this.id,
    this.name,
    this.dosage,
    this.frequency,
    this.userId,
  });

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'userId': userId,
    };
  }
}