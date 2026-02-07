# Screens Porting Plan (Phase 66)

| # | Screen (React) | Flutter Path | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| 0 | `Home.tsx` | `lib/app/screens/tabs/home_screen.dart` | ✅ Done | Basis for styles/animations. |
| 1 | `Fortune.tsx` | `lib/app/screens/tabs/fortune_screen.dart` | ⏳ In-Progress | Next target. |
| 2 | `Compatibility.tsx` | `lib/app/screens/tabs/compatibility_screen.dart` | 📅 Planned | |
| 3 | `History.tsx` | `lib/app/screens/tabs/history_screen.dart` | 📅 Planned | Expected detail bugs. |
| 4 | `Profile.tsx` | `lib/app/screens/tabs/profile_screen.dart` | 📅 Planned | |
| 5 | `Onboarding.tsx` | `lib/app/screens/onboarding/onboarding_screen.dart` | 📅 Planned | |
| 6 | `FaceReading.tsx` | `lib/app/screens/stack/face_screen.dart` | 📅 Planned | |
| 7 | `Tarot.tsx` | `lib/app/screens/stack/tarot_screen.dart` | 📅 Planned | |
| 8 | `Dream.tsx` | `lib/app/screens/stack/dream_screen.dart` | 📅 Planned | |
| 9 | `Connection.tsx` | `lib/app/screens/stack/connection_screen.dart` | 📅 Planned | |
| 10 | `IdealType.tsx` | `lib/app/screens/stack/ideal_type_screen.dart` | 📅 Planned | |
| 11 | `Chat.tsx` | `lib/app/screens/stack/chat_screen.dart` | 📅 Planned | |
| 12 | `Settings.tsx` | `lib/app/screens/tabs/settings_screen.dart` | 📅 Planned | Tab or Stack? React has it separate. |

## Standards
- **Styling**: Use HSL/Hex from React exactly or use Phase 33 Theme tokens.
- **I18n**: No hardcoded Korean in widgets.
- **Navigation**: Use `navState.navigate('screenName')`.
