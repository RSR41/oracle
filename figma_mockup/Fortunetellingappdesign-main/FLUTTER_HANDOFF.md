# Oracle App - Flutter Handoff Guide

React 앱을 Flutter로 전환하기 위한 가이드입니다.

## 📁 프로젝트 구조

### Recommended Flutter Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart (MaterialApp 설정)
│   └── routes.dart (네비게이션 라우트)
├── core/
│   ├── theme/
│   │   ├── app_theme.dart (테마 정의)
│   │   ├── colors.dart (색상 토큰)
│   │   └── text_styles.dart (타이포그래피)
│   ├── constants/
│   │   └── spacing.dart (spacing 값)
│   └── utils/
│       └── i18n.dart (다국어)
├── features/
│   ├── onboarding/
│   │   ├── screens/
│   │   └── widgets/
│   ├── home/
│   │   ├── screens/
│   │   └── widgets/
│   ├── fortune/
│   │   ├── screens/
│   │   └── widgets/
│   ├── compatibility/
│   ├── history/
│   ├── profile/
│   ├── face_reading/
│   ├── ideal_type/
│   ├── connection/
│   ├── chat/
│   ├── tarot/
│   └── dream/
└── shared/
    ├── widgets/
    │   ├── bottom_nav.dart
    │   ├── oracle_card.dart
    │   └── placeholder_screen.dart
    └── models/
```

## 🎨 Design System Implementation

### 1. Theme Definition (app_theme.dart)

```dart
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.cream,
      surface: AppColors.cardLight,
      background: AppColors.backgroundLight,
      error: AppColors.error,
    ),
    textTheme: AppTextStyles.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.cream,
      surface: AppColors.cardDark,
      background: AppColors.backgroundDark,
      error: AppColors.error,
    ),
    textTheme: AppTextStyles.darkTextTheme,
  );
}
```

### 2. Colors (colors.dart)

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF8B6F47);
  static const Color primaryLight = Color(0xFFC4A574);
  static const Color primaryDark = Color(0xFF6B5537);

  // Secondary
  static const Color cream = Color(0xFFE9C5B5);
  static const Color green = Color(0xFF9DB4A0);
  static const Color blue = Color(0xFFB8D4E8);

  // Background
  static const Color backgroundLight = Color(0xFFFDFBF8);
  static const Color backgroundDark = Color(0xFF2B2520);

  // Card
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF3A3230);

  // Border
  static const Color borderLight = Color(0xFFE5E0DB);
  static const Color borderDark = Color(0xFF4A4240);

  // Text
  static const Color foregroundLight = Color(0xFF2B2520);
  static const Color foregroundDark = Color(0xFFF5F5F0);
  static const Color mutedLight = Color(0xFF6B625A);
  static const Color mutedDark = Color(0xFFA8A09B);

  // Status
  static const Color success = Color(0xFF9DB4A0);
  static const Color warning = Color(0xFFE9C5B5);
  static const Color error = Color(0xFFD9534F);
  static const Color info = Color(0xFFB8D4E8);
}
```

### 3. Typography (text_styles.dart)

```dart
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const String fontFamily = 'System'; // or custom font

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: AppColors.foregroundLight,
    ),
    displayMedium: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: AppColors.foregroundLight,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.foregroundLight,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.foregroundLight,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.foregroundLight,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.foregroundLight,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.mutedLight,
    ),
  );

  static TextTheme darkTextTheme = lightTextTheme.apply(
    bodyColor: AppColors.foregroundDark,
    displayColor: AppColors.foregroundDark,
  );
}
```

## 📱 Component Mapping

### React → Flutter Widget 매핑 테이블

| React Component | Flutter Widget | Notes |
|----------------|----------------|-------|
| `<div>` | `Container` / `Column` / `Row` | Layout에 따라 선택 |
| `<button>` | `ElevatedButton` / `TextButton` / `OutlinedButton` | 스타일에 따라 |
| `<input>` | `TextField` | - |
| Framer Motion | `AnimatedContainer` / `AnimatedOpacity` | 또는 `animate_do` package |
| `<img>` | `Image.network` / `CachedNetworkImage` | |
| `useState` | `StatefulWidget` + `setState` | 또는 Provider/Riverpod |
| `useContext` | `Provider` / `Riverpod` | 상태관리 라이브러리 사용 |

### Key Components

#### 1. BottomNav

```dart
class BottomNav extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChange;

  const BottomNav({
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 'home', Icons.home, '홈'),
          _buildNavItem(context, 'fortune', Icons.star, '운세'),
          _buildNavItem(context, 'compatibility', Icons.favorite, '궁합'),
          _buildNavItem(context, 'history', Icons.history, '히스토리'),
          _buildNavItem(context, 'profile', Icons.person, '내정보'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, 
    String id, 
    IconData icon, 
    String label
  ) {
    final isActive = activeTab == id;
    return GestureDetector(
      onTap: () => onTabChange(id),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive 
              ? Theme.of(context).primaryColor
              : Theme.of(context).textTheme.bodySmall?.color,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive 
                ? Theme.of(context).primaryColor
                : Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
```

#### 2. OracleCard

```dart
class OracleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String? badge;
  final VoidCallback? onTap;

  const OracleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (badge != null) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              fontSize: 10,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🗺️ Navigation & Routing

### Route Names (routes.dart)

```dart
class Routes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String fortune = '/fortune';
  static const String fortuneToday = '/fortune/today';
  static const String calendar = '/calendar';
  static const String compatibility = '/compatibility';
  static const String compatCheck = '/compatibility/check';
  static const String compatResult = '/compatibility/result';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String settings = '/settings';
  static const String faceReading = '/face';
  static const String idealType = '/ideal-type';
  static const String connection = '/connection';
  static const String chat = '/chat';
  static const String tarot = '/tarot';
  static const String dream = '/dream';
  static const String consultation = '/consultation';
  static const String premium = '/premium';
}
```

### Navigation Implementation

```dart
// Use Navigator 2.0 or go_router package
// go_router 추천:

import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/fortune/today',
      builder: (context, state) => FortuneTodayScreen(),
    ),
    // ... 나머지 라우트
  ],
);
```

## 🌐 Internationalization (i18n)

### Setup

```dart
// pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

// Use easy_localization package:
dependencies:
  easy_localization: ^3.0.0

// assets/translations/ko.json
{
  "nav": {
    "home": "홈",
    "fortune": "운세",
    "compatibility": "궁합",
    "history": "히스토리",
    "profile": "내정보"
  },
  "home": {
    "title": "Oracle",
    "todayFortune": "오늘의 운세",
    "viewDetail": "자세히 보기"
  }
}

// Usage:
Text('nav.home'.tr())
```

## 📦 Recommended Packages

### Core
- `provider` or `riverpod`: 상태관리
- `go_router`: 네비게이션
- `easy_localization`: 다국어

### UI/UX
- `cached_network_image`: 이미지 캐싱
- `animate_do`: 애니메이션
- `shimmer`: 로딩 스켈레톤
- `flutter_svg`: SVG 지원

### Utilities
- `intl`: 날짜/숫자 포맷
- `shared_preferences`: 로컬 저장소
- `url_launcher`: 외부 링크

### Optional
- `firebase_core`, `firebase_auth`: 인증
- `cloud_firestore`: 데이터베이스 (Supabase 대신)
- `image_picker`: 이미지 선택
- `permission_handler`: 권한 관리

## ⚡ Performance Tips

1. **Lazy Loading**: 필요한 화면만 로드
2. **Image Optimization**: `CachedNetworkImage` 사용
3. **State Management**: Provider/Riverpod로 불필요한 rebuild 방지
4. **Const Widgets**: 가능한 모든 곳에 const 사용
5. **List Performance**: `ListView.builder` 사용

## 🔐 Security Notes

1. **API Keys**: 환경변수나 Flutter의 `--dart-define` 사용
2. **Sensitive Data**: `flutter_secure_storage` 사용
3. **SSL Pinning**: 프로덕션에서는 SSL pinning 고려

## 📋 Migration Checklist

- [ ] 프로젝트 구조 설정
- [ ] 디자인 토큰 Flutter로 변환
- [ ] 공통 위젯 구현 (BottomNav, OracleCard 등)
- [ ] 라우팅 설정
- [ ] 다국어 설정
- [ ] 상태관리 설정
- [ ] 온보딩 화면 구현
- [ ] 메인 탭 화면들 (Home, Fortune, Compatibility, History, Profile)
- [ ] 기능 화면들 (Tarot, Dream, FaceReading, etc.)
- [ ] 애니메이션 추가
- [ ] 테마 전환 기능
- [ ] 이미지 최적화
- [ ] 테스팅
- [ ] 빌드 & 배포

## 🎯 Priority Order

1. **Core Navigation** (Bottom Nav, Routes)
2. **Design System** (Theme, Colors, Typography)
3. **Main Screens** (5 Tab Screens)
4. **Feature Screens** (Fortune Today, Calendar, etc.)
5. **Advanced Features** (Animations, Transitions)
6. **Polish** (Loading states, Error handling)

---

## Additional Resources

- [Flutter Official Docs](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [Provider Package](https://pub.dev/packages/provider)
- [Go Router](https://pub.dev/packages/go_router)
