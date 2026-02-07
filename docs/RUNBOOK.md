# Runbook: Windows Build & Validation

이 문서는 Windows 환경에서 Oracle Flutter 프로젝트를 빌드, 실행 및 검증하기 위한 절차를 설명합니다.

---

## 1. 기본 실행 환경 설정
```powershell
# 프로젝트 디렉토리 이동
cd apps/flutter/oracle_flutter

# 클린 및 의존성 설치
flutter clean
flutter pub get

# 정적 분석 (필수 점검)
flutter analyze
```

## 2. 모드별 실행 명령어
### 2.1 개발(Debug) 모드
- **베타 기능 ON (Default)**: `flutter run`
- **베타 기능 OFF (전치 차단 테스트)**: `flutter run --dart-define=BETA_FEATURES=false`

### 2.2 릴리즈(Release) 모드
- **MVP 기본값 (베타 OFF)**: `flutter run --release`
- **베타 강제 ON (디버깅용)**: `flutter run --release --dart-define=BETA_FEATURES=true`

## 3. 기능 토글(FeatureFlags) 검증 시나리오
`FeatureFlags.showBetaFeatures` 연동 상태를 확인하기 위한 체크리스트입니다.

1. **상태 확인 명령**: `flutter run --dart-define=BETA_FEATURES=false`
2. **Fortune 탭**: 타로, 꿈해몽 카테고리 칩 및 섹션 카드가 보이지 않아야 함.
3. **Bottom Nav**: 'Meeting', 'Compat' 탭이 숨겨져야 함.
4. **Router 리다이렉션**: 브라우저 주소창이나 코드를 통해 `/meeting` 접근 시 `/home`으로 튕겨나가는지 확인.

## 4. 자주 터지는 오류 Top 5 (Troubleshooting)

| 오류 종류 | 증상 | 해결 방법 |
| :--- | :--- | :--- |
| **Gradle 버전 오류** | 빌드 시 Gradle 관련 에러 | `android/build.gradle`의 classpath 버전 확인 및 `flutter clean` 수행 |
| **라우팅 리다이렉션 무한루프** | 화면이 계속 깜빡임 | `app_router.dart`의 `redirect` 로직에서 `/home`이 다시 `/home`으로 리다이렉트되지 않는지 확인 |
| **i18n 누락** | `t('key')`가 그대로 출력됨 | `assets/i18n/*.json` 파일에 해당 키가 정의되었는지 확인 및 빌드 재시작 |
| **SQLite 잠김** | DB 접근 시 locked 에러 | 에뮬레이터를 재시작하거나 `adb shell rm`으로 이전 DB 파일 삭제 |
| **환경변수 미인식** | `--dart-define`이 작동 안 함 | `const String.fromEnvironment`가 컴파일 타임에 결정되므로 앱을 완전히 껐다가 다시 실행 |
