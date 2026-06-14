class EmergencyContact {
  final int? id;
  final String name;
  final String phone;
  final String relation;
  final int priority;
  final DateTime createdAt;

  const EmergencyContact({
    this.id,
    required this.name,
    required this.phone,
    required this.relation,
    required this.priority,
    required this.createdAt,
  });

  EmergencyContact copyWith({
    int? id,
    String? name,
    String? phone,
    String? relation,
    int? priority,
    DateTime? createdAt,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: relation ?? this.relation,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'relation': relation,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      relation: map['relation'] as String,
      priority: map['priority'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
