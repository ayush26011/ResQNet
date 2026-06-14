class Hospital {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final bool hasTraumaCenter;
  final String? contactInfo;

  Hospital({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.hasTraumaCenter = false,
    this.contactInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'has_trauma_center': hasTraumaCenter ? 1 : 0,
      'contact_info': contactInfo,
    };
  }

  factory Hospital.fromMap(Map<String, dynamic> map) {
    return Hospital(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      hasTraumaCenter: map['has_trauma_center'] == 1,
      contactInfo: map['contact_info'],
    );
  }
}
