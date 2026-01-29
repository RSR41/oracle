# PROJECT_AUDIT_REPORT.md
## Oracle → EF (이프) Repository Analysis

**Analysis Date**: 2026-01-25  
**Analyst**: Google Anti-Gravity Agent

---

## 1. Repository Structure Overview

```
oracle/
├── apps/
│   ├── android/          # ✅ Main reference (Jetpack Compose)
│   └── ios/              # ⚠️ SwiftUI (separate branch, not current target)
├── backend/              # ❌ Empty (only .gitkeep)
├── pwa/                  # ⚠️ Partial (Next.js + Tailwind)
├── docs/                 # 📄 Existing documentation
└── tools/                # 🔧 Build/utility scripts
```

---

## 2. Android App Analysis

### 2.1 Configuration (from `apps/android/app/build.gradle.kts`)

| Setting | Value | Notes |
|---------|-------|-------|
| **namespace** | `com.rsr41.oracle` | Current package ID |
| **minSdk** | 26 | Android 8.0 (Oreo) |
| **targetSdk** | 36 | Latest Android |
| **compileSdk** | 36 | |
| **versionCode** | 1 | |
| **versionName** | 1.0 | |
| **Java** | 17 | |

> [!IMPORTANT]
> **Flutter Project Configuration**: Use `minSdk=26`, `targetSdk=36` to match.
> **Package ID Change**: Must change from `com.rsr41.oracle` to `com.rsr41.ef` per requirements.

### 2.2 Architecture & Dependencies

**Architecture**: MVVM + Repository Pattern + Hilt DI

**Key Dependencies** (from `build.gradle.kts` lines 52-110):
- Jetpack Compose + Material3
- Hilt (DI)
- Retrofit + OkHttp (Network)
- Room (Local DB)
- DataStore (Preferences)
- Coil (Image loading)
- ML Kit Face Detection
- WorkManager
- Timber (Logging)

### 2.3 Navigation Routes (from `OracleNavHost.kt`)

| Route | Screen | Status |
|-------|--------|--------|
| HOME | HomeScreen | ✅ Implemented |
| INPUT | InputScreen | ✅ Implemented |
| RESULT | ResultScreen | ✅ Implemented |
| HISTORY | HistoryScreen | ✅ Implemented |
| SETTINGS | SettingsScreen | ✅ Implemented |
| FORTUNE | FortuneScreen | ✅ Implemented |
| COMPATIBILITY | CompatibilityScreen | ✅ Implemented |
| FACE | FaceReadingScreen | ✅ Implemented |
| TAROT | TarotScreen | ✅ Implemented |
| DREAM | DreamScreen | ✅ Implemented |

### 2.4 Feature Analysis

#### Home Screen
- Today's Fortune card with "View Fortune" button
- Today's Lucky Look (color recommendation)
- Menu grid: Saju, Manseok, Compatibility, Face Reading, Tarot, Dream
- History and Settings icons in header

#### Profile Setup / Input Screen
- Birth date input (yyyy-MM-dd format)
- Birth time input (HH:mm) with "Unknown Time" checkbox
- Gender selection (Male/Female)
- Calendar Type (Solar/Lunar)
- "Save for later use" checkbox
- "View Result" button

#### Result Screen (Saju Result)
- Today's Fortune summary text
- Four Pillars display (년주/월주/일주/시주)
- Lucky Color (visual circle)
- Lucky Number
- Input Info section
- Retry and History buttons

#### Tarot Screen
- Card selection (pick 3 cards from 36-card deck)
- 12 cards per page (3 pages)
- Reversed card state support
- Selection counter

### 2.5 Data Layer

**Database Entities** (from `data/local/entity/`):
- `DreamInterpretationEntity.kt`
- `FaceAnalysisResultEntity.kt`
- `SajuContentEntity.kt`
- `TarotCardEntity.kt`

**Room Database**: `OracleDatabase.kt`

**Key DAOs**:
- `HistoryDao.kt`
- `FaceAnalysisDao.kt`

### 2.6 Domain Layer

**Engine Interfaces** (from `domain/engine/EngineInterfaces.kt`):
- `FortuneEngine` - Saju calculation interface
- `FaceAnalysisEngine` - Face reading interface

**Models** (from `domain/model/`):
- `BirthInfo`, `CalendarType`, `Gender`
- `HistoryItem`, `HistoryRecord`, `HistoryType`
- `SajuResult`, `TarotCard`
- `ThemeMode`, `AppLanguage`

### 2.7 Lunar Calendar Support

**File**: `util/LunarCalendarUtil.kt` (lines 1-55)

Uses Android ICU `ChineseCalendar` for:
- `solarToLunar()`: Gregorian → Lunar conversion
- `lunarToSolar()`: Lunar → Gregorian conversion
- Leap month support ✅

**Unit Test**: `LunarCalendarUtilTest.kt` exists

### 2.8 i18n Support

**String Resources**:
- `values/strings.xml` - Default (English) - 199 lines
- `values-en/strings.xml` - English
- `values-ko/strings.xml` - Korean

**Coverage**: All screens have localized strings.

---

## 3. PWA Analysis (from `pwa/`)

### 3.1 Technology Stack
- Next.js 14
- TypeScript
- Tailwind CSS
- React 18

### 3.2 Routes

| Route | File | Status |
|-------|------|--------|
| `/` | `app/page.tsx` | ✅ Landing page |
| `/profile` | `app/profile/` | ⚠️ Partial |
| `/tag/[token]` | `app/tag/[token]/page.tsx` | ✅ NFC entry point |

### 3.3 Tag Page Analysis (`tag/[token]/page.tsx`)

**Current Flow**:
1. Fetch tag info
2. Check if tag is active
3. Check for profile (redirect to `/profile` if needed)
4. Display fortune snapshot
5. CTA for "Full Result"

**Components Used**:
- LoadingSpinner
- ErrorMessage
- FortuneScore

---

## 4. Backend Analysis

**Status**: ❌ **EMPTY** (only `.gitkeep` file)

**Required Implementation**:
- Auth APIs (register/login/refresh/logout)
- Profile APIs
- Fortune Summary APIs
- Face Embedding APIs (dummy for MVP)
- Tag Management APIs (claim/transfer)

---

## 5. Saju/Fortune Calculation Analysis

### 5.1 Current Implementation

**Mock API** is used: `buildConfigField("boolean", "USE_MOCK_API", "true")` (line 27)

**Engine Interface exists** (`FortuneEngine`) but actual calculation is NOT implemented.

### 5.2 Recommendation

The Saju calculation should be implemented in:
1. **Flutter app (local)** - For offline capability
2. **Backend** - For PWA and cross-device consistency

**Rationale**: Lunar calendar utilities exist in Android using `ChineseCalendar`. Flutter should use a Dart lunar calendar package like `lunar` or port the existing logic.

---

## 6. UI Screenshots Analysis (from provided images)

### Screen 1: Home Screen
- App title "Oracle" with history/settings icons
- "Today's Fortune" hero card
- "Today's Lucky Look" with color circle
- 6-item menu grid

### Screen 2: Profile Setup
- Date of Birth input
- Time of Birth with "Unknown Time" option
- Gender radio buttons
- Calendar Type radio buttons
- Save checkbox
- "View Result" button

### Screen 3: Saju Result (Upper)
- Today's Fortune text
- Four Pillars in golden cards
- Korean/English pillar labels

### Screen 4: Saju Result (Lower)
- Lucky Color & Lucky Number cards
- Input Info summary
- Retry & History buttons

### Screen 5: Tarot Screen
- Instruction "Clear your mind and pick 3 cards"
- Progress dots
- Page selector (1, 2, 3)
- 12-card grid
- Selected card shown flipped with "Reversed" label
- "View Result" button

---

## 7. Key Findings & Recommendations

### 7.1 What to Reuse

| Component | Android | Flutter Recommendation |
|-----------|---------|----------------------|
| Lunar Calendar | `LunarCalendarUtil.kt` | Use `lunar` package or port logic |
| Tarot Cards | 36-card model with Major Arcana | Migrate card definitions |
| i18n Strings | 199 strings | Use `intl` package with ARB files |
| Theme | Light/Dark/System | Material 3 with dynamic theming |

### 7.2 Architecture Recommendation for Flutter

```
lib/
├── core/
│   ├── constants/
│   ├── utils/           # LunarCalendarUtil, ValidationUtil
│   └── theme/
├── features/
│   ├── auth/
│   ├── home/
│   ├── fortune/         # Saju, Manseok
│   ├── compatibility/
│   ├── face/
│   ├── tarot/
│   ├── dream/
│   ├── history/
│   └── settings/
├── shared/
│   ├── data/            # API, Local DB
│   ├── domain/          # Models, Repositories
│   └── widgets/
└── main.dart
```

**State Management**: Riverpod (recommended) or Bloc  
**Navigation**: go_router  
**DI**: Riverpod or get_it

### 7.3 Missing from Requirements

| Feature | Status | Action |
|---------|--------|--------|
| Save/Share Results | ❌ Not seen in code | Must implement |
| Push Notifications | ❌ MVP excluded | Document only |
| Premium/Subscription | Must remove UI | Disable any premium toggles |
| Face AI | UI exists | Replace with dummy |
| Tag Transfer | Not implemented | Must implement |

---

## 8. Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Android runtime errors | Blocks reference | Analyze crash logs, minimal fix |
| No backend | Blocks PWA | Implement minimal API |
| Saju calculation complexity | Delays MVP | Use mock/simple algorithm first |
| Face AI cost | Budget risk | Use dummy results for MVP |

---

## 9. Next Steps

1. **Create implementation plan** for Flutter app
2. **Analyze crash logs** for Android stabilization
3. **Design backend API schema**
4. **Create NFC URL strategy document**
5. **Create tag operations document**

---

## Appendix: File References

### Android Configuration
- `apps/android/app/build.gradle.kts` (lines 10-17): SDK versions
- `apps/android/app/build.gradle.kts` (lines 24-27): Build config fields

### Navigation
- `apps/android/app/src/main/java/com/rsr41/oracle/ui/navigation/OracleNavHost.kt` (lines 24-35): Route definitions

### Engine Interfaces
- `apps/android/app/src/main/java/com/rsr41/oracle/domain/engine/EngineInterfaces.kt` (lines 10-22): FortuneEngine

### Lunar Calendar
- `apps/android/app/src/main/java/com/rsr41/oracle/util/LunarCalendarUtil.kt` (lines 19-53): Conversion functions

### i18n
- `apps/android/app/src/main/res/values/strings.xml` (199 lines)
- `apps/android/app/src/main/res/values-ko/strings.xml`
- `apps/android/app/src/main/res/values-en/strings.xml`
