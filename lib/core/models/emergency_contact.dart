class EmergencyContact {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String? relation;
  final bool isPrimary;
  final int createdAt;

  EmergencyContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.relation,
    this.isPrimary = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'relation': relation,
      'is_primary': isPrimary ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      phone: map['phone'],
      relation: map['relation'],
      isPrimary: map['is_primary'] == 1,
      createdAt: map['created_at'],
    );
  }
}
