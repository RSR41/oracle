# Phase 4 Route Audit

## 1. Route Map Overview
| Route Path | React Mockup (UI) | Flutter Implementation (Current) | Status | Priority (Phase 4) |
| :--- | :--- | :--- | :--- | :--- |
| `/home` | `Home.tsx` | `HomeScreen` | ✅ Ported | - |
| `/fortune` | `Fortune.tsx` | `FortuneScreen` | ✅ Ported | - |
| `/history` | `History.tsx` | `HistoryScreen` (Skeleton) | ⚠️ Layout Only | High |
| `/compatibility` | `Compatibility.tsx` | `CompatibilityScreen` (Skeleton) | ⚠️ Layout Only | Medium |
| `/settings` | `Settings.tsx` | `SettingsScreen` (Skeleton) | ⚠️ Layout Only | Low |
| `/fortune-today` | `FortuneToday.tsx` | `ComingSoonScreen` | ❌ Placeholder | **Critical** |
| `/calendar` | `Calendar.tsx` | `ComingSoonScreen` | ❌ Placeholder | Medium |
| `/saju-analysis` | `SajuAnalysis.tsx` | `ComingSoonScreen` | ❌ Placeholder | Medium |
| `/tarot` | `Tarot.tsx` | `ComingSoonScreen` | ❌ Placeholder | Low |
| `/dream` | `Dream.tsx` | `ComingSoonScreen` | ❌ Placeholder | Low |
| `/connection` | `Connection.tsx` | `ComingSoonScreen` | ❌ Placeholder | Low |

## 2. Navigation Flow Analysis
### Home Screen (`home_screen.dart`)
- `t('home.viewDetail')` → `/fortune-today` (Placeholder)
- Quick Access:
  - Calendar → `/calendar` (Placeholder)
  - Compatibility → `/compatibility` (Skeleton)
  - Tarot → `/tarot` (Placeholder)
  - Dream → `/dream` (Placeholder)
- Connection → `/connection` (Placeholder)

### Fortune Screen (`fortune_screen.dart`)
- Today Card → `/fortune-today` (Placeholder)
- Calendar Card → `/calendar` (Placeholder)
- Saju Analysis → `/saju-analysis` (Placeholder)
- Tarot → `/tarot` (Placeholder)
- Dream → `/dream` (Placeholder)

## 3. Discrepancies & Issues
1.  **Saving Interaction**: In React, there is usually a "Save" or "Share" button for fortune results. Flutter needs to implement this in `/fortune-today`.
2.  **History Wiring**: `/history` exists but is not connected to any data source. It needs to read saved fortunes.
3.  **Localization**: `home_screen.dart` and `fortune_screen.dart` have hardcoded Korean strings (e.g., '안녕하세요 00님', '오늘의 운세'). These must be replaced with `Translations.t`.

## 4. Phase 4 Target Scope
- **Target Route**: `/fortune-today`
- **Target Flow**:
  1.  Home/Fortune -> Click Today's Fortune -> Navigate to `/fortune-today` (Actual Screen).
  2.  Show dummy or randomized fortune data.
  3.  Click "Save" button.
  4.  Data saved to `shared_preferences`.
  5.  Navigate to `/history`.
  6.  Show saved fortune item in History list.
