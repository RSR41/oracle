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
