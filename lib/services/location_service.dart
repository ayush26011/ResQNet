import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Static fallback coordinate (New Delhi)
  static const double fallbackLatitude = 28.6139;
  static const double fallbackLongitude = 77.2090;

  /// Request location permissions from the user.
  Future<bool> requestPermission() async {
    try {
      if (kIsWeb) {
        final permission = await Geolocator.requestPermission();
        return permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always;
      } else {
        final status = await Permission.location.request();
        return status.isGranted;
      }
    } catch (_) {
      return false;
    }
  }

  /// Check if location permission is granted.
  Future<bool> hasPermission() async {
    try {
      if (kIsWeb) {
        final permission = await Geolocator.checkPermission();
        return permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always;
      } else {
        return await Permission.location.isGranted;
      }
    } catch (_) {
      return false;
    }
  }

  /// Get the current position. Returns null if unavailable or if permissions are denied.
  Future<Position?> getCurrentPosition() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) return null;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // Fetch with timeout to prevent infinite waiting
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (_) {
      return null;
    }
  }

  /// Get the last known position.
  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }

  /// Returns coordinates as a formatted string: "28.6139° N, 77.2090° E".
  Future<String> getCurrentLocationString() async {
    final pos = await getCurrentPosition() ?? await getLastKnownPosition();
    if (pos == null) {
      return '${fallbackLatitude.toStringAsFixed(4)}° N, ${fallbackLongitude.toStringAsFixed(4)}° E (Fallback)';
    }
    
    final latDir = pos.latitude >= 0 ? 'N' : 'S';
    final lonDir = pos.longitude >= 0 ? 'E' : 'W';
    return '${pos.latitude.abs().toStringAsFixed(4)}° $latDir, ${pos.longitude.abs().toStringAsFixed(4)}° $lonDir';
  }
}
