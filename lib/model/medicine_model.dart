class MedicineModel {
  int? id;
  String? uuId;
  String? name;
  String? dosage;
  String? frequency;
  int? quantity;
  String? controlId;

  MedicineModel({
    this.id,
    this.uuId,
    this.name,
    this.dosage,
    this.frequency,
    this.quantity,
    this.controlId,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id'],
      uuId: map['uuId'],
      name: map['name'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      quantity: map['quantity'],
      controlId: map['controlId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuId': uuId,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'quantity': quantity,
      'controlId': controlId,
    };
  }
}