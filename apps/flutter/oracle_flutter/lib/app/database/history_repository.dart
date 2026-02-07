import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../database/database_helper.dart';
import '../models/fortune_result.dart';

/// Repository for History items using SQLite storage.
/// Provides CRUD operations for all fortune-related results.
class HistoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Save a new history item
  Future<void> save(FortuneResult result) async {
    final db = await _dbHelper.database;
    await db.insert('history', {
      'id': result.id,
      'type': result.type,
      'title': result.title,
      'summary': result.summary,
      'content': result.content,
      'overallScore': result.overallScore,
      'date': result.date,
      'createdAt': result.createdAt,
      'payloadJson': null,
      'mediaPaths': null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Save with extended payload (for complex features like Dream, Face, Tarot)
  Future<void> saveWithPayload({
    required FortuneResult result,
    Map<String, dynamic>? payload,
    List<String>? mediaPaths,
  }) async {
    final db = await _dbHelper.database;
    await db.insert('history', {
      'id': result.id,
      'type': result.type,
      'title': result.title,
      'summary': result.summary,
      'content': result.content,
      'overallScore': result.overallScore,
      'date': result.date,
      'createdAt': result.createdAt,
      'payloadJson': payload != null ? jsonEncode(payload) : null,
      'mediaPaths': mediaPaths != null ? jsonEncode(mediaPaths) : null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get all history items, optionally filtered by type
  Future<List<FortuneResult>> getAll({String? type}) async {
    final db = await _dbHelper.database;

    List<Map<String, dynamic>> maps;
    if (type != null) {
      maps = await db.query(
        'history',
        where: 'type = ?',
        whereArgs: [type],
        orderBy: 'createdAt DESC',
      );
    } else {
      maps = await db.query('history', orderBy: 'createdAt DESC');
    }

    return maps.map((map) => FortuneResult.fromJson(map)).toList();
  }

  /// Get a single item by ID
  Future<FortuneResult?> getById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query('history', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return FortuneResult.fromJson(maps.first);
  }

  /// Get payload JSON for an item
  Future<Map<String, dynamic>?> getPayload(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'history',
      columns: ['payloadJson'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty || maps.first['payloadJson'] == null) return null;
    return jsonDecode(maps.first['payloadJson'] as String);
  }

  /// Delete a single item
  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  /// Clear all history
  Future<void> clearAll() async {
    final db = await _dbHelper.database;
    await db.delete('history');
  }

  /// Get count of items by type
  Future<Map<String, int>> getCountByType() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT type, COUNT(*) as count FROM history GROUP BY type',
    );

    return {for (var row in result) row['type'] as String: row['count'] as int};
  }

  /// Get history items with pagination
  Future<List<FortuneResult>> getHistoryPaged({
    String? type,
    int limit = 30,
    int offset = 0,
  }) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> maps;

    if (type != null) {
      maps = await db.query(
        'history',
        where: 'type = ?',
        whereArgs: [type],
        orderBy: 'createdAt DESC',
        limit: limit,
        offset: offset,
      );
    } else {
      maps = await db.query(
        'history',
        orderBy: 'createdAt DESC',
        limit: limit,
        offset: offset,
      );
    }

    return maps.map((map) => FortuneResult.fromJson(map)).toList();
  }

  /// [Debug Only] Seed dummy history data for testing pagination
  Future<void> seedDummyHistory(int count) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final batch = db.batch();

    for (int i = 0; i < count; i++) {
      final createdAt = now.subtract(Duration(minutes: i)).toIso8601String();
      batch.insert('history', {
        'id': 'dummy_$i',
        'type': i % 2 == 0 ? 'today' : 'dream',
        'title': '더미 운세 결과 $i',
        'summary': '이것은 테스트를 위한 더미 데이터입니다. ($i)',
        'content': '상세 내용... ' * 10,
        'overallScore': 60 + (i % 40),
        'date': createdAt.split('T')[0],
        'createdAt': createdAt,
        'payloadJson': null,
        'mediaPaths': null,
      });
    }
    await batch.commit(noResult: true);
  }
}
