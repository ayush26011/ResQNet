import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../shared/models/emergency_contact.dart';
import '../shared/models/emergency_log.dart';
import '../shared/models/first_aid_guide.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static sql.Database? _database;

  DatabaseService._init();

  // Web fallback storage lists (backed by SharedPreferences)
  List<EmergencyContact> _webContacts = [];
  List<EmergencyLog> _webLogs = [];
  List<FirstAidGuide> _webGuides = [];
  SharedPreferences? _prefs;

  Future<void> init() async {
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
      _loadWebData();
    } else {
      _database = await _initDB('resqnet.db');
    }
  }

  Future<sql.Database> _initDB(String filePath) async {
    final dbPath = await sql.getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await sql.openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(sql.Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE emergency_contacts (
        id $idType,
        name $textType,
        phone $textType,
        relation $textType,
        priority $integerType,
        createdAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE first_aid_guides (
        id TEXT PRIMARY KEY,
        title $textType,
        category $textType,
        emoji $textType,
        shortDescription $textType,
        steps $textType,
        warnings $textType,
        emergencyAction $textType,
        duration $textType,
        difficulty $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE emergency_logs (
        id $idType,
        emergencyType $textType,
        latitude $realType,
        longitude $realType,
        message $textType,
        timestamp $textType,
        status $textType
      )
    ''');

    // Seed default first aid guides on table creation
    for (final guide in _defaultGuides) {
      await db.insert('first_aid_guides', guide.toMap());
    }
  }

  // ── Web Fallback Logic ──────────────────────────────────────

  void _loadWebData() {
    // 1. Load contacts
    final contactsRaw = _prefs?.getString('db_contacts');
    if (contactsRaw != null) {
      try {
        final decoded = jsonDecode(contactsRaw) as List;
        _webContacts = decoded.map((e) => EmergencyContact.fromMap(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }

    // 2. Load logs
    final logsRaw = _prefs?.getString('db_logs');
    if (logsRaw != null) {
      try {
        final decoded = jsonDecode(logsRaw) as List;
        _webLogs = decoded.map((e) => EmergencyLog.fromMap(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }

    // 3. Load guides (seed default if empty)
    final guidesRaw = _prefs?.getString('db_guides');
    if (guidesRaw != null) {
      try {
        final decoded = jsonDecode(guidesRaw) as List;
        _webGuides = decoded.map((e) => FirstAidGuide.fromMap(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }

    if (_webGuides.isEmpty) {
      _webGuides = List.from(_defaultGuides);
      _saveWebGuides();
    }
  }

  Future<void> _saveWebContacts() async {
    final encoded = jsonEncode(_webContacts.map((e) => e.toMap()).toList());
    await _prefs?.setString('db_contacts', encoded);
  }

  Future<void> _saveWebLogs() async {
    final encoded = jsonEncode(_webLogs.map((e) => e.toMap()).toList());
    await _prefs?.setString('db_logs', encoded);
  }

  Future<void> _saveWebGuides() async {
    final encoded = jsonEncode(_webGuides.map((e) => e.toMap()).toList());
    await _prefs?.setString('db_guides', encoded);
  }

  // ── Emergency Contacts CRUD ─────────────────────────────────

  Future<EmergencyContact> insertContact(EmergencyContact contact) async {
    if (kIsWeb) {
      final newId = _webContacts.isEmpty ? 1 : (_webContacts.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      final newContact = contact.copyWith(id: newId);
      _webContacts.add(newContact);
      await _saveWebContacts();
      return newContact;
    } else {
      final db = _database!;
      final id = await db.insert('emergency_contacts', contact.toMap());
      return contact.copyWith(id: id);
    }
  }

  Future<List<EmergencyContact>> getContacts() async {
    if (kIsWeb) {
      return List.from(_webContacts);
    } else {
      final db = _database!;
      final result = await db.query('emergency_contacts', orderBy: 'priority ASC, name ASC');
      return result.map((e) => EmergencyContact.fromMap(e)).toList();
    }
  }

  Future<int> deleteContact(int id) async {
    if (kIsWeb) {
      final initialLength = _webContacts.length;
      _webContacts.removeWhere((e) => e.id == id);
      await _saveWebContacts();
      return initialLength - _webContacts.length;
    } else {
      final db = _database!;
      return await db.delete(
        'emergency_contacts',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // ── First Aid Guides CRUD ───────────────────────────────────

  Future<List<FirstAidGuide>> getFirstAidGuides() async {
    if (kIsWeb) {
      return List.from(_webGuides);
    } else {
      final db = _database!;
      final result = await db.query('first_aid_guides');
      return result.map((e) => FirstAidGuide.fromMap(e)).toList();
    }
  }

  Future<List<FirstAidGuide>> searchFirstAidGuides(String query) async {
    if (query.isEmpty) return getFirstAidGuides();
    
    final lowercaseQuery = query.toLowerCase();
    if (kIsWeb) {
      return _webGuides.where((guide) {
        return guide.title.toLowerCase().contains(lowercaseQuery) ||
            guide.category.toLowerCase().contains(lowercaseQuery) ||
            guide.shortDescription.toLowerCase().contains(lowercaseQuery) ||
            guide.steps.any((s) => s.toLowerCase().contains(lowercaseQuery)) ||
            guide.warnings.any((w) => w.toLowerCase().contains(lowercaseQuery));
      }).toList();
    } else {
      final db = _database!;
      // Simple raw SQL or LIKE search
      final result = await db.query(
        'first_aid_guides',
        where: 'title LIKE ? OR category LIKE ? OR shortDescription LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
      );
      return result.map((e) => FirstAidGuide.fromMap(e)).toList();
    }
  }

  // ── Emergency Logs CRUD ──────────────────────────────────────

  Future<EmergencyLog> insertLog(EmergencyLog log) async {
    if (kIsWeb) {
      final newId = _webLogs.isEmpty ? 1 : (_webLogs.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      final newLog = log.copyWith(id: newId);
      _webLogs.add(newLog);
      await _saveWebLogs();
      return newLog;
    } else {
      final db = _database!;
      final id = await db.insert('emergency_logs', log.toMap());
      return log.copyWith(id: id);
    }
  }

  Future<List<EmergencyLog>> getLogs() async {
    if (kIsWeb) {
      return List.from(_webLogs);
    } else {
      final db = _database!;
      final result = await db.query('emergency_logs', orderBy: 'timestamp DESC');
      return result.map((e) => EmergencyLog.fromMap(e)).toList();
    }
  }

  // ── Default Seed Data ───────────────────────────────────────

  static const List<FirstAidGuide> _defaultGuides = [
    FirstAidGuide(
      id: 'cpr-adult',
      title: 'CPR for Adults',
      category: 'CPR',
      emoji: '❤️',
      shortDescription: 'Cardiopulmonary resuscitation (CPR) is a lifesaving technique useful in cardiac emergencies.',
      steps: [
        'Check the scene for safety, then check the person for responsiveness.',
        'Call emergency services (112 / 911) or ask someone else to call.',
        'Place the heel of your hand on the center of the chest.',
        'Push hard and fast: at least 2 inches deep at 100–120 compressions per minute.',
        'Give 2 rescue breaths after every 30 compressions if trained.',
        'Continue until help arrives or the person begins breathing.'
      ],
      warnings: [
        'Do not perform CPR if the person is breathing normally.',
        'Rib fractures may occur — continue CPR anyway.'
      ],
      emergencyAction: 'Start chest compressions immediately if heartbeat or breathing stops.',
      duration: '5 min read',
      difficulty: 'Critical',
    ),
    FirstAidGuide(
      id: 'cpr-child',
      title: 'CPR for Children',
      category: 'CPR',
      emoji: '👶',
      shortDescription: 'Child CPR follows similar steps to adult CPR but uses gentler compressions.',
      steps: [
        'Check responsiveness: tap shoulder and shout.',
        'Call 112 or ask a bystander to call.',
        'Use one or two hands for chest compressions (2 inches deep).',
        'Give 30 compressions at 100–120/min, then 2 gentle breaths.',
        'Continue until help arrives.'
      ],
      warnings: [
        'Use only one hand for children under 8.',
        'Do not tilt head too far back for infants.'
      ],
      emergencyAction: 'Apply compressions with one hand for smaller children.',
      duration: '4 min read',
      difficulty: 'Critical',
    ),
    FirstAidGuide(
      id: 'burns-minor',
      title: 'Minor Burns (1st & 2nd Degree)',
      category: 'Burns',
      emoji: '🔥',
      shortDescription: 'Minor burns affect the outer layers of skin. Quick first aid reduces pain.',
      steps: [
        'Cool the burn under cool (not cold) running water for 10–20 minutes.',
        'Do NOT use ice, butter, or toothpaste.',
        'Cover loosely with a sterile non-stick bandage.',
        'Take over-the-counter pain relief if needed.',
        'Do not break blisters — let them heal naturally.'
      ],
      warnings: [
        'Seek immediate help if burn is larger than 3 inches.',
        'Burns on face, hands, feet, genitals need urgent care.'
      ],
      emergencyAction: 'Flush with cool running water immediately.',
      duration: '3 min read',
      difficulty: 'Moderate',
    ),
    FirstAidGuide(
      id: 'fracture-limb',
      title: 'Limb Fractures',
      category: 'Fracture',
      emoji: '🦴',
      shortDescription: 'A fracture is a broken bone. Proper immobilization prevents further injury.',
      steps: [
        'Stop any bleeding by applying gentle pressure with a clean cloth.',
        'Immobilize the injured area — do NOT try to realign the bone.',
        'Apply ice packs wrapped in cloth to limit swelling.',
        'Elevate the injury above heart level if possible.',
        'Seek emergency medical help immediately.'
      ],
      warnings: [
        'Never move someone with a suspected spine or neck fracture.',
        'Do not apply tourniquet unless trained to do so.'
      ],
      emergencyAction: 'Immobilize the limb and keep the patient still.',
      duration: '4 min read',
      difficulty: 'High',
    ),
    FirstAidGuide(
      id: 'snakebite',
      title: 'Snake Bite Treatment',
      category: 'Snake Bite',
      emoji: '🐍',
      shortDescription: 'First aid steps for venomous and non-venomous snake bites.',
      steps: [
        'Keep the person calm and still. Movement can cause venom to travel faster.',
        'Remove any constricting clothing, rings, or jewelry near the bite.',
        'Clean the wound gently with soap and water.',
        'Apply a clean, loose dry dressing.',
        'Keep the bitten limb below the heart level if possible.',
        'Get emergency medical help immediately.'
      ],
      warnings: [
        'Do NOT cut or suck the wound.',
        'Do NOT apply a tourniquet or ice.',
        'Do NOT try to capture the snake.'
      ],
      emergencyAction: 'Call 112 / 911 immediately and note the snake\'s appearance if safe.',
      duration: '4 min read',
      difficulty: 'High',
    ),
    FirstAidGuide(
      id: 'fire-escape',
      title: 'Fire Escape & Safety',
      category: 'Fire Safety',
      emoji: '🚒',
      shortDescription: 'In a fire emergency, seconds count. Knowing the escape steps is vital.',
      steps: [
        'Alert others — yell "Fire!" and activate the fire alarm.',
        'Call emergency services immediately (112).',
        'Stay low — smoke rises, so crawl below it.',
        'Before opening doors, check for heat with the back of your hand.',
        'Use stairs — never elevators during a fire.',
        'Once out, stay out — never go back in.'
      ],
      warnings: [
        'Smoke inhalation is the #1 cause of fire deaths.',
        'Never hide under beds or in closets.'
      ],
      emergencyAction: 'Evacuate immediately. Stay low to avoid smoke.',
      duration: '4 min read',
      difficulty: 'Critical',
    ),
    FirstAidGuide(
      id: 'flood-safety',
      title: 'Flood Emergency Response',
      category: 'Flood Safety',
      emoji: '🌊',
      shortDescription: 'Floods are common water hazards. Proper response saves lives.',
      steps: [
        'Move immediately to higher ground — do not wait.',
        'Avoid walking in moving water — 6 inches can knock you down.',
        'Do not drive into flooded roads — turn around.',
        'If trapped, go to the highest level of the building.',
        'Signal for help from windows or roof with bright clothing.',
        'After flooding, avoid tap water until authorities confirm it is safe.'
      ],
      warnings: [
        '6 inches of moving water can knock an adult off their feet.',
        'Never touch electrical equipment during floods.'
      ],
      emergencyAction: 'Head to high ground immediately. Do not wade in floodwaters.',
      duration: '5 min read',
      difficulty: 'Critical',
    ),
    FirstAidGuide(
      id: 'earthquake-survival',
      title: 'Earthquake Survival Guide',
      category: 'Earthquake Safety',
      emoji: '🫨',
      shortDescription: 'Critical actions to take during and immediately after an earthquake.',
      steps: [
        'Drop to your hands and knees to prevent being knocked down.',
        'Cover your head and neck under a sturdy table or desk.',
        'Hold on to your shelter until the shaking stops.',
        'If outdoors, move to an open area away from buildings, trees, and power lines.',
        'If in a vehicle, pull over to a safe spot and stay inside.',
        'After shaking stops, check for injuries and structural damage, but expect aftershocks.'
      ],
      warnings: [
        'Do NOT use elevators during or after the shaking.',
        'Do NOT stand in doorways - tables offer better protection.'
      ],
      emergencyAction: 'Drop, Cover, and Hold On.',
      duration: '5 min read',
      difficulty: 'High',
    ),
    FirstAidGuide(
      id: 'bleeding-control',
      title: 'Severe Bleeding Control',
      category: 'Bleeding',
      emoji: '🩸',
      shortDescription: 'First aid procedures to stop major blood loss and prevent shock.',
      steps: [
        'Apply direct pressure to the wound with a clean cloth or sterile dressing.',
        'Maintain firm, continuous pressure for at least 5 minutes.',
        'If blood seeps through, place another cloth on top without removing the first.',
        'Elevate the injured limb above heart level if possible.',
        'Help the person lie down and keep them warm to prevent shock.',
        'If bleeding is life-threatening and direct pressure fails, apply a tourniquet if trained.'
      ],
      warnings: [
        'Do NOT remove embedded objects - stabilize them instead.',
        'Do NOT wash severe wounds as it may restart bleeding.'
      ],
      emergencyAction: 'Apply firm direct pressure continuously. Call 112.',
      duration: '4 min read',
      difficulty: 'High',
    ),
    FirstAidGuide(
      id: 'choking-adult',
      title: 'Choking — Heimlich Maneuver',
      category: 'Choking',
      emoji: '😮‍💨',
      shortDescription: 'Choking is a life-threatening airway obstruction.',
      steps: [
        'Ask "Are you choking?" — if they cannot speak, act immediately.',
        'Stand behind the person and wrap your arms around their waist.',
        'Make a fist with one hand, place it thumb-side against abdomen above navel.',
        'Grasp your fist with other hand, give quick upward thrusts.',
        'Repeat until object is expelled or person loses consciousness.',
        'If unconscious, begin CPR immediately.'
      ],
      warnings: [
        'Do not perform abdominal thrusts on infants — use back blows.',
        'Seek medical care after Heimlich — internal injuries may occur.'
      ],
      emergencyAction: 'Perform abdominal thrusts. Call for emergency backup.',
      duration: '3 min read',
      difficulty: 'Critical',
    ),
  ];
}
