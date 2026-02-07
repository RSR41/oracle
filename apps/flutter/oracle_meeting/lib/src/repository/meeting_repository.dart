import 'package:sqflite/sqflite.dart';
import '../models/meeting_user.dart';
import '../models/meeting_match_models.dart';

abstract class MeetingRepository {
  Future<void> saveUser(MeetingUser user);
  Future<MeetingUser?> getUser(String id);
  Future<void> saveLike(MeetingLike like);
  Future<void> saveMatch(MeetingMatch match);
  Future<MeetingMatch?> findMatchBetween(String userA, String userB);
  Future<List<MeetingUser>> getRecommendations(String myUserId); // Mock
  Future<MeetingMessage> sendMessage(MeetingMessage message);
  Future<List<MeetingMessage>> getMessages(String matchId,
      {int limit = 50, int offset = 0});
  Future<List<MeetingMatch>> getMatches(String userId);
  Future<int> getUnreadCount(String matchId, String userId);
  Future<void> markAsRead(String matchId, String userId);
  Future<void> reportUser(MeetingReport report);
  Future<void> clearAllData();
}

class MeetingRepositoryImpl implements MeetingRepository {
  final Database _db;

  MeetingRepositoryImpl(this._db);

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
    // Check if mutual like exists
    await _db.insert('meeting_likes', like.toMap(),
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
            ))
        .toList();
  }

  @override
  Future<List<MeetingUser>> getRecommendations(String myUserId) async {
    // MVP: Just return all other users not liked yet
    // In real app, complex query
    final result = await _db.rawQuery('''
      SELECT * FROM meeting_users 
      WHERE id != ? 
      AND id NOT IN (SELECT toUserId FROM meeting_likes WHERE fromUserId = ?)
      LIMIT 10
    ''', [myUserId, myUserId]);

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
      orderBy: 'createdAt DESC', // 최신순으로 가져오되 UI에서 reverse 처리 권장
      limit: limit,
      offset: offset,
    );
    // UI의 편의를 위해 가져온 리스트를 시간순(ASC)으로 다시 뒤집어서 전달 (또는 DESC 그대로 사용)
    // 여기서는 DB 쿼리 효율을 위해 DESC로 가져오고 반환 시 뒤집음
    final list = result.map((e) => MeetingMessage.fromMap(e)).toList();
    return list.reversed.toList();
  }

  @override
  Future<int> getUnreadCount(String matchId, String userId) async {
    // Get count of messages in this match where sender is NOT me and readAt is null
    return Sqflite.firstIntValue(await _db.rawQuery('''
      SELECT COUNT(*) FROM meeting_messages
      WHERE matchId = ? AND senderId != ? AND readAt IS NULL
    ''', [matchId, userId])) ?? 0;
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
  Future<void> clearAllData() async {
    await _db.delete('meeting_users');
    await _db.delete('meeting_likes');
    await _db.delete('meeting_matches');
    await _db.delete('meeting_messages');
    await _db.delete('meeting_reports');
  }
}
