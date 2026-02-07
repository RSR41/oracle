import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app/navigation/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/state/app_state.dart';
import 'app/database/database_helper.dart';
import 'package:oracle_meeting/meeting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Desktop Profile (Windows/Linux) Initialization
    if (!const bool.fromEnvironment('dart.library.js_util')) {
      if (Platform.isWindows || Platform.isLinux) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
    }

    // 2. Initialize DB for shared use
    // Note: sqflite doesn't support Web out of the box.
    // This will error on Web, but we try-catch to allow partial run for checking UI.
    Database? db;
    try {
      db = await DatabaseHelper.instance.database;
    } catch (e) {
      debugPrint('Database initialization failed: $e');
      // If Web or DB fails, we handle it gracefully in the providers below
    }

    final appState = AppState();
    await appState.init();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: appState),
          if (db != null)
            Provider<MeetingRepository>(
              create: (_) => MeetingRepositoryImpl(db!),
            )
          else
            // Mock or Null Repository for platforms without SQLite support (like Web)
            Provider<MeetingRepository>(create: (_) => MeetingRepositoryStub()),
        ],
        child: const OracleApp(),
      ),
    );
  } catch (e) {
    debugPrint('Fatal initialization error: $e');
    // Still try to run the app to show something if possible
    runApp(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Initialization Error'))),
      ),
    );
  }
}

class OracleApp extends StatelessWidget {
  const OracleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp.router(
      title: 'Oracle Fortune Telling',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: appState.themeMode,
      // Router Configuration
      routerConfig: AppRouter.router(appState),
    );
  }
}

/// A stub implementation of MeetingRepository for platforms that don't support SQLite (like Web).
/// This prevents the app from crashing during initialization.
class MeetingRepositoryStub implements MeetingRepository {
  @override
  Future<void> deleteMessage(String id) async {}

  @override
  Future<List<MeetingMatch>> getMatches() async => [];

  @override
  Future<List<MeetingMessage>> getMessages(String matchId) async => [];

  @override
  Future<MeetingUser?> getUser(String id) async => null;

  @override
  Future<void> markAsRead(String matchId) async {}

  @override
  Future<void> reportMatch(String matchId, String reason) async {}

  @override
  Future<void> saveLike(String fromId, String toId) async {}

  @override
  Future<void> saveMatch(MeetingMatch match) async {}

  @override
  Future<void> saveMessage(MeetingMessage message) async {}

  @override
  Future<void> saveUser(MeetingUser user) async {}

  @override
  Future<void> saveReport(
    String matchId,
    String reporterId,
    String reason,
  ) async {}
}
