import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/coming_soon_screen.dart';
import 'scaffold_with_navbar.dart';
import '../config/feature_flags.dart';
// Tab Screens
import '../screens/tabs/home_screen.dart';
import '../screens/tabs/fortune_screen.dart';
import '../screens/tabs/compatibility_screen.dart';
import '../screens/tabs/history_screen.dart';
import '../screens/tabs/profile_screen.dart';
import '../screens/tabs/meeting_profile_gate.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../state/app_state.dart';
import 'package:provider/provider.dart';
// Stack Screens
import '../screens/tabs/settings_screen.dart';
import '../screens/fortune/fortune_today_screen.dart';
import '../screens/fortune/fortune_detail_screen.dart';
import '../screens/meeting/meeting_history_detail_screen.dart';
import '../screens/dream/dream_input_screen.dart';
import '../screens/dream/dream_result_screen.dart';
import '../screens/tarot/tarot_screen.dart';
import '../screens/tarot/tarot_result_screen.dart';
import '../screens/face/face_reading_screen.dart';
import '../screens/face/face_result_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../models/fortune_result.dart';
import '../database/history_repository.dart';
import 'package:oracle_meeting/meeting.dart';
import '../models/tarot_card.dart';
import '../services/dream/dream_interpreter.dart';
import '../services/face/face_analyzer.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  static GoRouter? _router;

  static GoRouter router(AppState appState) {
    // 첫 실행 여부에 따라 초기 위치 결정
    final initialLocation = appState.isFirstRun ? '/welcome' : '/home';

    _router ??= GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialLocation,
      refreshListenable: appState,
      redirect: (context, state) {
        // 첫 실행이면 welcome으로 리다이렉트 (단, welcome/onboarding은 제외)
        final isOnWelcome = state.matchedLocation == '/welcome';
        final isOnOnboarding = state.matchedLocation == '/onboarding';

        if (appState.isFirstRun && !isOnWelcome && !isOnOnboarding) {
          return '/welcome';
        }
        return null;
      },
      routes: [
        // Welcome Screen (첫 실행)
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),

        // Onboarding Screen (프로필 입력)
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),

        // Bottom Navigation Shell
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: HomeScreen()),
            ),
            GoRoute(
              path: '/fortune',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: FortuneScreen()),
            ),
            GoRoute(
              path: '/meeting',
              redirect: (context, state) =>
                  FeatureFlags.showBetaFeatures ? null : '/home',
              pageBuilder: (context, state) {
                final appState = Provider.of<AppState>(context);
                if (!appState.hasSajuProfile) {
                  return const NoTransitionPage(child: MeetingProfileGate());
                }
                return NoTransitionPage(
                  child: MeetingHomeScreen(
                    myUserId: appState.profile?.nickname ?? 'me',
                    myNickname: appState.profile?.nickname ?? '나',
                    onHistoryRecord: (payload) async {
                      final historyRepo = HistoryRepository();
                      final result = FortuneResult(
                        id: payload['id'],
                        type: payload['type'],
                        title: payload['title'],
                        date: DateTime.now().toIso8601String().split('T')[0],
                        summary: payload['body'],
                        content: payload['body'],
                        overallScore: 0,
                        createdAt: payload['createdAt'],
                      );

                      await historyRepo.saveWithPayload(
                        result: result,
                        payload: payload['meta'],
                      );
                      debugPrint(
                        'History recorded from App side: ${payload['type']}',
                      );
                    },
                    onOpenMeetingHistory: () =>
                        context.push('/meeting/history'),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: 'history',
                  builder: (context, state) => const HistoryScreen(
                    initialFilter: 'MEETING',
                    lockFilter: true,
                  ),
                  routes: [
                    GoRoute(
                      path: 'detail/:id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return MeetingHistoryDetailScreen(
                          id: id,
                          extra: state.extra,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: '/compatibility',
              redirect: (context, state) =>
                  FeatureFlags.showBetaFeatures ? null : '/home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: CompatibilityScreen()),
            ),
            GoRoute(
              path: '/history',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: HistoryScreen()),
            ),
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileScreen()),
            ),
          ],
        ),

        // Stack Screens (No Bottom Nav)
        GoRoute(
          path: '/face',
          builder: (context, state) => const FaceReadingScreen(),
        ),
        GoRoute(
          path: '/face-result',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return FaceResultScreen(
              imagePath: extra['imagePath'] as String,
              result: extra['result'] as FaceReadingResult,
            );
          },
        ),
        GoRoute(
          path: '/ideal-type',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Ideal Type'),
        ),
        GoRoute(
          path: '/connection',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Connection'),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/tarot',
          builder: (context, state) => const TarotScreen(),
        ),
        GoRoute(
          path: '/tarot-result',
          builder: (context, state) {
            final cards = state.extra as List<TarotCard>;
            return TarotResultScreen(cards: cards);
          },
        ),
        GoRoute(
          path: '/dream',
          builder: (context, state) => const DreamInputScreen(),
        ),
        GoRoute(
          path: '/dream-result',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return DreamResultScreen(
              dreamContent: extra['dreamContent'] as String,
              result: extra['result'] as DreamResult,
            );
          },
        ),
        GoRoute(
          path: '/meeting/chat',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return MeetingChatScreen(
              matchId: extra['matchId'] as String,
              myUserId: extra['myUserId'] as String,
              otherUserId: extra['otherUserId'] as String,
              otherUserName: extra['otherUserName'] as String,
            );
          },
        ),

        // Feature & Placeholders
        GoRoute(
          path: '/fortune-today',
          builder: (context, state) => FortuneTodayScreen(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: '/saju-analysis',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Saju Analysis'),
        ),
        GoRoute(
          path: '/consultation',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Consultation'),
        ),
        GoRoute(
          path: '/yearly-fortune',
          builder: (context, state) =>
              const ComingSoonScreen(title: '2026 Yearly Fortune'),
        ),
        GoRoute(
          path: '/compat-check',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Compatibility Check'),
        ),
        GoRoute(
          path: '/compat-result',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Compatibility Result'),
        ),
        GoRoute(
          path: '/profile-edit',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Profile Edit'),
        ),
        GoRoute(
          path: '/fortune-settings',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Fortune Settings'),
        ),
        GoRoute(
          path: '/connection-settings',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Connection Settings'),
        ),
        GoRoute(
          path: '/premium',
          builder: (context, state) => const ComingSoonScreen(title: 'Premium'),
        ),

        // Dynamic Details
        GoRoute(
          path: '/fortune-detail',
          builder: (context, state) {
            final result = state.extra as FortuneResult;
            return FortuneDetailScreen(result: result);
          },
        ),
        GoRoute(
          path: '/compat-detail',
          builder: (context, state) =>
              ComingSoonScreen(title: 'Compat Detail', data: state.extra),
        ),
        GoRoute(
          path: '/tarot-detail',
          builder: (context, state) =>
              ComingSoonScreen(title: 'Tarot Detail', data: state.extra),
        ),
        GoRoute(
          path: '/dream-detail',
          builder: (context, state) =>
              ComingSoonScreen(title: 'Dream Detail', data: state.extra),
        ),
        GoRoute(
          path: '/face-detail',
          builder: (context, state) =>
              ComingSoonScreen(title: 'Face Detail', data: state.extra),
        ),
      ],
    );
    return _router!;
  }

  /// 첫 실행 후 router 재설정 (for hot reload)
  static void reset() {
    _router = null;
  }
}
