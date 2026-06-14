/// Location service stub — will integrate with geolocator in Phase 2.
/// Currently returns a mock coordinate string.
library;

class LocationService {
  /// Returns the current GPS coordinates as a formatted string.
  /// Phase 2: Replace with `Geolocator.getCurrentPosition()`.
  Future<String> getCurrentLocation() async {
    // Stub: return a static New Delhi coordinate
    await Future.delayed(const Duration(milliseconds: 400));
    return '28.6139° N, 77.2090° E';
  }

  /// Returns true if location permission is granted.
  /// Phase 2: Use `Geolocator.checkPermission()`.
  Future<bool> hasPermission() async => false;

  /// Requests location permission from the OS.
  /// Phase 2: Use `Geolocator.requestPermission()`.
  Future<bool> requestPermission() async => false;
}
