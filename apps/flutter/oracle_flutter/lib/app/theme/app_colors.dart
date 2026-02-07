import 'package:flutter/material.dart';

abstract class AppColors {
  // Base Colors
  static const Color background = Color(0xFFFAF8F3); // --background
  static const Color foreground = Color(0xFF3D3530); // --foreground

  // Cards & Popovers
  static const Color card = Color(0xFFFFFFFF); // --card
  static const Color cardForeground = Color(0xFF3D3530); // --card-foreground

  // Primary (Warm Brown)
  static const Color primary = Color(0xFF8B6F47); // --primary
  static const Color primaryForeground = Color(
    0xFFFFFFFF,
  ); // --primary-foreground

  // Secondary (Soft Beige)
  static const Color secondary = Color(0xFFF5F1EA); // --secondary
  static const Color secondaryForeground = Color(
    0xFF3D3530,
  ); // --secondary-foreground

  // Muted
  static const Color muted = Color(0xFFE8E4DD); // --muted
  static const Color mutedForeground = Color(0xFF6B6258); // --muted-foreground

  // Accent
  static const Color accent = Color(0xFFE8DED0); // --accent
  static const Color accentForeground = Color(
    0xFF3D3530,
  ); // --accent-foreground

  // Destructive
  static const Color destructive = Color(0xFFD4756F); // --destructive
  static const Color destructiveForeground = Color(
    0xFFFFFFFF,
  ); // --destructive-foreground

  // UI Elements
  static const Color border = Color(0x268B6F47); // --border (rgba 0.15 alpha)
  static const Color inputBackground = Color(0xFFF5F1EA); // --input-background
  static const Color ring = Color(0xFF8B6F47); // --ring

  // Custom Oracle Palette
  static const Color warmCream = Color(0xFFFAF8F3);
  static const Color softBeige = Color(0xFFF5F1EA);
  static const Color warmBrown = Color(0xFF8B6F47);
  static const Color caramel = Color(0xFFC4A574);
  static const Color sage = Color(0xFF9DB4A0);
  static const Color peach = Color(0xFFE9C5B5);
  static const Color skyPastel = Color(0xFFB8D4E8);
  static const Color warmGray = Color(0xFF6B6258);

  // Charts
  static const Color chart1 = Color(0xFF8B6F47);
  static const Color chart2 = Color(0xFF9DB4A0);
  static const Color chart3 = Color(0xFFE9C5B5);
  static const Color chart4 = Color(0xFFB8D4E8);
  static const Color chart5 = Color(0xFFC4A574);

  // Dark Mode Overrides
  static const Color darkBackground = Color(0xFF2A2420);
  static const Color darkForeground = Color(0xFFF5F1EA);
  static const Color darkCard = Color(0xFF342E28);
  static const Color darkCardForeground = Color(0xFFF5F1EA);
  static const Color darkPrimary = Color(0xFFC4A574);
  static const Color darkPrimaryForeground = Color(0xFF2A2420);
  static const Color darkSecondary = Color(0xFF3D362F);
  static const Color darkSecondaryForeground = Color(0xFFF5F1EA);
  static const Color darkMuted = Color(0xFF3D362F);
  static const Color darkMutedForeground = Color(0xFFA39789);
  static const Color darkBorder = Color(0x33C4A574); // rgba(196, 165, 116, 0.2)
}
