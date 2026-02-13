import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../config/feature_flags.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final hasSaju = appState.hasSajuProfile;

    // Define all possible tabs
    final tabs = [
      _NavBarItem(
        route: '/home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Home',
      ),
      _NavBarItem(
        route: '/fortune',
        icon: Icons.auto_awesome_outlined,
        selectedIcon: Icons.auto_awesome,
        label: 'Fortune',
      ),
      if (hasSaju && FeatureFlags.canUseMeeting)
        _NavBarItem(
          route: '/meeting',
          icon: Icons.people_outline,
          selectedIcon: Icons.people,
          label: 'Meeting',
        ),
      if (FeatureFlags.phase2Features)
        _NavBarItem(
          route: '/compatibility',
          icon: Icons.favorite_border,
          selectedIcon: Icons.favorite,
          label: 'Compat',
        ),
      _NavBarItem(
        route: '/history',
        icon: Icons.history_outlined,
        selectedIcon: Icons.history,
        label: 'History',
      ),
      _NavBarItem(
        route: '/profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context, tabs),
        onDestinationSelected: (int index) =>
            _onItemTapped(index, context, tabs),
        destinations: tabs
            .map(
              (t) => NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.selectedIcon),
                label: t.label,
              ),
            )
            .toList(),
      ),
    );
  }

  static int _calculateSelectedIndex(
    BuildContext context,
    List<_NavBarItem> tabs,
  ) {
    final String location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < tabs.length; i++) {
      if (location.startsWith(tabs[i].route)) return i;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, List<_NavBarItem> tabs) {
    context.go(tabs[index].route);
  }
}

class _NavBarItem {
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  _NavBarItem({
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
