class MedicineModel {
  int? id;
  String? name;
  String? dosage;
  String? frequency;
  int? controlId;

  MedicineModel({
    this.id,
    this.name,
    this.dosage,
    this.frequency,
    this.controlId,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      controlId: map['controlId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'controlId': controlId,
    };
  }
}