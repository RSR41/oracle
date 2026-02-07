import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:oracle_meeting/src/repository/meeting_repository.dart';
import 'package:oracle_meeting/src/services/meeting_service.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Meeting Chat Logic Test', () {
    late MeetingRepository repo;
    late MeetingService service;

    setUp(() async {
      final db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE meeting_messages (
            id TEXT PRIMARY KEY,
            matchId TEXT,
            senderId TEXT,
            text TEXT,
            createdAt TEXT,
            readAt TEXT
          )
        ''');
        },
      );
      repo = MeetingRepositoryImpl(db);
      service = MeetingService(repo);
    });

    test('sendMessage should save and return message', () async {
      final matchId = 'test_match';
      final msg = await service.sendMessage(
        matchId: matchId,
        myUserId: 'me',
        content: 'Hello',
        otherUserId: 'other',
      );

      expect(msg.text, 'Hello');
      expect(msg.matchId, matchId);

      final history = await service.getMessages(matchId);
      expect(history.length, 1);
      expect(history.first.text, 'Hello');
    });

    test('seedTestMessages should populate data', () async {
      final matchId = 'seed_match';
      await service.seedTestMessages(matchId, count: 5);

      final history = await service.getMessages(matchId);
      expect(history.length, 5);
      // Repository returns reversed(DESC) list -> ASC
      // seed loop inserts 0..count
      // i=0 is oldest
      expect(history.first.text, '테스트 메시지 0');
    });
  });
}
