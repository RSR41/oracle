import 'package:sqflite/sqflite.dart';
import '../models/meeting_user.dart';
import '../models/meeting_match_models.dart';
import '../models/meeting_preference.dart';

abstract class MeetingRepository {
  Future<void> saveUser(MeetingUser user);
  Future<MeetingUser?> getUser(String id);
  Future<void> saveLike(MeetingLike like);
  Future<void> savePass(MeetingPass pass);
  Future<void> saveMatch(MeetingMatch match);
  Future<MeetingMatch?> findMatchBetween(String userA, String userB);
  Future<List<MeetingUser>> getRecommendations(String myUserId);
  Future<MeetingMessage> sendMessage(MeetingMessage message);
  Future<List<MeetingMessage>> getMessages(String matchId,
      {int limit = 50, int offset = 0});
  Future<List<MeetingMatch>> getMatches(String userId);
  Future<int> getUnreadCount(String matchId, String userId);
  Future<void> markAsRead(String matchId, String userId);
  Future<void> reportUser(MeetingReport report);
  Future<void> blockUser(MeetingBlock block);
  Future<List<MeetingBlock>> getBlocks(String userId);
  Future<bool> isBlocked(String userId, String targetId);
  Future<void> savePreference(MeetingPreference pref);
  Future<MeetingPreference?> getPreference(String profileId);
  Future<MeetingMessage?> getLastMessage(String matchId);
  Future<void> clearAllData();
}

class MeetingRepositoryImpl implements MeetingRepository {
  final Database _db;

  MeetingRepositoryImpl(this._db);

  /// Ensures all meeting tables exist in the database
  static Future<void> ensureTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_users (
        id TEXT PRIMARY KEY,
        nickname TEXT NOT NULL,
        gender TEXT NOT NULL,
        birthDate TEXT NOT NULL,
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
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_likes (
        fromUserId TEXT NOT NULL,
        toUserId TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        PRIMARY KEY (fromUserId, toUserId)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_passes (
        fromUserId TEXT NOT NULL,
        toUserId TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        PRIMARY KEY (fromUserId, toUserId)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_matches (
        id TEXT PRIMARY KEY,
        userA TEXT NOT NULL,
        userB TEXT NOT NULL,
        matchedAt TEXT NOT NULL,
        compatibilityScore INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_messages (
        id TEXT PRIMARY KEY,
        matchId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        text TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        readAt TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_reports (
        id TEXT PRIMARY KEY,
        matchId TEXT NOT NULL,
        reporterId TEXT NOT NULL,
        reason TEXT NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL,
        status TEXT DEFAULT 'pending'
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meeting_blocks (
        id TEXT PRIMARY KEY,
        blockerUserId TEXT NOT NULL,
        blockedUserId TEXT NOT NULL,
        createdAt TEXT NOT NULL
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

  @override
  Future<void> saveUser(MeetingUser user) async {
    await _db.insert('meeting_users', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<MeetingUser?> getUser(String id) async {
    final result =
        await _db.query('meeting_users', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return MeetingUser.fromJson(result.first);
  }

  @override
  Future<void> saveLike(MeetingLike like) async {
    await _db.insert('meeting_likes', like.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<void> savePass(MeetingPass pass) async {
    await _db.insert('meeting_passes', pass.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<void> saveMatch(MeetingMatch match) async {
    await _db.insert('meeting_matches', match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<MeetingMatch?> findMatchBetween(String userA, String userB) async {
    final result = await _db.query('meeting_matches',
        where: '(userA = ? AND userB = ?) OR (userA = ? AND userB = ?)',
        whereArgs: [userA, userB, userB, userA]);
    if (result.isEmpty) return null;
    return MeetingMatch(
      id: result.first['id'] as String,
      userA: result.first['userA'] as String,
      userB: result.first['userB'] as String,
      matchedAt: result.first['matchedAt'] as String,
      compatibilityScore: result.first['compatibilityScore'] as int?,
    );
  }

  @override
  Future<List<MeetingMatch>> getMatches(String userId) async {
    final result = await _db.query('meeting_matches',
        where: 'userA = ? OR userB = ?',
        whereArgs: [userId, userId],
        orderBy: 'matchedAt DESC');

    return result
        .map((e) => MeetingMatch(
              id: e['id'] as String,
              userA: e['userA'] as String,
              userB: e['userB'] as String,
              matchedAt: e['matchedAt'] as String,
              compatibilityScore: e['compatibilityScore'] as int?,
            ))
        .toList();
  }

  @override
  Future<List<MeetingUser>> getRecommendations(String myUserId) async {
    // Exclude: already liked, passed, blocked, matched
    final result = await _db.rawQuery('''
      SELECT * FROM meeting_users 
      WHERE id != ? 
      AND id NOT IN (SELECT toUserId FROM meeting_likes WHERE fromUserId = ?)
      AND id NOT IN (SELECT toUserId FROM meeting_passes WHERE fromUserId = ?)
      AND id NOT IN (SELECT blockedUserId FROM meeting_blocks WHERE blockerUserId = ?)
      AND id NOT IN (SELECT blockerUserId FROM meeting_blocks WHERE blockedUserId = ?)
      AND id NOT IN (
        SELECT CASE WHEN userA = ? THEN userB ELSE userA END 
        FROM meeting_matches WHERE userA = ? OR userB = ?
      )
      LIMIT 20
    ''', [myUserId, myUserId, myUserId, myUserId, myUserId, myUserId, myUserId, myUserId]);

    return result.map((e) => MeetingUser.fromJson(e)).toList();
  }

  @override
  Future<MeetingMessage> sendMessage(MeetingMessage message) async {
    await _db.insert('meeting_messages', message.toMap());
    return message;
  }

  @override
  Future<List<MeetingMessage>> getMessages(String matchId,
      {int limit = 50, int offset = 0}) async {
    final result = await _db.query(
      'meeting_messages',
      where: 'matchId = ?',
      whereArgs: [matchId],
      orderBy: 'createdAt DESC',
      limit: limit,
      offset: offset,
    );
    final list = result.map((e) => MeetingMessage.fromMap(e)).toList();
    return list.reversed.toList();
  }

  @override
  Future<MeetingMessage?> getLastMessage(String matchId) async {
    final result = await _db.query(
      'meeting_messages',
      where: 'matchId = ?',
      whereArgs: [matchId],
      orderBy: 'createdAt DESC',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return MeetingMessage.fromMap(result.first);
  }

  @override
  Future<int> getUnreadCount(String matchId, String userId) async {
    return Sqflite.firstIntValue(await _db.rawQuery('''
      SELECT COUNT(*) FROM meeting_messages
      WHERE matchId = ? AND senderId != ? AND readAt IS NULL
    ''', [matchId, userId])) ??
        0;
  }

  @override
  Future<void> markAsRead(String matchId, String userId) async {
    final now = DateTime.now().toIso8601String();
    await _db.update('meeting_messages', {'readAt': now},
        where: 'matchId = ? AND senderId != ? AND readAt IS NULL',
        whereArgs: [matchId, userId]);
  }

  @override
  Future<void> reportUser(MeetingReport report) async {
    await _db.insert('meeting_reports', report.toMap());
  }

  @override
  Future<void> blockUser(MeetingBlock block) async {
    await _db.insert('meeting_blocks', block.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<List<MeetingBlock>> getBlocks(String userId) async {
    final result = await _db.query('meeting_blocks',
        where: 'blockerUserId = ?', whereArgs: [userId]);
    return result.map((e) => MeetingBlock.fromMap(e)).toList();
  }

  @override
  Future<bool> isBlocked(String userId, String targetId) async {
    final result = await _db.query('meeting_blocks',
        where:
            '(blockerUserId = ? AND blockedUserId = ?) OR (blockerUserId = ? AND blockedUserId = ?)',
        whereArgs: [userId, targetId, targetId, userId]);
    return result.isNotEmpty;
  }

  @override
  Future<void> savePreference(MeetingPreference pref) async {
    await _db.insert('meeting_preferences', pref.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<MeetingPreference?> getPreference(String profileId) async {
    final result = await _db.query('meeting_preferences',
        where: 'profileId = ?', whereArgs: [profileId]);
    if (result.isEmpty) return null;
    return MeetingPreference.fromMap(result.first);
  }

  @override
  Future<void> clearAllData() async {
    await _db.delete('meeting_users');
    await _db.delete('meeting_likes');
    await _db.delete('meeting_passes');
    await _db.delete('meeting_matches');
    await _db.delete('meeting_messages');
    await _db.delete('meeting_reports');
    await _db.delete('meeting_blocks');
  }
}
