import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x_2/navigation/main_scaffold.dart';
import 'package:x_2/screens/home/home_screen.dart';
import 'package:x_2/screens/common/coming_soon_page.dart';
import 'package:x_2/screens/profile/profile_screen.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _fortuneNavigatorKey = GlobalKey<NavigatorState>();
final _compatibilityNavigatorKey = GlobalKey<NavigatorState>();
final _historyNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Home Tab
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ],
        ),
        // Fortune Tab
        StatefulShellBranch(
          navigatorKey: _fortuneNavigatorKey,
          routes: [
            GoRoute(
              path: '/fortune',
              builder: (context, state) => const ComingSoonPage(
                title: '?¥ÏÑ∏',
                description: '?§Îäò???¥ÏÑ∏ Í∏∞Îä• Ï§ÄÎπ?Ï§?,
              ),
            ),
          ],
        ),
        // Compatibility Tab
        StatefulShellBranch(
          navigatorKey: _compatibilityNavigatorKey,
          routes: [
            GoRoute(
              path: '/compatibility',
              builder: (context, state) => const ComingSoonPage(
                title: 'Í∂ÅÌï©',
                description: 'Í∂ÅÌï© Î∂ÑÏÑù Í∏∞Îä• Ï§ÄÎπ?Ï§?,
              ),
            ),
          ],
        ),
        // History Tab
        StatefulShellBranch(
          navigatorKey: _historyNavigatorKey,
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const ComingSoonPage(
                title: 'Í∏∞Î°ù',
                description: '?àÏä§?†Î¶¨ Í∏∞Îä• Ï§ÄÎπ?Ï§?,
              ),
            ),
          ],
        ),
        // Profile Tab
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Other Roots (Push from Tabs)
    GoRoute(
      path: '/calendar',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ComingSoonPage(title: 'ÎßåÏÑ∏??),
    ),
    GoRoute(
      path: '/tarot',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ComingSoonPage(title: '?ÄÎ°?),
    ),
    GoRoute(
      path: '/dream',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ComingSoonPage(title: 'ÍøàÌï¥Î™?),
    ),
    GoRoute(
      path: '/face',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ComingSoonPage(title: 'Í¥Ä??),
    ),
    GoRoute(
      path: '/yearly-fortune',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ComingSoonPage(title: '?†ÎÖÑ?¥ÏÑ∏'),
    ),
    GoRoute(
      path: '/fortune-today',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ComingSoonPage(title: '?§Îäò???¥ÏÑ∏ ?ÅÏÑ∏'),
    ),
  ],
);
