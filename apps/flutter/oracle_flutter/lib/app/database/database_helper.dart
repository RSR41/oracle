import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

/// Central database helper for SQLite operations.
/// Manages schema creation and provides database access.
class DatabaseHelper {
  static const String _databaseName = 'oracle_app.db';
  static const int _databaseVersion = 3;

  // Singleton pattern
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _databaseName);
      debugPrint('Opening database at: $path');

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      debugPrint('CRITICAL DATABASE ERROR: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Main history table - flexible schema for all feature types
    await db.execute('''
      CREATE TABLE history (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        summary TEXT,
        content TEXT,
        overallScore INTEGER,
        date TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        payloadJson TEXT,
        mediaPaths TEXT
      )
    ''');

    // Index for fast type filtering and date sorting
    await db.execute('CREATE INDEX idx_history_type ON history(type)');
    await db.execute(
      'CREATE INDEX idx_history_createdAt ON history(createdAt DESC)',
    );

    await _createMeetingTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createMeetingTables(db);
    }

    if (oldVersion < 3) {
      await _migrateMeetingSchemaV3(db);
    }
  }

  Future<void> _createMeetingTables(Database db) async {
    // 1. Meeting Users
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_users (
        id TEXT PRIMARY KEY,
        nickname TEXT,
        gender TEXT,
        birthDate TEXT,
        sajuJson TEXT,
        avatarPath TEXT,
        age INTEGER,
        introduction TEXT,
        regionCode TEXT,
        regionName TEXT,
        height INTEGER,
        occupation TEXT,
        profilePhotoUrl TEXT,
        idealTypeKeywords TEXT,
        activityTags TEXT,
        drinkSmoke TEXT
      )
    ''');

    // 2. Likes (Composite Key)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_likes (
        fromUserId TEXT,
        toUserId TEXT,
        createdAt TEXT,
        PRIMARY KEY (fromUserId, toUserId)
      )
    ''');

    // 3. Matches
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_matches (
        id TEXT PRIMARY KEY,
        userA TEXT,
        userB TEXT,
        matchedAt TEXT,
        compatibilityScore INTEGER
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_matches_userA ON meeting_matches(userA)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_matches_userB ON meeting_matches(userB)',
    );

    // 4. Messages
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_messages (
        id TEXT PRIMARY KEY,
        matchId TEXT,
        senderId TEXT,
        text TEXT,
        createdAt TEXT,
        readAt TEXT
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_messages_match_date ON meeting_messages(matchId, createdAt)',
    );

    // 5. Reports
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_reports (
        id TEXT PRIMARY KEY,
        matchId TEXT,
        reporterId TEXT,
        reason TEXT,
        description TEXT,
        createdAt TEXT,
        status TEXT DEFAULT 'pending'
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_passes (
        fromUserId TEXT,
        toUserId TEXT,
        createdAt TEXT,
        PRIMARY KEY (fromUserId, toUserId)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_blocks (
        id TEXT PRIMARY KEY,
        blockerUserId TEXT,
        blockedUserId TEXT,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_preferences (
        profileId TEXT PRIMARY KEY,
        targetGender TEXT,
        ageMin INTEGER DEFAULT 20,
        ageMax INTEGER DEFAULT 40,
        regionScope TEXT,
        distanceKm INTEGER
      )
    ''');
  }

  Future<void> _migrateMeetingSchemaV3(Database db) async {
    await _addColumnIfNotExists(db, 'meeting_reports', 'description', 'TEXT');
    await _addColumnIfNotExists(
      db,
      'meeting_reports',
      'status',
      "TEXT DEFAULT 'pending'",
    );
    await _addColumnIfNotExists(
      db,
      'meeting_matches',
      'compatibilityScore',
      'INTEGER',
    );

    await _addColumnIfNotExists(db, 'meeting_users', 'age', 'INTEGER');
    await _addColumnIfNotExists(db, 'meeting_users', 'introduction', 'TEXT');
    await _addColumnIfNotExists(db, 'meeting_users', 'regionCode', 'TEXT');
    await _addColumnIfNotExists(db, 'meeting_users', 'regionName', 'TEXT');
    await _addColumnIfNotExists(db, 'meeting_users', 'height', 'INTEGER');
    await _addColumnIfNotExists(db, 'meeting_users', 'occupation', 'TEXT');
    await _addColumnIfNotExists(db, 'meeting_users', 'profilePhotoUrl', 'TEXT');
    await _addColumnIfNotExists(
      db,
      'meeting_users',
      'idealTypeKeywords',
      'TEXT',
    );
    await _addColumnIfNotExists(db, 'meeting_users', 'activityTags', 'TEXT');
    await _addColumnIfNotExists(db, 'meeting_users', 'drinkSmoke', 'TEXT');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_passes (
        fromUserId TEXT,
        toUserId TEXT,
        createdAt TEXT,
        PRIMARY KEY (fromUserId, toUserId)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_blocks (
        id TEXT PRIMARY KEY,
        blockerUserId TEXT,
        blockedUserId TEXT,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_preferences (
        profileId TEXT PRIMARY KEY,
        targetGender TEXT,
        ageMin INTEGER DEFAULT 20,
        ageMax INTEGER DEFAULT 40,
        regionScope TEXT,
        distanceKm INTEGER
      )
    ''');
  }

  Future<void> _addColumnIfNotExists(
    Database db,
    String tableName,
    String columnName,
    String columnType,
  ) async {
    if (await _hasColumn(db, tableName, columnName)) {
      return;
    }

    await db.execute(
      'ALTER TABLE $tableName ADD COLUMN $columnName $columnType',
    );
  }

  Future<bool> _hasColumn(
    Database db,
    String tableName,
    String columnName,
  ) async {
    final columns = await db.rawQuery('PRAGMA table_info($tableName)');
    return columns.any((column) => column['name'] == columnName);
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
