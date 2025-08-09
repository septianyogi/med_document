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
      id: map['id'],
      rm: map['rm'],
      name: map['name'],
      sex: map['sex'],
      dob: map['dob'],
      address: map['address'],
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