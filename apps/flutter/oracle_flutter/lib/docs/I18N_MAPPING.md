# I18N and State Mapping: React → Flutter

**Source**: `oracle/figma_tools/figma_1/src/app/contexts/AppContext.tsx`
**Targets**:
- `lib/app/i18n/translations.dart` (Data)
- `lib/app/state/app_state.dart` (Logic)

---

## 1. Translations Data

React `const translations` object was extracted 1:1.

| Language | Keys Count | Flutter Implementation |
|----------|------------|------------------------|
| **KO** | 95 | `Translations.data[AppLanguage.ko]` |
| **EN** | 95 | `Translations.data[AppLanguage.en]` |

> **Note**: Key counts verified by extraction script.

### Fallback Logic
**React**: `translations[language][key] || key`
**Flutter**:
```dart
  static String t(AppLanguage language, String key) {
    final map = data[language];
    if (map == null) return key;
    return map[key] ?? key;
  }
```

---

## 2. State Management

| React Context | Flutter AppState | Initial Value |
|---------------|------------------|---------------|
| `language` | `AppLanguage language` | `ko` |
| `theme` | `AppThemePreference theme` | `system` |
| `setLanguage` | `void setLanguage(AppLanguage)` | - |
| `setTheme` | `void setTheme(AppThemePreference)` | - |

### Theme System Mapping

| React Value (`theme`) | Meaning | Flutter `AppThemePreference` | Flutter `ThemeMode` |
|-----------------------|---------|------------------------------|---------------------|
| `'light'` | Force Light | `AppThemePreference.light` | `ThemeMode.light` |
| `'dark'` | Force Dark | `AppThemePreference.dark` | `ThemeMode.dark` |
| `'system'` | Follow OS | `AppThemePreference.system` | `ThemeMode.system` |

---

## 3. Verification

### Checklist
- [x] **Extraction**: 95 keys extracted for both languages.
- [x] **Logic**: `t(key)` fallback matches React behavior.
- [x] **Theme**: `system` mode correctly maps to `ThemeMode.system`.
- [x] **UI**: `ThemeTestScreen` allows toggling Language and Theme with immediate updates.
