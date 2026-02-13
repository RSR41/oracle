# Oracle 사주 - STORE_RELEASE / PHASE2_PREVIEW 제출 Runbook

본 문서는 `FeatureFlags`(`lib/app/config/feature_flags.dart`)를 기준으로,
스토어 제출 프로파일을 고정하고 제출 항목을 분기하기 위한 운영 문서입니다.

---

## 1) 제출 프로파일 정의 (고정값)

### A. STORE_RELEASE (기본 권고 / Phase 1 고정 제출)
- `BETA_FEATURES=false`
- `AI_ONLINE=false`
- 목적: 심사 안정성 최우선(필수 MVP 기능만 노출)

### B. PHASE2_PREVIEW (가칭, 조건부)
- `BETA_FEATURES=true`
- `AI_ONLINE=false` (고정)
- 목적: 심사/사업 일정상 필요한 일부 Phase 2 기능만 제한 노출
- 주의: `BETA_FEATURES=true` 자체는 Phase 2 전체 노출 가능성이 있으므로,
  실제 제출 빌드에서는 라우팅/메뉴/원격설정 등으로 "허용 기능"만 선별 공개해야 함

> 기본 정책: **Phase 1(STORE_RELEASE) 고정 제출을 기본값으로 유지**하고,
> Phase 2 기능은 **후속 업데이트로 분리**합니다.
### 1-3. 사전 검증
`verify_store_ready.ps1`와 `release_preflight.sh`를 실행하여 준비 상태를 확인합니다.
```powershell
cd ../../.. # repo root
.\tools\verify_store_ready.ps1
bash ./tools/release_preflight.sh
```
> **PASS**가 나와야 진행 가능합니다. (Android keystore 경로, iOS Signing 정책, placeholder 등 확인)

---

## 2) 프로파일별 빌드 커맨드

### 2-1. STORE_RELEASE
```powershell
cd apps/flutter/oracle_flutter
keytool -genkey -v -keystore oracle-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias oracle
```
- 비밀번호 설정 및 정보 입력

### 2-2. key.properties 설정
`android/key.properties` 파일을 열어 실제 비밀번호를 입력합니다.
```properties
storePassword=설정한_비밀번호
keyPassword=설정한_비밀번호
keyAlias=oracle
storeFile=../oracle-release.jks
```
> 주의: 이 파일은 절대 커밋하지 마세요 (.gitignore 확인됨).


### 2-3. iOS Signing 정책 확인
- `docs/IOS_SIGNING.md` 기준과 `ios/Runner.xcodeproj/project.pbxproj`의 설정이 일치해야 합니다.
- Team은 `ORACLE_IOS_TEAM_ID`로 주입하며 Signing은 Automatic 정책을 사용합니다.

---

## 3. STORE_RELEASE 빌드

flutter build appbundle --release `
  --dart-define=BETA_FEATURES=false `
  --dart-define=AI_ONLINE=false `
  --dart-define=TERMS_URL=https://<YOUR_GITHUB_ID>.github.io/oracle/legal/terms_of_service `
  --dart-define=PRIVACY_URL=https://<YOUR_GITHUB_ID>.github.io/oracle/legal/privacy_policy
```

### 2-2. PHASE2_PREVIEW(가칭)
```powershell
cd apps/flutter/oracle_flutter

flutter build appbundle --release `
  --dart-define=BETA_FEATURES=true `
  --dart-define=AI_ONLINE=false `
  --dart-define=TERMS_URL=https://oracle-saju.github.io/oracle/legal/terms_of_service `
  --dart-define=PRIVACY_URL=https://oracle-saju.github.io/oracle/legal/privacy_policy
```
> `oracle-saju`를 실제 GitHub 아이디로 교체하세요.

---

## 3) 제출 영향도 매트릭스 (스토어 제출 항목 분기)

> 기준
> - 데이터 수집 항목: 사용자 입력/기기 데이터/서버 전송 여부
> - 권한: 기능 정상 동작을 위한 런타임 권한 필요 여부
> - 개인정보 문구: 개인정보처리방침/스토어 Data Safety 문구 변경 필요성
> - 심사 리스크: 기능 복잡도, 민감도, 심사 재현 난이도를 종합한 운영 지표

| 기능 | 데이터 수집 항목 | 권한 필요 여부(iOS/Android) | 개인정보 문구 변경 필요성 | 심사 리스크 |
|---|---|---|---|---|
| 사주 입력/결과 (Phase 1) | 생년월일/시간/성별 등 사용자 입력(로컬 처리 기준) | 없음(기본) | 기존 문구 유지 가능(입력 데이터 처리 목적 명시 유지) | 저 |
| 만세력/캘린더 (Phase 1) | 달력 조회 입력(로컬 계산 중심) | 없음(기본) | 기존 문구 유지 가능 | 저 |
| 타로/타로결과 (Phase 1) | 질문/선택 카드 데이터(로컬 또는 API 연동 범위 명시 필요) | 없음(기본) | API 전송 시 목적/보관기간 문구 점검 필요 | 저~중 |
| 히스토리/설정 (Phase 1) | 이용기록(로컬 저장), 약관/정책 URL 접속 로그(외부 브라우저) | 없음(기본) | 보관 정책(로컬/삭제 방법) 문구 권장 | 저 |
| 꿈해몽 (Phase 2) | 자유서술 텍스트(민감정보 포함 가능성) | 없음(기본) | 민감정보 입력 가능성 안내 및 수집/전송 범위 문구 강화 필요 | 중 |
| 관상 얼굴분석 (Phase 2) | 얼굴 이미지/생체 유사정보(민감도 높음) | 카메라/사진 접근 권한 필요 가능 | 생체/이미지 데이터 처리 문구 필수 보강 | 고 |
| 소개팅/궁합 (Phase 2) | 상대 정보·프로필 입력(제3자 데이터 포함 가능) | 없음~연락처/갤러리(구현에 따라) | 제3자 정보 입력 책임/처리 목적 문구 보강 필요 | 중~고 |
| 이상형 이미지 생성 (Phase 2) | 프롬프트 텍스트, 생성 이미지, 모델 처리 로그 | 사진 저장 권한(플랫폼 정책에 따라) 가능 | 생성형 AI/이미지 처리 고지 문구 필수 보강 | 고 |
| 신년운세/전문상담 (Phase 2) | 상담성 텍스트/개인 성향 정보 | 없음(기본) | 상담 데이터 처리/보관/삭제 안내 문구 강화 필요 | 중 |

### 제출 분기 권고
- **STORE_RELEASE:** 표에서 `Phase 1` 기능만 제출 대상으로 포함
- **PHASE2_PREVIEW:** `중~고 리스크` 기능은 원칙적 제외, 일정상 필요한 기능만 선별 포함

---

## 4) 의사결정 규칙 (심사 지연 대응)

### 4-1. 기본 원칙
1. 기본 권고는 **Phase 1 고정 제출(STORE_RELEASE)** 입니다.
2. Phase 2는 **후속 업데이트 분리**를 기본으로 합니다.
3. 심사 안정성(재현성/정책합치)이 일정 우선순위보다 항상 상위입니다.

### 4-2. "심사 지연 시 Phase 2 일부 포함" 조건
아래 조건을 **모두** 만족할 때만 PHASE2_PREVIEW 채택 가능:
- (C1) `AI_ONLINE=false` 유지 (고정)
- (C2) 포함 대상 기능의 심사 리스크가 `중` 이하이며, QA 시나리오 재현 가능
- (C3) 해당 기능의 개인정보 문구/스토어 Data Safety 항목이 반영 완료
- (C4) 권한 팝업 사유/거부 시 동작(Graceful Degradation) 확인 완료
- (C5) 릴리즈 책임자 승인(개발 + 정책/운영 2자 승인)

### 4-3. 제외(금지) 조건
아래 중 하나라도 해당하면 Phase 2 제출 포함 금지:
- (E1) 카메라/얼굴 이미지 등 생체 유사정보 처리 문구 미정
- (E2) 제3자 정보(상대 프로필 등) 처리 고지 미완료
- (E3) 권한 거부 시 크래시/핵심 플로우 차단 발생
- (E4) 심사 계정에서 재현 불가(서버 플래그 의존, 문서화 미비)
- (E5) 리뷰 코멘트 대응 자료(테스트 계정, 시나리오, 영상/캡처) 부재

---

## 5) 최종 점검 체크리스트

### 5-1. 공통 점검
- [ ] `FeatureFlags.buildModeName`가 의도한 제출 프로파일로 표시됨
- [ ] `TERMS_URL`, `PRIVACY_URL` 실제 접근 가능(404 없음)
- [ ] 앱 크래시/무한로딩 없음
- [ ] 스토어 설명/개인정보 문구가 빌드 기능 세트와 일치

### 5-2. STORE_RELEASE 추가 점검
- [ ] 베타/Phase 2 메뉴가 노출되지 않음
- [ ] AI 관련 진입점/문구가 노출되지 않음

### 5-3. PHASE2_PREVIEW 추가 점검
- [ ] 허용한 기능만 노출(화이트리스트 검증)
- [ ] 제외 기능 진입 경로 완전 차단(딥링크 포함)
- [ ] 권한 거부 시 대체 UX 제공

---

## 6) 문제 해결

### 문법/정적 분석 에러
```powershell
flutter analyze
```

### 스토어 심사 반려(개인정보)
- Data Safety 입력값과 실제 기능 노출 세트를 재대조
- 정책 문구(수집 목적/보관/삭제/제3자 제공)를 기능별로 재작성

### 법적 페이지 404
- GitHub Pages 배포 설정(Source: main, Folder: /docs) 확인
- URL 오타 및 배포 완료 상태 확인
