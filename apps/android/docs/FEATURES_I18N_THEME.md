# i18n 및 테마 시스템

## 1. 다국어 지원 (i18n)

이 앱은 한국어(ko)와 영어(en)를 지원합니다.

### 주요 기능
- **언어 설정**: 설정 화면에서 한국어, 영어, 시스템 기본값을 선택할 수 있습니다.
- **리소스 분리**:
  - `values/strings.xml`: 한국어 리소스 (기본값)
  - `values-en/strings.xml`: 영어 리소스
- **적용 방식**: `MainActivity`에서 `AppLanguage` 설정을 로드하여 `LocaleListCompat`을 통해 앱 전체의 로케일을 동적으로 변경합니다.

### 코드 구조
- `AppLanguage.kt`: 지원 언어 Enum (KOREAN, ENGLISH, SYSTEM)
- `PreferencesManager.kt`: 언어 설정 저장 및 로드
- `SettingsViewModel.kt`: UI 상태 관리 및 언어 변경 로직

---

## 2. 테마 시스템

라이트 모드, 다크 모드, 시스템 설정을 완벽하게 지원하는 동적 테마 시스템을 갖추고 있습니다.

### 주요 기능
- **시스템 연동**: 안드로이드 시스템의 다크 모드 설정에 자동으로 반응합니다.
- **수동 설정**: 설정 화면에서 '밝게', '어둡게', '시스템 설정' 중 선택 가능합니다.
- **MD3 디자인**: Material Design 3의 색상 시스템을 준수하여 다크 모드에서도 최적의 시인성을 제공합니다.

### 코드 구조
- `ThemeMode.kt`: 테마 모드 Enum (LIGHT, DARK, SYSTEM)
- `Theme.kt`: `OracleTheme` 컴포저블에서 `ThemeMode`에 따라 `darkTheme` 파라미터를 동적으로 제어합니다.
- `MainActivity.kt`: 앱 시작 시 저장된 테마 설정을 로드하여 적용합니다.
