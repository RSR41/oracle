import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // =============================================
  // Light Theme (라이트 모드)
  // =============================================
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightPrimaryForeground,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightSecondaryForeground,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.destructive,
      onError: AppColors.destructiveForeground,
      outline: AppColors.lightBorder,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.lightSurface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: const TextStyle(color: AppColors.lightTextMuted),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.lightTextPrimary,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(fontSize: 15, color: AppColors.lightTextSecondary),
      bodySmall: TextStyle(fontSize: 13, color: AppColors.lightTextMuted),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightBorder, width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextPrimary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.lightTextMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      indicatorColor: AppColors.lightSecondary.withValues(alpha: 0.3),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.lightPrimary);
        }
        return const IconThemeData(color: AppColors.lightTextMuted);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.lightPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(color: AppColors.lightTextMuted, fontSize: 12);
      }),
    ),
  );

  // =============================================
  // Dark Theme (다크 모드 - 밤하늘 별 테마)
  // =============================================
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.starGold,
      onPrimary: AppColors.nightSkyDark,
      secondary: AppColors.nightSkySurface,
      onSecondary: AppColors.nightTextPrimary,
      surface: AppColors.nightSkySurface,
      onSurface: AppColors.nightTextPrimary,
      error: AppColors.destructive,
      onError: AppColors.destructiveForeground,
      outline: AppColors.nightBorder,
    ),
    scaffoldBackgroundColor: AppColors.nightSkyDark,
    dividerTheme: const DividerThemeData(
      color: AppColors.nightDivider,
      thickness: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.nightSkySurface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.nightBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.starGold, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(color: AppColors.nightTextSecondary),
      hintStyle: const TextStyle(color: AppColors.nightTextMuted),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.nightTextPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.nightTextPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.nightTextPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.nightTextPrimary),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.nightTextPrimary),
      bodySmall: TextStyle(fontSize: 14, color: AppColors.nightTextSecondary),
    ),
    // Date Picker - 밤하늘 테마 (한국어 + 가시성 개선)
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.nightSkyCard,
      headerBackgroundColor: AppColors.nightSkySurface,
      headerForegroundColor: AppColors.starGold,
      dayForegroundColor: WidgetStatePropertyAll(AppColors.nightTextPrimary),
      todayForegroundColor: WidgetStatePropertyAll(AppColors.starGold),
      todayBackgroundColor: WidgetStatePropertyAll(AppColors.nightSkySurface),
      yearForegroundColor: WidgetStatePropertyAll(AppColors.nightTextPrimary),
      surfaceTintColor: Colors.transparent,
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.starGold;
        }
        return null;
      }),
      dayOverlayColor: WidgetStatePropertyAll(
        AppColors.starGold.withValues(alpha: 0.2),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.nightSkyCard,
      dialBackgroundColor: AppColors.nightSkySurface,
      dialHandColor: AppColors.starGold,
      dialTextColor: AppColors.nightTextPrimary,
      hourMinuteTextColor: AppColors.nightTextPrimary,
      hourMinuteColor: AppColors.nightSkySurface,
      dayPeriodTextColor: AppColors.starGold,
      dayPeriodColor: AppColors.nightSkySurface,
      entryModeIconColor: AppColors.nightTextPrimary,
    ),
    // 카드 테마
    cardTheme: CardThemeData(
      color: AppColors.nightSkyCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.nightBorder, width: 1),
      ),
    ),
    // 앱바 테마
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.nightTextPrimary),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.nightTextPrimary,
      ),
    ),
    // 바텀 네비게이션
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.nightSkyDark,
      selectedItemColor: AppColors.starGold,
      unselectedItemColor: AppColors.nightTextMuted,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.nightSkyDark,
      indicatorColor: AppColors.starGold.withValues(alpha: 0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.starGold);
        }
        return const IconThemeData(color: AppColors.nightTextMuted);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: AppColors.starGold, fontSize: 12);
        }
        return const TextStyle(color: AppColors.nightTextMuted, fontSize: 12);
      }),
    ),
  );
}
