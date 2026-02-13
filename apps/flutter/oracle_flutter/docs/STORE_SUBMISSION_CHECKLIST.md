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
