import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static const _databaseName = "resqnet_local.db";
  static const _databaseVersion = 2;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return await openDatabase(
        _databaseName,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // 1. Users Table
    await db.execute('''
      CREATE TABLE users (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          phone TEXT,
          blood_group TEXT,
          medical_conditions TEXT,
          allergies TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
      )
    ''');

    // 2. Emergency Contacts Table
    await db.execute('''
      CREATE TABLE emergency_contacts (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          name TEXT NOT NULL,
          phone TEXT NOT NULL,
          relation TEXT,
          is_primary INTEGER DEFAULT 0,
          created_at INTEGER NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 3. First Aid Guides Table
    await db.execute('''
      CREATE TABLE first_aid_guides (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT,
          content TEXT NOT NULL,
          category TEXT,
          keywords TEXT,
          created_at INTEGER NOT NULL
      )
    ''');

    // 4. Emergency Logs Table
    await db.execute('''
      CREATE TABLE emergency_logs (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          timestamp INTEGER NOT NULL,
          latitude REAL,
          longitude REAL,
          type TEXT NOT NULL,
          status TEXT NOT NULL,
          resolved_at INTEGER,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 5. Shelters Table
    await db.execute('''
      CREATE TABLE shelters (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          type TEXT,
          capacity INTEGER,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          status TEXT
      )
    ''');

    // 6. Hospitals Table
    await db.execute('''
      CREATE TABLE hospitals (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          has_trauma_center INTEGER DEFAULT 0,
          contact_info TEXT
      )
    ''');

    // 7. Communication Logs Table
    await db.execute('''
      CREATE TABLE communication_logs (
          msg_id TEXT PRIMARY KEY,
          sender_id TEXT NOT NULL,
          receiver_id TEXT,
          payload TEXT NOT NULL,
          hop_count INTEGER DEFAULT 0,
          timestamp INTEGER NOT NULL,
          is_delivered INTEGER DEFAULT 0
      )
    ''');

    // 8. Missing Persons Table
    await db.execute('''
      CREATE TABLE missing_persons (
          id TEXT PRIMARY KEY,
          reporter_id TEXT NOT NULL,
          name TEXT NOT NULL,
          age INTEGER,
          last_known_lat REAL,
          last_known_lng REAL,
          description TEXT,
          photo_path TEXT,
          status TEXT,
          reported_at INTEGER NOT NULL
      )
    ''');

    // Indexes
    await db.execute('CREATE INDEX idx_contacts_user_id ON emergency_contacts(user_id)');
    await db.execute('CREATE INDEX idx_logs_user_id ON emergency_logs(user_id)');
    await db.execute('CREATE INDEX idx_logs_timestamp ON emergency_logs(timestamp DESC)');
    await db.execute('CREATE INDEX idx_guides_category ON first_aid_guides(category)');
    await db.execute('CREATE INDEX idx_hospitals_loc ON hospitals(latitude, longitude)');
    await db.execute('CREATE INDEX idx_shelters_loc ON shelters(latitude, longitude)');
    await db.execute('CREATE INDEX idx_comm_timestamp ON communication_logs(timestamp DESC)');

    // Initial Data Seeding
    await _seedInitialData(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('DROP TRIGGER IF EXISTS guides_after_insert');
        await db.execute('DROP TRIGGER IF EXISTS guides_after_delete');
        await db.execute('DROP TRIGGER IF EXISTS guides_after_update');
        await db.execute('DROP TABLE IF EXISTS first_aid_guides_fts');
      } catch (e) {
        // Ignore errors if the triggers or table don't exist
      }
    }
  }

  Future<void> _seedInitialData(Database db) async {
    const uuid = Uuid();
    final defaultUser = {
      'id': 'default_user_1',
      'name': 'Ayush',
      'phone': '+1234567890',
      'blood_group': 'O+',
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };
    await db.insert('users', defaultUser);

    final mockGuides = [
      {
        'id': uuid.v4(),
        'title': 'CPR for Adults',
        'description': 'Cardiac emergency. Cardiopulmonary resuscitation (CPR) is a lifesaving technique.',
        'content': 'Check the scene for safety... Give 2 rescue breaths after every 30 compressions.',
        'category': 'cpr',
        'keywords': 'heart attack, breath, pulse, chest compressions',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': uuid.v4(),
        'title': 'Minor Burns (1st & 2nd Degree)',
        'description': 'Fire & heat injuries. Minor burns affect the outer layers of skin.',
        'content': 'Cool the burn under cool (not cold) running water for 10–20 minutes...',
        'category': 'burns',
        'keywords': 'fire, heat, skin, cool water, blister',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': uuid.v4(),
        'title': 'Choking — Heimlich Maneuver',
        'description': 'Airway obstruction. Choking is a life-threatening emergency.',
        'content': 'Ask "Are you choking?" — if they cannot speak, act immediately... Give quick upward thrusts.',
        'category': 'choking',
        'keywords': 'breathe, object, airway, thrust',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      }
    ];

    for (var guide in mockGuides) {
      await db.insert('first_aid_guides', guide);
    }
  }
}
