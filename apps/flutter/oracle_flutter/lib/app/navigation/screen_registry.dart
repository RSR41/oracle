/// Maps React screen names to Flutter route paths.
class ScreenRegistry {
  static const Map<String, String> _map = {
    // Tabs
    'home': '/home',
    'fortune': '/fortune',
    'compatibility': '/compatibility',
    'history': '/history',
    'profile': '/profile',

    // Features
    'onboarding': '/onboarding',
    'face': '/face',
    'ideal-type': '/ideal-type',
    'connection': '/connection',
    'settings': '/settings',
    'tarot': '/tarot',
    'dream': '/dream',
    'chat': '/chat',

    // Placeholders
    'fortune-today': '/fortune-today',
    'calendar': '/calendar',
    'saju-analysis': '/saju-analysis',
    'consultation': '/consultation',
    'yearly-fortune': '/yearly-fortune',
    'compat-check': '/compat-check',
    'compat-result': '/compat-result',
    'profile-edit': '/profile-edit',
    'fortune-settings': '/fortune-settings',
    'connection-settings': '/connection-settings',
    'premium': '/premium',

    // Dynamic Details
    'fortune-detail': '/fortune-detail',
    'compat-detail': '/compat-detail',
    'tarot-detail': '/tarot-detail',
    'face-detail': '/face-detail',
    'dream-detail': '/dream-detail',
  };

  /// Returns Flutter path for a given React screen name.
  /// Returns null if not found.
  static String? pathForScreen(String screen) {
    return _map[screen];
  }

  /// Returns true if the screen is a main tab.
  static bool isTab(String screen) {
    return const {
      'home',
      'fortune',
      'compatibility',
      'history',
      'profile',
    }.contains(screen);
  }
}
