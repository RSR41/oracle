# Phase 4 Implementation Plan: Feature Wiring & Storage

## 1. Goal
Replace the "Coming Soon" placeholder for **Today's Fortune** with a fully functional screen, implement data persistence using `shared_preferences`, and verify the flow from **Fortune -> Save -> History**.

## 2. Prerequisites
- [ ] Add `shared_preferences` dependency to `pubspec.yaml`.
- [ ] Create `lib/app/services` directory for data logic.

## 3. Implementation Steps

### Step 1: Storage & Service Layer
- **File**: `lib/app/services/fortune_service.dart` (NEW)
- **Responsibility**:
  - Save fortune result (id, date, content, score) to `shared_preferences`.
  - Load list of saved fortunes.
  - Clear history.
- **Data Model**: Create simple `FortuneResult` model in `lib/app/models/fortune_result.dart`.

### Step 2: Fortune Today Screen (Feature)
- **File**: `lib/app/screens/fortune/fortune_today_screen.dart` (NEW)
- **UI References**: React Mockup `FortuneToday.tsx`.
- **Features**:
  - Show static/dummy fortune result (consistent with Home summary).
  - "Save" button connected to `FortuneService.save()`.
  - "Confirm" button to go back.
- **Route**: Update `app_router.dart` to point `/fortune-today` to this new screen.

### Step 3: History Screen (Consumer)
- **File**: `lib/app/screens/tabs/history_screen.dart` (MODIFY)
- **Features**:
  - Convert to `StatefulWidget` (or use `FutureBuilder`).
  - Load data from `FortuneService.getAll()`.
  - Display list of saved fortunes.
  - (Optional) Tap to view detail.

### Step 4: Localization (i18n)
- **Targets**: `home_screen.dart`, `fortune_screen.dart`, `fortune_today_screen.dart`.
- **Action**: Replace hardcoded strings with `Translations.t(context, key)`.

## 4. Verification Flow
1.  Launch App (`flutter run -d windows`).
2.  Go to **Fortune** tab.
3.  Click "Today's Fortune" card -> Navigate to **FortuneTodayScreen**.
4.  Click "Save" button.
5.  Navigate to **History** tab.
6.  Verify the saved item appears in the list.
7.  Verify data persists after app restart.
