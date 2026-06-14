/// Core error types for the ResQNet app.
/// Extend this as real data layers (SQLite, HTTP, GPS) are added in Phase 2.
library;

/// Base class for all ResQNet domain errors.
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => 'AppException: $message';
}

/// Thrown when a location service fails.
class LocationException extends AppException {
  const LocationException(super.message);
}

/// Thrown when local storage read/write fails.
class StorageException extends AppException {
  const StorageException(super.message);
}

/// Thrown when an emergency alert dispatch fails.
class EmergencyException extends AppException {
  const EmergencyException(super.message);
}
