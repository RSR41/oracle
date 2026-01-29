import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<SettingsState> build() async {
    // Load from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final themeIndex =
        prefs.getInt('themeMode') ?? 0; // 0: System, 1: Light, 2: Dark
    final languageCode = prefs.getString('languageCode');
    final isSolar = prefs.getBool('isSolar') ?? true;

    return SettingsState(
      themeMode: ThemeMode.values[themeIndex],
      locale:
          languageCode != null ? Locale(languageCode) : null, // null = system
      isSolar: isSolar,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    state = AsyncValue.data(state.value!.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove('languageCode');
    } else {
      await prefs.setString('languageCode', locale.languageCode);
    }
    state = AsyncValue.data(state.value!.copyWith(locale: locale));
  }

  Future<void> setCalendarType(bool isSolar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSolar', isSolar);
    state = AsyncValue.data(state.value!.copyWith(isSolar: isSolar));
  }
}

class SettingsState {
  final ThemeMode themeMode;
  final Locale? locale;
  final bool isSolar;

  const SettingsState({
    required this.themeMode,
    this.locale,
    required this.isSolar,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? isSolar,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isSolar: isSolar ?? this.isSolar,
    );
  }
}
