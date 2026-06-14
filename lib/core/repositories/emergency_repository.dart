import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/emergency_log.dart';
import '../models/emergency_contact.dart';
import '../models/hospital.dart';
import '../models/shelter.dart';

class EmergencyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final _uuid = const Uuid();

  // Emergency Logs
  Future<void> createEmergencyLog(EmergencyLog log) async {
    final db = await _dbHelper.database;
    await db.insert('emergency_logs', log.toMap());
  }

  Future<List<EmergencyLog>> getLogsForUser(String userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'emergency_logs',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => EmergencyLog.fromMap(map)).toList();
  }

  // Emergency Contacts
  Future<void> addEmergencyContact(EmergencyContact contact) async {
    final db = await _dbHelper.database;
    await db.insert('emergency_contacts', contact.toMap());
  }

  Future<List<EmergencyContact>> getContactsForUser(String userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'emergency_contacts',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => EmergencyContact.fromMap(map)).toList();
  }
  
  Future<void> deleteContact(String contactId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'emergency_contacts',
      where: 'id = ?',
      whereArgs: [contactId],
    );
  }
  Future<List<Hospital>> getAllHospitals() async {
    final db = await _dbHelper.database;
    final maps = await db.query('hospitals');
    return maps.map((map) => Hospital.fromMap(map)).toList();
  }

  Future<List<Shelter>> getAllShelters() async {
    final db = await _dbHelper.database;
    final maps = await db.query('shelters');
    return maps.map((map) => Shelter.fromMap(map)).toList();
  }
}
