class UserModel {
  final String id;
  final String name;
  final String? phone;
  final String? bloodGroup;
  final String? medicalConditions;
  final String? allergies;
  final int createdAt;
  final int updatedAt;

  UserModel({
    required this.id,
    required this.name,
    this.phone,
    this.bloodGroup,
    this.medicalConditions,
    this.allergies,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'blood_group': bloodGroup,
      'medical_conditions': medicalConditions,
      'allergies': allergies,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      bloodGroup: map['blood_group'],
      medicalConditions: map['medical_conditions'],
      allergies: map['allergies'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
