class UserModel {
  int? id;
  String rm;
  String name;
  String sex;
  String dob;
  String address;

  UserModel({
    this.id,
    required this.rm,
    required this.name,
    required this.sex,
    required this.dob,
    required this.address,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      rm: map['rm'],
      name: map['name'],
      sex: map['sex'],
      dob: map['dob'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
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