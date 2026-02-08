import 'package:flutter/material.dart';

abstract class AppColors {
  // =============================================
  // Starry Night Theme (Primary Theme)
  // =============================================

  // Base Night Sky
  static const Color nightSkyDark = Color(0xFF0D1B2A); // 가장 어두운 배경
  static const Color nightSkySurface = Color(0xFF1B2838); // 카드/표면
  static const Color nightSkyCard = Color(0xFF243447); // 카드 배경

  // Accent Colors
  static const Color starGold = Color(0xFFF4A836); // 메인 골드 (버튼, 강조)
  static const Color starGoldLight = Color(0xFFFFCC66); // 밝은 골드
  static const Color starOrange = Color(0xFFE8853A); // 오렌지 강조

  // Text Colors
  static const Color nightTextPrimary = Color(0xFFE0E1DD); // 메인 텍스트
  static const Color nightTextSecondary = Color(0xFFA8B2C1); // 보조 텍스트
  static const Color nightTextMuted = Color(0xFF778DA9); // 흐린 텍스트

  // UI Elements
  static const Color nightBorder = Color(0xFF3D4F61); // 테두리
  static const Color nightDivider = Color(0xFF2D3E50); // 구분선

  // Star Colors (for animation)
  static const Color starWhite = Color(0xFFFFFFFF); // 흰 별 (펄스 효과)
  static const Color starYellow = Color(0xFFFFD700); // 노란 별
  static const Color starBlue = Color(0xFF87CEEB); // 파란 별

  // =============================================
  // Light Mode (Daytime Theme)
  // =============================================
  // =============================================
  // Light Mode (Mystical Dawn Theme)
  // =============================================
  static const Color lightBackground = Color(0xFFFDFBF7); // 따뜻한 크림 화이트
  static const Color lightSurface = Color(0xFFFFFFFF); // 순백색
  static const Color lightCard = Color(0xFFFFFBF0); // 아주 연한 웜톤 카드
  static const Color lightPrimary = Color(0xFF8B6F47); // 웜 브라운 (기존 유지)
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFFE9C5B5); // 피치 (따뜻한 강조)
  static const Color lightSecondaryForeground = Color(0xFF5D4037);
  static const Color lightTextPrimary = Color(0xFF4A403A); // 다크 웜 그레이
  static const Color lightTextSecondary = Color(0xFF8D837D); // 미디엄 웜 그레이
  static const Color lightTextMuted = Color(0xFFC4BBB5); // 연한 웜 그레이
  static const Color lightBorder = Color(0xFFEDE8E0); // 따뜻한 회색 테두리
  static const Color lightDivider = Color(0xFFF5F1EA); // 연한 구분선

  // =============================================
  // Dark Mode (Deep Night Theme)
  // =============================================
  static const Color darkBackground = Color(0xFF0A0E14); // 더 어두운 배경
  static const Color darkSurface = Color(0xFF141A22); // 표면
  static const Color darkCard = Color(0xFF1E2630); // 카드
  static const Color darkPrimary = Color(0xFFC4A574); // 골드 브라운
  static const Color darkPrimaryForeground = Color(0xFF0A0E14);
  static const Color darkSecondary = Color(0xFF2A3441);
  static const Color darkSecondaryForeground = Color(0xFFE0E1DD);
  static const Color darkTextPrimary = Color(0xFFE8E6E3);
  static const Color darkTextSecondary = Color(0xFFB0ADA8);
  static const Color darkTextMuted = Color(0xFF6B6965);
  static const Color darkBorder = Color(0xFF3A4250);
  static const Color darkDivider = Color(0xFF252D38);

  // =============================================
  // Legacy Colors (for backward compatibility)
  // =============================================
  static const Color background = lightBackground;
  static const Color foreground = lightTextPrimary;
  static const Color card = lightCard;
  static const Color cardForeground = lightTextPrimary;
  static const Color primary = Color(0xFF8B6F47);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondary = lightSecondary;
  static const Color secondaryForeground = lightSecondaryForeground;
  static const Color muted = Color(0xFFE8E4DD);
  static const Color mutedForeground = Color(0xFF6B6258);
  static const Color accent = Color(0xFFE8DED0);
  static const Color accentForeground = Color(0xFF3D3530);
  static const Color destructive = Color(0xFFD4756F);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color border = Color(0x268B6F47);
  static const Color inputBackground = lightSecondary;
  static const Color ring = Color(0xFF8B6F47);

  // Custom Palette
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

  // Gradients
  static LinearGradient get nightSkyGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D1B2A), Color(0xFF1B2838), Color(0xFF243447)],
  );

  static LinearGradient get goldButtonGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFCC66), Color(0xFFF4A836), Color(0xFFE8853A)],
  );
}
