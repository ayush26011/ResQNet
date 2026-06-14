class MissingPerson {
  final String id;
  final String reporterId;
  final String name;
  final int? age;
  final double? lastKnownLat;
  final double? lastKnownLng;
  final String? description;
  final String? photoPath;
  final String? status;
  final int reportedAt;

  MissingPerson({
    required this.id,
    required this.reporterId,
    required this.name,
    this.age,
    this.lastKnownLat,
    this.lastKnownLng,
    this.description,
    this.photoPath,
    this.status,
    required this.reportedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reporter_id': reporterId,
      'name': name,
      'age': age,
      'last_known_lat': lastKnownLat,
      'last_known_lng': lastKnownLng,
      'description': description,
      'photo_path': photoPath,
      'status': status,
      'reported_at': reportedAt,
    };
  }

  factory MissingPerson.fromMap(Map<String, dynamic> map) {
    return MissingPerson(
      id: map['id'],
      reporterId: map['reporter_id'],
      name: map['name'],
      age: map['age'],
      lastKnownLat: map['last_known_lat'],
      lastKnownLng: map['last_known_lng'],
      description: map['description'],
      photoPath: map['photo_path'],
      status: map['status'],
      reportedAt: map['reported_at'],
    );
  }
}
