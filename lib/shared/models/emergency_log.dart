class EmergencyLog {
  final int? id;
  final String emergencyType;
  final double latitude;
  final double longitude;
  final String message;
  final DateTime timestamp;
  final String status;

  const EmergencyLog({
    this.id,
    required this.emergencyType,
    required this.latitude,
    required this.longitude,
    required this.message,
    required this.timestamp,
    required this.status,
  });

  EmergencyLog copyWith({
    int? id,
    String? emergencyType,
    double? latitude,
    double? longitude,
    String? message,
    DateTime? timestamp,
    String? status,
  }) {
    return EmergencyLog(
      id: id ?? this.id,
      emergencyType: emergencyType ?? this.emergencyType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'emergencyType': emergencyType,
      'latitude': latitude,
      'longitude': longitude,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  factory EmergencyLog.fromMap(Map<String, dynamic> map) {
    return EmergencyLog(
      id: map['id'] as int?,
      emergencyType: map['emergencyType'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      message: map['message'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      status: map['status'] as String,
    );
  }
}
