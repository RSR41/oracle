import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/navigation/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/state/app_state.dart';

import 'app/database/database_helper.dart';
import 'package:oracle_meeting/meeting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DB for shared use
  final db = await DatabaseHelper.instance.database;

  final appState = AppState();
  await appState.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        Provider<MeetingRepository>(create: (_) => MeetingRepositoryImpl(db)),
      ],
      child: const OracleApp(),
    ),
  );
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
