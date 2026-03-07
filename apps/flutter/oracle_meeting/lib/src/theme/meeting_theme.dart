import 'package:flutter/material.dart';

/// Premium meeting theme — purple + white gradient design
class MeetingTheme {
  MeetingTheme._();

  // ─── Primary Colors ───
  static const Color primary = Color(0xFF7C4DFF);
  static const Color primaryLight = Color(0xFFB388FF);
  static const Color primaryDark = Color(0xFF5E35B1);
  static const Color accent = Color(0xFFE040FB);

  // ─── Surface Colors ───
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF8F5FF);
  static const Color background = Color(0xFFFAF8FF);

  // ─── Text Colors ───
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B8D);
  static const Color textOnPrimary = Colors.white;

  // ─── Status Colors ───
  static const Color like = Color(0xFFE040FB);
  static const Color pass = Color(0xFFBDBDBD);
  static const Color match = Color(0xFFFF6090);
  static const Color online = Color(0xFF4CAF50);

  // ─── Compatibility Band Colors ───
  static const Color excellent = Color(0xFFFF6090);
  static const Color good = Color(0xFF7C4DFF);
  static const Color normal = Color(0xFF42A5F5);
  static const Color caution = Color(0xFFBDBDBD);

  static Color bandColor(String band) {
    switch (band) {
      case 'EXCELLENT':
        return excellent;
      case 'GOOD':
        return good;
      case 'NORMAL':
        return normal;
      default:
        return caution;
    }
  }

  // ─── Gradients ───
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF9C6AFF), primary],
  );

  static const LinearGradient matchCelebrationGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE040FB), Color(0xFF7C4DFF), Color(0xFF536DFE)],
  );

  // ─── Decorations ───
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get profileCardDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      );

  // ─── Text Styles ───
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: textOnPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: textOnPrimary,
  );

  // ─── Button Styles ───
  static ButtonStyle get likeButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: like,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        elevation: 8,
        shadowColor: like.withValues(alpha: 0.4),
      );

  static ButtonStyle get passButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: pass,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      );

  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        elevation: 4,
        shadowColor: primary.withValues(alpha: 0.3),
      );
}
