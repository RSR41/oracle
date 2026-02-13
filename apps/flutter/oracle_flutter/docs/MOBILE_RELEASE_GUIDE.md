# MOBILE RELEASE GUIDE

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
