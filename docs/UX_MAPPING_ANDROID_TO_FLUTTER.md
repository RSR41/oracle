# UX Mapping: Android to Flutter

## Overview

This document maps the existing Android (Jetpack Compose) screens to their Flutter equivalents.

---

## Screen Mapping Table

| Android Screen | Flutter Screen | Notes |
|----------------|----------------|-------|
| `HomeScreen.kt` | `home_screen.dart` | Same layout |
| `InputScreen.kt` | `input_screen.dart` | Add leap month option |
| `ResultScreen.kt` | `result_screen.dart` | Add save/share |
| `HistoryScreen.kt` | `history_screen.dart` | Same |
| `SettingsScreen.kt` | `settings_screen.dart` | Same |
| `FortuneScreen.kt` | `fortune_screen.dart` | Same (Manseok) |
| `CompatibilityScreen.kt` | `compatibility_screen.dart` | Same |
| `FaceReadingScreen.kt` | `face_reading_screen.dart` | Dummy AI |
| `TarotScreen.kt` | `tarot_screen.dart` | 36 cards |
| `DreamScreen.kt` | `dream_screen.dart` | Search + browse |

---

## Detailed Screen Mapping

### 1. Home Screen

**Android**: `ui/screens/home/HomeScreen.kt` (265 lines)

**Components**:
| Android Component | Flutter Widget |
|-------------------|----------------|
| `TodayFortuneCard` | `TodayFortuneCard` |
| `DailyLuckyCard` | `DailyLuckyCard` |
| `FeatureGrid` | `FeatureGrid` |
| `FeatureItem` | `FeatureItem` |

**Navigation callbacks**: 9 (`onNavigateToInput`, `onNavigateToResult`, etc.)

---

### 2. Profile Setup / Input Screen

**Android**: `ui/screens/InputScreen.kt` (9,112 bytes)

**UI Elements**:
| Element | Type | Validation |
|---------|------|------------|
| Birth Date | TextField | yyyy-MM-dd format |
| Birth Time | TextField | HH:mm format |
| Unknown Time | Checkbox | Disables time input |
| Gender | RadioButtons | Male/Female |
| Calendar Type | RadioButtons | Solar/Lunar |
| Leap Month | Checkbox | **NEW - add to Flutter** |
| Save for later | Checkbox | Persists profile |

**Flutter additions**:
- DatePicker dialog (instead of text input)
- TimePicker dialog (instead of text input)
- Leap month visible when Lunar selected

---

### 3. Saju Result Screen

**Android**: `ui/screens/ResultScreen.kt` (10,216 bytes)

**Sections**:
1. Today's Fortune summary text
2. Four Pillars (년주/월주/일주/시주)
3. Lucky Color (color circle)
4. Lucky Number
5. Input Info summary
6. Action buttons (Retry, History)

**Flutter additions**:
- **Save button** with confirmation
- **Share button** (text/image)

---

### 4. History Screen

**Android**: `ui/screens/HistoryScreen.kt` (12,006 bytes)

**Features**:
- List of saved results
- Delete individual items
- Clear all with confirmation
- Tap to view details
- Filter by type (Legacy Records)

**Flutter same implementation**.

---

### 5. Settings Screen

**Android**: `ui/screens/SettingsScreen.kt` (9,453 bytes)

**Settings**:
| Setting | Options |
|---------|---------|
| Language | Korean, English, System |
| Theme | Light, Dark, System |
| Default Calendar | Solar, Lunar |
| App Version | Display only |

**Flutter same implementation**.

---

### 6. Fortune (Manseok) Screen

**Android**: `ui/screens/fortune/FortuneScreen.kt`

**Tabs**:
- 대운 (Great Luck / 10-year cycle)
- 세운 (Yearly Luck)
- 월운 (Monthly Luck)

**Profile selection required**.

---

### 7. Compatibility Screen

**Android**: `ui/screens/compatibility/CompatibilityScreen.kt` (10,877 bytes)

**Flow**:
1. Select "My Profile" from saved profiles
2. Select "Partner Profile" from saved profiles
3. Tap "Analyze Compatibility"
4. View result (score + interpretation)

---

### 8. Face Reading Screen

**Android**: `ui/screens/face/FaceReadingScreen.kt` (12,213 bytes)

**Flow**:
1. Terms dialog (consent)
2. Camera/Gallery selection
3. Image preview
4. "Start Analysis" button
5. Loading state
6. Result display

**Flutter MVP**:
- Keep UI flow
- Replace ML Kit with dummy result
- Store analysis metadata (not photo)

---

### 9. Tarot Screen

**Android**: `ui/screens/tarot/TarotScreen.kt` (13,816 bytes)

**Deck**: 36 cards (Major Arcana subset)

**Flow**:
1. Instruction: "Pick 3 cards"
2. 3 pages of 12 cards each
3. Tap to select/deselect
4. Selected cards flip to show back
5. "View Result" when 3 selected
6. Result shows card meanings + overall interpretation

---

### 10. Dream Screen

**Android**: `ui/screens/dream/DreamScreen.kt` (12,684 bytes)

**Features**:
- Search bar
- Popular keywords chips
- Category filter grid
- Dream result cards
- Detail dialog on tap

**Data source**: Local database (seeded)

---

## Component Mapping

### Common Components

| Android | Flutter |
|---------|---------|
| `SectionCard` | `SectionCard` |
| `SelectableChipRow` | `SelectableChipRow` |
| Material3 Surface | Card |
| Material3 Button | ElevatedButton |

### Theme

| Android | Flutter |
|---------|---------|
| `Color.kt` | `app_colors.dart` |
| `Theme.kt` | `app_theme.dart` |
| `Type.kt` | `app_typography.dart` |

---

## Navigation Mapping

### Android (Compose Navigation)
```kotlin
object Routes {
    const val HOME = "HOME"
    const val INPUT = "INPUT"
    const val RESULT = "RESULT"
    // ...
}
```

### Flutter (go_router)
```dart
enum AppRoute {
  home('/'),
  input('/input'),
  result('/result'),
  history('/history'),
  settings('/settings'),
  fortune('/fortune'),
  compatibility('/compatibility'),
  face('/face'),
  tarot('/tarot'),
  dream('/dream');
  
  final String path;
  const AppRoute(this.path);
}
```

---

## i18n String Migration

### Source
- `values/strings.xml` (default/English)
- `values-ko/strings.xml` (Korean)

### Target
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ko.arb`

### Example Conversion

**Android (strings.xml)**:
```xml
<string name="home_today_fortune">🔮 Today\'s Fortune</string>
<string name="home_view_fortune">View Fortune</string>
```

**Flutter (app_en.arb)**:
```json
{
  "homeTodayFortune": "🔮 Today's Fortune",
  "homeViewFortune": "View Fortune"
}
```
