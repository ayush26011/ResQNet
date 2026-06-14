class Shelter {
  final String id;
  final String name;
  final String? type;
  final int? capacity;
  final double latitude;
  final double longitude;
  final String? status;

  Shelter({
    required this.id,
    required this.name,
    this.type,
    this.capacity,
    required this.latitude,
    required this.longitude,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'capacity': capacity,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

  factory Shelter.fromMap(Map<String, dynamic> map) {
    return Shelter(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      capacity: map['capacity'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: map['status'],
    );
  }
}
