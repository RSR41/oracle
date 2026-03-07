import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/translations.dart';
import '../models/saju_profile.dart';

/// Preference for the app's theme.
enum AppThemePreference { light, dark, system }

/// State container for the application, following React AppContext.
class AppState extends ChangeNotifier {
  AppLanguage _language = AppLanguage.ko;
  AppThemePreference _theme = AppThemePreference.dark;
  SajuProfile? _profile;
  bool _isFirstRun = true;
  bool _meetingUnlocked = false;
  bool _meetingNotificationShown = false;

  AppLanguage get language => _language;
  AppThemePreference get theme => _theme;
  SajuProfile? get profile => _profile;
  bool get isFirstRun => _isFirstRun;
  bool get hasSajuProfile => _profile != null;
  bool get meetingUnlocked => _meetingUnlocked;
  bool get meetingNotificationShown => _meetingNotificationShown;

  /// Whether the meeting notification banner should appear on home.
  /// Shows when: user has saju profile AND notification hasn't been shown yet.
  bool get shouldShowMeetingNotification =>
      hasSajuProfile && !_meetingNotificationShown;

  /// Loads state from SharedPreferences (startup only)
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final langStr = prefs.getString('language');
    if (langStr != null) {
      _language = AppLanguage.values.firstWhere(
        (e) => e.name == langStr,
        orElse: () => AppLanguage.ko,
      );
    }

    final themeStr = prefs.getString('theme');
    if (themeStr != null) {
      _theme = AppThemePreference.values.firstWhere(
        (e) => e.name == themeStr,
        orElse: () => AppThemePreference.dark,
      );
    }

    final profileJson = prefs.getString('saju_profile');
    if (profileJson != null) {
      try {
        _profile = SajuProfile.fromJson(jsonDecode(profileJson));
      } catch (e) {
        debugPrint('Failed to load profile: $e');
      }
    }

    _isFirstRun = !(prefs.getBool('first_run_complete') ?? false);
    _meetingUnlocked = prefs.getBool('meeting_unlocked') ?? false;
    _meetingNotificationShown =
        prefs.getBool('meeting_notification_shown') ?? false;

    notifyListeners();
  }

  /// Marks first run as complete
  Future<void> completeFirstRun() async {
    _isFirstRun = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_run_complete', true);
    notifyListeners();
  }

  /// Resets first run (for testing)
  Future<void> resetFirstRun() async {
    _isFirstRun = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('first_run_complete');
    notifyListeners();
  }

  Future<void> saveProfile(SajuProfile profile) async {
    _profile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saju_profile', jsonEncode(profile.toJson()));
    notifyListeners();
  }

  Future<void> clearProfile() async {
    _profile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saju_profile');
    notifyListeners();
  }

  /// Marks the meeting notification as shown (won't appear as banner again)
  Future<void> markMeetingNotificationShown() async {
    _meetingNotificationShown = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('meeting_notification_shown', true);
    notifyListeners();
  }

  /// Unlocks the meeting feature permanently
  Future<void> unlockMeeting() async {
    _meetingUnlocked = true;
    _meetingNotificationShown = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('meeting_unlocked', true);
    await prefs.setBool('meeting_notification_shown', true);
    notifyListeners();
  }

  /// Returns translation for [key] based on current language.
  /// Falls back to [key] if translation missing.
  String t(String key) {
    return Translations.t(_language, key);
  }

  /// Updates language and notifies listeners.
  void setLanguage(AppLanguage lang) async {
    if (_language != lang) {
      _language = lang;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', lang.name);
      notifyListeners();
    }
  }

  /// Updates theme preference and notifies listeners.
  void setTheme(AppThemePreference themePreference) async {
    if (_theme != themePreference) {
      _theme = themePreference;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme', themePreference.name);
      notifyListeners();
    }
  }

  /// Helper to get Flutter ThemeMode from preference.
  ThemeMode get themeMode {
    switch (_theme) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
        return ThemeMode.system;
    }
  }
}
