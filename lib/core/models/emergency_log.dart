class EmergencyLog {
  final String id;
  final String userId;
  final int timestamp;
  final double? latitude;
  final double? longitude;
  final String type;
  final String status;
  final int? resolvedAt;

  EmergencyLog({
    required this.id,
    required this.userId,
    required this.timestamp,
    this.latitude,
    this.longitude,
    required this.type,
    required this.status,
    this.resolvedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
      'status': status,
      'resolved_at': resolvedAt,
    };
  }

  factory EmergencyLog.fromMap(Map<String, dynamic> map) {
    return EmergencyLog(
      id: map['id'],
      userId: map['user_id'],
      timestamp: map['timestamp'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      type: map['type'],
      status: map['status'],
      resolvedAt: map['resolved_at'],
    );
  }
}
