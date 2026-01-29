import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x_1/features/home/home_screen.dart';
import 'package:x_1/features/auth/login_screen.dart';
import 'package:x_1/features/auth/register_screen.dart';
import 'package:x_1/features/fortune/input_screen.dart';
import 'package:x_1/features/fortune/result_screen.dart';
import 'package:x_1/features/fortune/fortune_screen.dart';
import 'package:x_1/features/compatibility/compatibility_screen.dart';
import 'package:x_1/features/face/face_reading_screen.dart';
import 'package:x_1/features/tarot/tarot_screen.dart';
import 'package:x_1/features/dream/dream_screen.dart';
import 'package:x_1/features/history/history_screen.dart';
import 'package:x_1/features/settings/settings_screen.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  home('/'),
  login('/login'),
  register('/register'),
  input('/input'),
  result('/result'),
  fortune('/fortune'),
  compatibility('/compatibility'),
  face('/face'),
  tarot('/tarot'),
  dream('/dream'),
  history('/history'),
  settings('/settings');

  final String path;
  const AppRoute(this.path);
}

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoute.home.path,
  routes: [
    GoRoute(
      path: AppRoute.home.path,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoute.login.path,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoute.register.path,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoute.input.path,
      builder: (context, state) => const InputScreen(),
    ),
    GoRoute(
      path: AppRoute.result.path,
      builder: (context, state) => const ResultScreen(),
    ),
    GoRoute(
      path: AppRoute.fortune.path,
      builder: (context, state) => const FortuneScreen(),
    ),
    GoRoute(
      path: AppRoute.compatibility.path,
      builder: (context, state) => const CompatibilityScreen(),
    ),
    GoRoute(
      path: AppRoute.face.path,
      builder: (context, state) => const FaceReadingScreen(),
    ),
    GoRoute(
      path: AppRoute.tarot.path,
      builder: (context, state) => const TarotScreen(),
    ),
    GoRoute(
      path: AppRoute.dream.path,
      builder: (context, state) => const DreamScreen(),
    ),
    GoRoute(
      path: AppRoute.history.path,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: AppRoute.settings.path,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
