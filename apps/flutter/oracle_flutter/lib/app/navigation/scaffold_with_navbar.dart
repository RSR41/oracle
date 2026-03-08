import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/feature_flags.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _NavBarItem(
        route: '/home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: '홈',
      ),
      _NavBarItem(
        route: '/fortune',
        icon: Icons.auto_awesome_outlined,
        selectedIcon: Icons.auto_awesome,
        label: '사주',
      ),
      if (FeatureFlags.canUseMeeting)
        _NavBarItem(
          route: '/meeting',
          icon: Icons.people_outline,
          selectedIcon: Icons.people,
          label: '미팅',
        ),
      _NavBarItem(
        route: '/history',
        icon: Icons.history_outlined,
        selectedIcon: Icons.history,
        label: '기록',
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
