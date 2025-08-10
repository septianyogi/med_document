class UserModel {
  String? id;
  int rm;
  String name;
  String? sex;
  String? dob;
  String? address;

  UserModel({
    this.id,
    required this.rm,
    required this.name,
    this.sex,
    this.dob,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      rm: int.tryParse(map['rm'].toString()) ?? 0,
      name: map['name'] ?? '',
      sex: map['sex'] as String?,
      dob: map['dob'] as String?,
      address: map['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rm': rm,
      'name': name,
      'sex': sex,
      'dob': dob,
      'address': address,
    };
  }
}
