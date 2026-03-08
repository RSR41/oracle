import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/navigation/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/state/app_state.dart';
import 'app/database/database_helper.dart';
import 'app/config/supabase_config.dart';
import 'app/config/feature_flags.dart';
import 'app/services/cloud/cloud_history_sync_service.dart';
import 'app/services/meeting_notification_service.dart';
import 'package:oracle_meeting/meeting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Desktop Profile (Windows/Linux) Initialization
    // 1. Desktop Profile (Windows/Linux/MacOS) Initialization
    // Web checks must come first to avoid Platform access errors on Web
    if (kIsWeb) {
      // Initialize FFI for Web
      databaseFactory = databaseFactoryFfiWeb;
      debugPrint('SQFlite FFI Initialized for Web');
    } else {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Initialize FFI for Desktop
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        debugPrint('SQFlite FFI Initialized for Desktop');
      }
    }

    Database? db;
    if (!kIsWeb) {
      try {
        db = await DatabaseHelper.instance.database;
      } catch (e) {
        debugPrint('Database initialization failed: $e');
        // If DB fails, we handle it gracefully in the providers below
      }
    }

    final appState = AppState();
    await appState.init();

    await MeetingNotificationService.instance.initialize();
    await MeetingNotificationService.instance.requestPermission();
    await MeetingNotificationService.instance.bindMeetingHooks();

    if (SupabaseConfig.isConfigured) {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
      debugPrint('Supabase initialized.');
    }
    if (FeatureFlags.cloudSync) {
      await CloudHistorySyncService.syncOnStartup();
    }

    // Ensure meeting tables exist
    if (db != null) {
      await MeetingRepositoryImpl.ensureTables(db);
    }

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: appState),
          if (db != null)
            Provider<MeetingRepository>(
              create: (_) => MeetingRepositoryImpl(db!),
            )
          else
            Provider<MeetingRepository>(create: (_) => MeetingRepositoryStub()),
        ],
        child: const OracleApp(),
      ),
    );
  } catch (e) {
    debugPrint('Fatal initialization error: $e');
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

      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: appState.themeMode,

      routerConfig: AppRouter.router(appState),
    );
  }
}

/// Stub implementation of MeetingRepository for platforms without SQLite (Web).
class MeetingRepositoryStub implements MeetingRepository {
  @override
  Future<void> saveUser(MeetingUser user) async {}

  @override
  Future<MeetingUser?> getUser(String id) async => null;

  @override
  Future<void> saveLike(MeetingLike like) async {}

  @override
  Future<void> savePass(MeetingPass pass) async {}

  @override
  Future<MeetingLikeResult?> submitLikeRemote({
    required String fromUserId,
    required String toUserId,
    required String createdAt,
  }) async => null;

  @override
  Future<void> saveMatch(MeetingMatch match) async {}

  @override
  Future<MeetingMatch?> findMatchBetween(String userA, String userB) async =>
      null;

  @override
  Future<List<MeetingUser>> getRecommendations(String myUserId) async => [];

  @override
  Future<MeetingMessage> sendMessage(MeetingMessage message) async => message;

  @override
  Future<List<MeetingMessage>> getMessages(
    String matchId, {
    int limit = 50,
    int offset = 0,
  }) async => [];

  @override
  Future<MeetingMessage?> getLastMessage(String matchId) async => null;

  @override
  Future<List<MeetingMatch>> getMatches(String userId) async => [];

  @override
  Future<int> getUnreadCount(String matchId, String userId) async => 0;

  @override
  Future<void> markAsRead(String matchId, String userId) async {}

  @override
  Future<void> reportUser(MeetingReport report) async {}

  @override
  Future<void> blockUser(MeetingBlock block) async {}

  @override
  Future<List<MeetingBlock>> getBlocks(String userId) async => [];

  @override
  Future<bool> isBlocked(String userId, String targetId) async => false;

  @override
  Future<void> savePreference(MeetingPreference pref) async {}

  @override
  Future<MeetingPreference?> getPreference(String profileId) async => null;

  @override
  Future<void> clearAllData() async {}
}
