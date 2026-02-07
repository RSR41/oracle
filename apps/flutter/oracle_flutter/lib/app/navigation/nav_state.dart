import 'package:flutter/foundation.dart';

/// Represents a screen in the navigation stack.
class ScreenEntry {
  final String name;
  final Object? data;

  ScreenEntry({required this.name, this.data});
}

/// Manages navigation state mimicking React App.tsx logic.
/// - showOnboarding
/// - activeTab
/// - screenStack
class NavState extends ChangeNotifier {
  bool _showOnboarding = true;
  String _activeTab = 'home';
  List<ScreenEntry> _screenStack = [ScreenEntry(name: 'home')];

  bool get showOnboarding => _showOnboarding;
  String get activeTab => _activeTab;
  List<ScreenEntry> get screenStack => List.unmodifiable(_screenStack);

  /// React Tabs
  static const Set<String> _tabs = {
    'home',
    'fortune',
    'compatibility',
    'history',
    'profile',
  };

  /// App.tsx: handleNavigate(screen, data)
  void navigate(String screen, {Object? data}) {
    if (_tabs.contains(screen)) {
      // If navigating to a tab, switch tab
      tabChange(screen);
    } else {
      // Push to stack
      _screenStack.add(ScreenEntry(name: screen, data: data));
      notifyListeners();
    }
  }

  /// App.tsx: handleBack()
  void back() {
    if (_screenStack.length > 1) {
      _screenStack.removeLast();
      // If top is now a tab, update activeTab (React logic likely does this implicitly or explicit sync)
      // In React App.tsx: usually activeTab is independent state, but UI reflects stack top?
      // Actually React source keeps activeTab for BottomNav highlight.
      // If we popped back to a route that is a tab, we should probably update activeTab if needed.
      // But adhering to strict port: React App.tsx usually doesn't sync activeTab on back unless handled.
      // However, for Flutter ShellRoute integration, we might need to be careful.
      // Let's follow React App.tsx literal:
      // It implies stack is for "screens on top of tabs" or "screens".
      // We will stick to simple pop.
      notifyListeners();
    }
  }

  /// App.tsx: setActiveTab / handleTabChange
  void tabChange(String tab) {
    if (_tabs.contains(tab)) {
      _activeTab = tab;
      // React often resets stack on tab change, or maintains separate stacks?
      // App.tsx prompt says: "screenStack: push/pop".
      // Usually "tabChange" implies resetting the main view to that tab.
      // We will assume "Root of stack becomes tab" or "Stack reset to [tab]" logic.
      // Prompt Step 3-1: "screenStack = [ScreenEntry(name: tab)]"
      _screenStack = [ScreenEntry(name: tab)];
      notifyListeners();
    }
  }

  /// App.tsx: handleOnboardingComplete
  void completeOnboarding() {
    _showOnboarding = false;
    notifyListeners();
  }
}
