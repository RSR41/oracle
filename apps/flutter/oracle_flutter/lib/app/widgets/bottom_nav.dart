import 'package:flutter/material.dart';
import '../config/feature_flags.dart';
import '../navigation/nav_state.dart';

/// Bottom Navigation Bar mimicking React component.
class BottomNav extends StatelessWidget {
  final NavState navState;
  final ValueChanged<int> onTabSelected;
  final String Function(String) t; // Translation function

  const BottomNav({
    super.key,
    required this.navState,
    required this.onTabSelected,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs();
    int currentIndex = _getIndexForTab(navState.activeTab, tabs);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
        color: theme.cardTheme.color ?? colorScheme.surface,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex == -1 ? 0 : currentIndex,
        onTap: onTabSelected,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: theme.disabledColor,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: tabs,
      ),
    );
  }

  List<BottomNavigationBarItem> _tabs() {
    final tabs = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: t('nav.home'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.auto_awesome_outlined),
        activeIcon: const Icon(Icons.auto_awesome),
        label: t('nav.fortune'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.favorite_border),
        activeIcon: const Icon(Icons.favorite),
        label: t('nav.compatibility'),
      ),
    ];

    if (FeatureFlags.canUseMeeting) {
      tabs.add(
        BottomNavigationBarItem(
          icon: const Icon(Icons.people_outline),
          activeIcon: const Icon(Icons.people),
          label: t('nav.meeting'),
        ),
      );
    }

    tabs.addAll([
      BottomNavigationBarItem(
        icon: const Icon(Icons.history_outlined),
        activeIcon: const Icon(Icons.history),
        label: t('nav.history'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: t('nav.profile'),
      ),
    ]);

    return tabs;
  }

  int _getIndexForTab(String tab, List<BottomNavigationBarItem> tabs) {
    final tabKeys = <String>['home', 'fortune', 'compatibility'];
    if (FeatureFlags.canUseMeeting) {
      tabKeys.add('meeting');
    }
    tabKeys.addAll(['history', 'profile']);

    final index = tabKeys.indexOf(tab);
    if (index < 0 || index >= tabs.length) return 0;
    return index;
  }
}
