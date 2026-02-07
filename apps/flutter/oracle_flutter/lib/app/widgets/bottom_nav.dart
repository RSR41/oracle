import 'package:flutter/material.dart';
import '../navigation/nav_state.dart';

/// Bottom Navigation Bar mimicking React component.
/// Displays 5 tabs: Home, Fortune, Compatibility, History, Profile.
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
    // Determine Index from activeTab
    int currentIndex = _getIndexForTab(navState.activeTab);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)), // border-t
        color: theme.cardTheme.color ?? colorScheme.surface, // bg-card
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex == -1 ? 0 : currentIndex,
        onTap: onTabSelected,
        backgroundColor: Colors.transparent, // handled by container
        elevation: 0,
        type: BottomNavigationBarType.fixed,

        // Active/Inactive styles
        selectedItemColor: colorScheme.primary, // text-primary
        unselectedItemColor: theme.disabledColor, // text-muted-foreground

        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),

        items: [
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
        ],
      ),
    );
  }

  int _getIndexForTab(String tab) {
    switch (tab) {
      case 'home':
        return 0;
      case 'fortune':
        return 1;
      case 'compatibility':
        return 2;
      case 'history':
        return 3;
      case 'profile':
        return 4;
      default:
        return 0;
    }
  }
}
