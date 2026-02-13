# 스토어 제출 체크리스트

모바일 스토어(iOS/Android) 제출 직전에 공통 점검 항목을 빠르게 확인하기 위한 체크리스트입니다.

## 공통
- [ ] 버전/빌드번호 확인
- [ ] 번들 ID(`Bundle ID`)·`applicationId` 확인
- [ ] 서명(배포 인증서/키스토어) 설정 확인
- [ ] 릴리즈 노트 준비
- [ ] 문의처(이메일/웹사이트) 기재
- [ ] 정책 URL(HTTPS) 연결 확인

## iOS
- [ ] Signing / Provisioning 설정 확인
- [ ] Privacy Nutrition Label 작성/검증
- [ ] ATT(App Tracking Transparency) 필요 여부 검토
- [ ] 심사 노트(App Review Notes) 작성

## Android
- [ ] Play App Signing 설정 확인
- [ ] Data Safety 섹션 작성/검증
- [ ] 콘텐츠 등급 설문 완료
- [ ] 광고/인앱결제(IAP) 선언 상태 확인
- [ ] 테스트 트랙(Internal/Closed) 배포 및 검증 완료

## 메타데이터
- [ ] 앱 설명(국문/영문) 준비
- [ ] 키워드 최적화
- [ ] 카테고리 선택 확인
- [ ] 스크린샷(디바이스별) 준비
- [ ] 연령등급 정보 확인

## 정책
- [ ] IAP 미사용/광고 미사용 시, 스토어 콘솔 선언과 실제 앱 동작이 일치하는지 확인
# Store Submission Checklist

오라클 Flutter 앱의 앱스토어(Apple App Store / Google Play) 제출 전 필수 확인 체크리스트입니다.

> [!IMPORTANT]
> 본 문서는 **출시 직전 검증용**입니다. 각 항목 체크가 완료되지 않으면 제출하지 않습니다.

## 1) 서명/식별자 (Signing & Identifiers)

### Android
- [ ] 릴리즈 keystore 위치/백업/접근권한이 팀 내에서 관리되고 있다.
- [ ] `applicationId`가 의도한 프로덕션 식별자와 일치한다.
  - [ ] `applicationId`가 과거 배포 이력(내부 테스트 포함)과 충돌하지 않는다.
- [ ] Android App Bundle(`.aab`) 빌드가 성공한다.
- [ ] Google Play Console에 업로드된 AAB가 오류 없이 처리된다.
  - [ ] 서명 인증서 지문(SHA-1/SHA-256) 필요 연동(예: Firebase/OAuth)과 일치한다.

### iOS
- [ ] Apple Developer Team이 올바르게 선택되어 있다.
- [ ] Provisioning Profile(배포용)이 유효하고 만료일을 확인했다.
- [ ] Bundle ID가 Apple App ID 및 프로젝트 설정과 정확히 일치한다.
- [ ] Archive/Export가 성공한다.
- [ ] TestFlight 빌드 업로드 후 처리 완료(Processing Complete) 상태를 확인했다.
- [ ] TestFlight에서 설치/실행/핵심 플로우 smoke test를 완료했다.

## 2) 스토어 메타데이터

- [ ] 앱명(App Name)
  - [ ] Google Play / App Store 표기명이 정책 위반(상표, 과장표현) 없이 일치한다.
- [ ] 부제(Subtitle, iOS) / 짧은 설명(Short Description, Android)
  - [ ] 핵심 가치가 1~2문장으로 명확히 전달된다.
- [ ] 상세 설명(한/영)
  - [ ] 한국어 상세 설명이 최신 기능/정책과 일치한다.
  - [ ] 영어 상세 설명이 한국어 버전과 의미상 동등하다.
- [ ] 키워드(iOS) / 검색 최적화 문구(Android)
  - [ ] 브랜드 오남용, 경쟁 앱명 도용 없이 작성했다.
- [ ] 카테고리
  - [ ] 실제 앱 기능에 부합하는 1차/2차 카테고리를 선택했다.
- [ ] 연령 등급
  - [ ] 설문 응답이 실제 콘텐츠와 일치한다.
- [ ] 스크린샷
  - [ ] 기기별 규격(해상도/비율/개수)을 충족한다.
  - [ ] 최신 UI 기준 화면이며 실제 기능을 반영한다.
- [ ] 문의처(Contact)
  - [ ] 지원 이메일/웹사이트/개인정보처리방침 URL이 유효하다.

## 3) 정책(Policy)

### 광고 / IAP 포함 여부
- [ ] 광고 포함 여부: **현재 없음 (No Ads)** 으로 명시했다.
- [ ] 인앱결제(IAP) 포함 여부: **현재 없음 (No In-App Purchases)** 으로 명시했다.

### 개인정보/데이터 안전성 설문 1:1 매핑
스토어 설문(Play Data Safety, App Store Privacy Nutrition Label)과 내부 문서를 **항목 단위로 1:1 매핑**합니다.

| 스토어 설문 항목 | 앱 실제 동작/정책 | 내부 근거 문서/담당자 | 검증 상태 |
|---|---|---|---|
| 수집 항목(What data is collected) | [ ] 수집 없음 / [ ] 수집 있음(세부 명시) | [ ] Privacy 문서 링크 | [ ] 완료 |
| 보관 기간(Retention) | [ ] 즉시 파기 / [ ] 기간 보관(기간 명시) | [ ] 데이터 보관 정책 | [ ] 완료 |
| 제3자 제공(Sharing) | [ ] 제공 없음 / [ ] 제공 있음(대상·목적 명시) | [ ] DPA/외부 연동 목록 | [ ] 완료 |
| 추적 여부(Tracking) | [ ] 추적 없음 / [ ] 추적 있음(목적·옵트인 명시) | [ ] SDK 목록·동의 플로우 | [ ] 완료 |

추가 점검:
- [ ] 스토어 설문 답변이 개인정보처리방침 문구와 완전히 일치한다.
- [ ] 앱 내 권한 요청 문구(카메라/사진 등)가 실제 사용 목적과 일치한다.

## 4) 제출 전 최종 게이트 (Go / No-go)

> [!CAUTION]
> 아래 체크박스가 **모두 완료(✅)** 되기 전에는 제출 버튼을 누르지 않습니다.

### Go / No-go Decision
- [ ] 섹션 1(서명/식별자) 전체 완료
- [ ] 섹션 2(메타데이터) 전체 완료
- [ ] 섹션 3(정책) 전체 완료
- [ ] 실제 디바이스 최종 smoke test(Android/iOS) 완료
- [ ] 릴리즈 노트/버전 코드(빌드 번호) 최종 확인 완료

**결정**
- [ ] **GO**: 전 항목 완료, 제출 진행
- [ ] **NO-GO**: 미완료 항목 존재, 제출 보류

---

## 제출 이력(옵션)
- 버전:
- 빌드 번호:
- 제출 일시:
- 담당자:
- 비고:
## 1. 공통

- [ ] 앱 버전(`versionName`/`CFBundleShortVersionString`)과 빌드번호(`versionCode`/`CFBundleVersion`)가 릴리즈 대상과 일치한다.
- [ ] 릴리즈 노트(What’s New/Release Notes)가 최신 변경사항 기준으로 작성되었다.
- [ ] 지원 연락처(이메일/웹사이트)가 스토어 메타데이터와 앱 내 정보에서 일치한다.
- [ ] 개인정보처리방침/이용약관 URL이 `https://`로 접근 가능하며 공개 상태다.
- [ ] 법적 문서(개인정보처리방침/이용약관) 최신 개정 일자가 반영되어 있다.
- [ ] 앱 내 노출 방식(외부 URL 또는 인앱 문서)과 스토어 제출 정보가 서로 일치한다.

## 2. Android (Play Console)

- [ ] 업로드 키/앱 서명이 정상 구성되어 있으며 Play App Signing 상태를 확인했다.
- [ ] `applicationId`가 운영 패키지명과 정확히 일치한다.
- [ ] Data safety 설문 항목(수집/공유 데이터, 처리 목적, 보안 조치)을 최신 기능 기준으로 갱신했다.
- [ ] 광고 포함 여부(Ads declaration)를 실제 앱 동작과 동일하게 설정했다.
- [ ] 인앱결제(IAP)/구독 사용 여부 및 상품 상태를 확인했다.
- [ ] 대상 연령(Target audience) 및 콘텐츠 등급(Content rating) 설문을 완료했다.
- [ ] 테스트 트랙(Internal/Closed/Open) 배포 후 크래시 지표를 점검했다.
- [ ] 테스트 트랙 배포 후 ANR 지표를 점검했다.
- [ ] 테스트 트랙에서 핵심 플로우(로그인, 결제, 주요 기능 진입/이탈)를 검증했다.

## 3. iOS (App Store Connect)

- [ ] Apple Developer Team, Signing 설정, Bundle ID가 릴리즈 대상과 일치한다.
- [ ] TestFlight 빌드를 설치하여 핵심 시나리오를 검증했다.
- [ ] Privacy Nutrition Label을 실제 데이터 처리 방식 기준으로 최신화했다.
- [ ] ATT(App Tracking Transparency) 적용 대상인 경우 권한 문구/동작을 점검했다.
- [ ] 앱 심사 노트(App Review Notes)에 테스트 계정/재현 경로/주의사항을 기입했다.
- [ ] 스크린샷(디바이스별), 설명(Description), 키워드(Keywords), 카테고리를 최종 점검했다.

## 4. Phase 정책

### 제출 항목 구분표 (Phase 1 vs Phase 2)

| 항목 | Phase 1 (빠른 심사) | Phase 2 (기능 확대) | 현재값 | 목표값 | 담당자 | 완료일 |
| --- | --- | --- | --- | --- | --- | --- |
| 제출 범위 | 핵심 기능 중심 최소 스코프 제출 | 확장 기능 포함 전체 스코프 제출 |  |  |  |  |
| 메타데이터 | 필수 메타데이터 우선 등록 | SEO/전환 최적화 메타데이터 보강 |  |  |  |  |
| 개인정보/정책 | 필수 법적 문서 및 기본 고지 충족 | 기능별 데이터 처리 고지 상세화 |  |  |  |  |
| 품질 기준 | 블로커/크리티컬 이슈 0건 기준 | 주요/경미 이슈까지 정리 후 제출 |  |  |  |  |
| 테스트 범위 | 핵심 플로우 중심 스모크 테스트 | 회귀 + 엣지 케이스 + 디바이스 매트릭스 확대 |  |  |  |  |
| 수익화 설정 | 필수 상품만 활성화 | 구독 플랜/프로모션/실험 설정 확대 |  |  |  |  |
| 심사 대응 | 필수 리뷰 노트 및 기본 계정 제공 | 상세 재현 절차/FAQ/운영 연락체계 포함 |  |  |  |  |

### 운영 체크 포인트

- [ ] 각 행의 `현재값/목표값/담당자/완료일`을 실제 릴리즈 스프린트 기준으로 채웠다.
- [ ] Phase 전환 기준(Phase 1 → Phase 2)을 팀 내 합의 문서와 동기화했다.
- [ ] 제출 직전 기준으로 표와 체크리스트를 최신 상태로 업데이트했다.
# STORE SUBMISSION CHECKLIST

릴리스 전 스토어 제출 준비 상태를 iOS(App Store Connect)와 Android(Play Console) 기준으로 확인하는 체크리스트입니다.

## iOS (App Store Connect)

### 필수 제출 항목
- [ ] 번들 ID 확인 (`Bundle Identifier`)
- [ ] 서명 상태 확인 (Apple Distribution 인증서 + 프로비저닝 프로파일)
- [ ] 스크린샷 세트 준비 (지원 기기별 해상도/개수 충족)
- [ ] 앱 설명/키워드 작성 (로컬라이즈 포함 여부 확인)
- [ ] 지원 URL 입력
- [ ] 개인정보처리방침 URL 입력
- [ ] 데이터 수집/공유 선언(App Privacy) 완료
- [ ] 콘텐츠 등급(Age Rating) 문답 완료
- [ ] 계정 삭제 경로 제공(앱 내 경로 + 필요 시 URL 안내)

### IAP/광고 미사용 확인
- [ ] IAP(인앱결제) 현재 미사용 명시
- [ ] 광고 SDK 현재 미사용 명시
- [ ] 코드/SDK 의존성 점검: `in_app_purchase` 없음
- [ ] 코드/SDK 의존성 점검: `google_mobile_ads` 없음
- [ ] App Store Connect 콘솔 입력값: IAP/광고 관련 항목 `해당 없음(Not in use)`으로 기록

---

## Android (Google Play Console)

### 필수 제출 항목
- [ ] 패키지명 확인 (`applicationId`)
- [ ] 서명 상태 확인 (Play App Signing + 업로드 키)
- [ ] 스크린샷 세트 준비 (휴대전화/태블릿/기타 폼팩터 필요 시)
- [ ] 앱 설명/키워드(스토어 문구) 작성
- [ ] 지원 URL 입력
- [ ] 개인정보처리방침 URL 입력
- [ ] 데이터 수집/공유 선언(데이터 보안 폼) 완료
- [ ] 콘텐츠 등급(Content Rating) 설문 완료
- [ ] 계정 삭제 경로 제공(앱 내 경로 + 필요 시 URL 안내)

### IAP/광고 미사용 확인
- [ ] IAP(인앱결제) 현재 미사용 명시
- [ ] 광고 SDK 현재 미사용 명시
- [ ] 코드/SDK 의존성 점검: `in_app_purchase` 없음
- [ ] 코드/SDK 의존성 점검: `google_mobile_ads` 없음
- [ ] Play Console 콘솔 입력값: 결제/광고 관련 항목 `해당 없음(Not in use)`으로 기록

## 제출 전 최종 점검 메모
- [ ] 실제 앱 빌드(릴리스)에서 결제/광고 관련 UI 또는 문구 노출 없음
- [ ] 스토어 메타데이터(설명, URL, 개인정보, 데이터 보안)와 앱 동작이 일치
- [ ] 리뷰어 확인용 테스트 계정/접근 방법 필요 시 별도 전달
# Store Submission Checklist

스토어 제출 전에 아래 항목을 모두 점검하세요.

## 1. Signing & Identifier

- [ ] Android: `android/key.properties`, keystore 경로, alias, upload key 확인
- [ ] iOS: Team, Provisioning Profile, `PRODUCT_BUNDLE_IDENTIFIER` 확인

## 2. Store Metadata (App Store / Play 공통)

- [ ] 앱명, 서브타이틀, 설명문(ko/en), 키워드, 카테고리, 지원 URL, 마케팅 URL, 문의 이메일
- [ ] 심사용 노트(앱 주요 플로우, 로그인 필요 여부, 데모 계정 필요 여부)

## 3. Privacy/Legal

- [ ] 개인정보처리방침 URL, 이용약관 URL이 실제 HTTPS로 접근 가능해야 함
- [ ] 앱 내 설정에서 동일 URL로 연결되는지 확인
- [ ] 데이터 수집/미수집 선언을 스토어 설문 답변과 일치시키는 검증 항목 추가

## 4. IAP/Ads Policy

- [ ] IAP 미사용/광고 미사용 시 스토어 콘솔 답변값을 문서에 명시
- [ ] 추후 도입 시 필요한 정책 변경 항목(광고 ID, 추적, 결제약관) 별도 표기

## 5. Release Evidence

- [ ] 제출 직전 스크린샷/영상 첨부
- [ ] 버전 번호(Version) 기록
- [ ] 빌드 번호(Build Number) 기록
- [ ] 커밋 SHA 기록
