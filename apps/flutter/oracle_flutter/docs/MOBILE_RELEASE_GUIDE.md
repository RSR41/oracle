# MOBILE RELEASE GUIDE

모바일 릴리즈 준비 시 아래 문서부터 확인하세요.

## 진입 문서
- [스토어 제출 체크리스트](./STORE_SUBMISSION_CHECKLIST.md)

## 권장 진행 순서
1. 체크리스트 각 항목 사전 점검
2. iOS/Android 스토어 콘솔 메타데이터 입력
3. 테스트 트랙/테스트플라이트 검증 후 제출
## 제출 프로파일(Submission Profile)

모바일 스토어 심사/배포 시 아래 프로파일을 기준으로 기능 공개 범위를 관리합니다.

### 1) `STORE_RELEASE` (권장 기본)
- `BETA_FEATURES=false`
- `AI_ONLINE=false`
- 공개 범위: **Phase 1 핵심 기능만 노출**
- 용도: 스토어 심사 제출, 정책 리스크 최소화

### 2) `STORE_PLUS`
- `BETA_FEATURES=true`
- `AI_ONLINE=false`
- 공개 범위: **Phase 2 중 권한/정책 리스크가 낮은 기능만 선택 공개**
  - 예시: local-only 성격의 소개팅(`/meeting`), 궁합(`/compatibility`)
- 용도: 점진적 공개(soft launch), 심사 안정성 유지

### 3) `FULL_DEV`
- `BETA_FEATURES=true`
- `AI_ONLINE=true`
- 공개 범위: Phase 2 확장/민감 기능 포함 전체
- 용도: 내부 개발/QA 전용 (스토어 제출 비권장)

## 라우터 공개 정책 연동

`lib/app/navigation/app_router.dart`는 프로파일 기반으로 다음과 같이 라우팅 접근을 제어합니다.

- `allowPhase2LowRisk`:
  - `STORE_PLUS`, `FULL_DEV`에서만 허용
  - `/meeting`, `/compatibility` 등 저위험 기능
- `allowPhase2Sensitive`:
  - `FULL_DEV`에서만 허용
  - `/dream`, `/face`, `/ideal-type`, `/consultation`, `/yearly-fortune`

## 심사용 진단 로그

앱 시작 시 `FeatureFlags.printSubmissionDiagnostics()`가 1회 실행되어 현재 제출 프로파일과 활성 기능 목록을 로그로 출력합니다.

예시 출력:

```txt
[ReleaseProfile] profile=STORE_PLUS (SUBMISSION_PROFILE=STORE_PLUS, BETA_FEATURES=true, AI_ONLINE=false)
[ReleaseProfile] enabled=PHASE1_CORE, PHASE2_LOW_RISK(meeting,compatibility)
```

이 로그를 통해 심사 제출 빌드에서 의도치 않은 기능 활성화를 빠르게 점검할 수 있습니다.
# ORACLE 모바일 배포 가이드 (iOS / Android)

`Oracle app final summary statement`의 Phase 1 목표(빠른 스토어 출시)에 맞춘 최소 릴리즈 가이드입니다.

## 1) 공통 사전 점검

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

- `pubspec.yaml` 버전(`version`) 증가
- 앱 아이콘/스플래시 최신화 (`flutter_launcher_icons`, `flutter_native_splash`)
- 개인정보/약관 URL, 문의 메일 점검

## 2) Android 빠른 배포

### 준비물
- `android/key.properties` 생성 (예시는 `android/key.properties.example` 참고)
- 업로드 키스토어 파일 준비

### 빌드
```bash
flutter build appbundle --release
```

### 업로드
- Google Play Console > 내부 테스트 트랙 먼저 업로드
- 크래시/ANR/로그인/결제 등 핵심 플로우 수동 점검
- 이상 없으면 운영 트랙 승격

## 3) iOS 빠른 배포

### 준비물
- Apple Developer의 App ID/Provisioning Profile/Certificate
- Xcode에서 Team, Bundle Identifier(`com.destiny.oracle`) 확인

### 빌드
```bash
flutter build ipa --release
```

### 업로드
- Xcode Organizer 또는 Transporter로 TestFlight 업로드
- 최소 1회 내부 테스터 검증 후 App Store 제출

## 4) 권장 배포 순서 (실수 방지)
1. Android 내부 테스트
2. iOS TestFlight 내부 테스트
3. 치명 버그(크래시, 네비게이션, 저장 기능) 수정
4. Android/iOS 동시 심사 제출

## 5) 릴리즈 체크 자동화
아래 스크립트는 키 파일/설정 파일 유무를 빠르게 확인합니다.

```bash
bash tools/release_preflight.sh
```

> 주의: 이 스크립트는 설정 누락을 빠르게 찾기 위한 용도이며, 실제 빌드/서명 성공을 100% 보장하지는 않습니다.
