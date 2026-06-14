import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences for type-safe local storage.
/// Extend this in Phase 2 with SQLite via sqflite or drift.
class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // ── Theme ──────────────────────────────────────────────────
  bool get isDarkMode => _prefs.getBool('isDarkMode') ?? false;
  Future<void> setDarkMode(bool value) =>
      _prefs.setBool('isDarkMode', value);

  // ── User ───────────────────────────────────────────────────
  String get userName => _prefs.getString('userName') ?? 'Ayush';
  Future<void> setUserName(String value) =>
      _prefs.setString('userName', value);

  // ── Emergency contacts (stored as pipe-delimited JSON string list)
  List<String> get emergencyContacts =>
      _prefs.getStringList('emergencyContacts') ?? [];
  Future<void> setEmergencyContacts(List<String> contacts) =>
      _prefs.setStringList('emergencyContacts', contacts);

  // ── Generic helpers ────────────────────────────────────────
  Future<void> clear() => _prefs.clear();
}
