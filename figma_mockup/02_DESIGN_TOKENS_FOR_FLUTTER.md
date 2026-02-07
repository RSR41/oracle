# Flutter Design Tokens

React 프로젝트의 `src/styles/theme.css`를 기반으로 정의된 Flutter 스타일 가이드입니다.

## Colors (`AppColors`)

`src/styles/theme.css`의 CSS 변수를 Flutter `Color` 객체로 매핑합니다.

### Palette (Warm / Oracle Style)
```dart
abstract class AppColors {
  // Base Colors
  static const Color background = Color(0xFFFAF8F3); // --background
  static const Color foreground = Color(0xFF3D3530); // --foreground
  
  // Cards & Popovers
  static const Color card = Color(0xFFFFFFFF); // --card
  static const Color cardForeground = Color(0xFF3D3530); // --card-foreground
  
  // Primary (Warm Brown)
  static const Color primary = Color(0xFF8B6F47); // --primary
  static const Color primaryForeground = Color(0xFFFFFFFF); // --primary-foreground
  
  // Secondary (Soft Beige)
  static const Color secondary = Color(0xFFF5F1EA); // --secondary
  static const Color secondaryForeground = Color(0xFF3D3530); // --secondary-foreground
  
  // Muted
  static const Color muted = Color(0xFFE8E4DD); // --muted
  static const Color mutedForeground = Color(0xFF6B6258); // --muted-foreground
  
  // Accent (Peachy/Sage variations)
  static const Color accent = Color(0xFFE8DED0); // --accent
  static const Color accentForeground = Color(0xFF3D3530); // --accent-foreground
  
  // Destructive (Soft Red)
  static const Color destructive = Color(0xFFD4756F); // --destructive
  static const Color destructiveForeground = Color(0xFFFFFFFF); // --destructive-foreground
  
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
}
```

## Typography

`src/styles/theme.css` 및 `src/styles/fonts.css` (확인 필요) 기반.
기본 폰트는 `-apple-system`, `Noto Sans KR`을 사용합니다.

### TextTheme
Flutter `ThemeData`에 적용할 텍스트 스타일입니다.

| React Class | CSS Var | Flutter TextTheme | Size | Weight |
|---|---|---|---|---|
| `h1` | `--text-2xl` | `headlineSmall` | 24px+ | w600 (Medium) |
| `h2` | `--text-xl` | `titleLarge` | 20px | w600 |
| `h3` | `--text-lg` | `titleMedium` | 18px | w600 |
| `h4` / `label` | `--text-base` | `bodyLarge` / `labelLarge` | 16px | w600 / w400 |
| `p` / `input` | `--text-base` | `bodyMedium` | 16px | w400 (Normal) |
| `small` (유추) | `--text-sm` | `bodySmall` | 14px | w400 |

```dart
TextTheme(
  headlineSmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.foreground,
  ),
  titleLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.foreground,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    color: AppColors.foreground,
  ),
  // ...
)
```

## Spacing & Radius

- **Radius**: `--radius` = `1rem` (16px)
  - `BorderRadius.circular(16)` 사용 권장.
- **Spacing**: Tailwind 기본 `rem` 단위를 사용. Flutter에서는 `8px` 단위 (`p-2`, `p-4`) 매핑 권장.

## Dark Mode (`.dark`)

`theme.css`에 정의된 dark 값을 `ThemeData.dark()` 생성 시 `ColorScheme`에 매핑합니다.

```dart
// Dark ColorScheme override
static const Color darkBackground = Color(0xFF2A2420);
static const Color darkForeground = Color(0xFFF5F1EA);
static const Color darkPrimary = Color(0xFFC4A574); // Lighter brown
// ...
```
