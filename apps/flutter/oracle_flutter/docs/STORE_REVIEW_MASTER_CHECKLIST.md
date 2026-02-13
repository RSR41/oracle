# STORE REVIEW MASTER CHECKLIST

앱 스토어(Play Console / App Store Connect) 제출 전에 운영자가 즉시 검증할 수 있도록, 각 항목별 확인 위치를 함께 정리한 마스터 체크리스트입니다.

## 1) 공통

- [ ] **버전/빌드번호 확인**
  - 확인 위치(파일): `apps/flutter/oracle_flutter/pubspec.yaml` (`version`)
  - 확인 위치(콘솔 메뉴):
    - Android: Play Console > 앱 > **릴리스** > 테스트/프로덕션 트랙
    - iOS: App Store Connect > My Apps > 앱 > **TestFlight / App Store** > Build
- [ ] **릴리즈 노트 준비/반영**
  - 확인 위치(파일): `apps/flutter/oracle_flutter/docs/` 내 릴리즈 노트 문서(운영 정책에 따른 파일)
  - 확인 위치(콘솔 메뉴):
    - Android: Play Console > **릴리스** > 해당 릴리스 > 출시 노트
    - iOS: App Store Connect > 앱 버전 > **What’s New in This Version**
- [ ] **테스트 계정(로그인 필요 시) 준비**
  - 확인 위치(파일): 내부 운영 문서/시크릿 저장소(예: 사내 위키, 비밀관리 도구)
  - 확인 위치(콘솔 메뉴):
    - Android: Play Console > 앱 콘텐츠 > **앱 액세스(App access)**
    - iOS: App Store Connect > 앱 버전 > **App Review Information** > Sign-in required
- [ ] **문의 메일/연락처 최신화**
  - 확인 위치(파일): 운영 연락처 문서(사내 기준 문서)
  - 확인 위치(콘솔 메뉴):
    - Android: Play Console > 스토어 설정 > **스토어 등록정보**(연락처 세부정보)
    - iOS: App Store Connect > 앱 버전 > **App Review Information**(Contact Information)

## 2) Android

- [ ] **서명키(앱 서명) 상태 확인**
  - 확인 위치(파일): 로컬 키스토어/CI 시크릿 설정(키 alias, fingerprint)
  - 확인 위치(콘솔 메뉴): Play Console > 설정 > **앱 무결성(App integrity)**
- [ ] **Data safety 입력 검증**
  - 확인 위치(파일): 개인정보 처리방침/데이터 수집 정의 문서
  - 확인 위치(콘솔 메뉴): Play Console > 앱 콘텐츠 > **데이터 보안(Data safety)**
- [ ] **콘텐츠 등급(설문) 최신 상태 확인**
  - 확인 위치(파일): 앱 기능 설명 문서(사용자 생성 콘텐츠/채팅/위치 등)
  - 확인 위치(콘솔 메뉴): Play Console > 앱 콘텐츠 > **콘텐츠 등급(Content rating)**
- [ ] **타겟 API 요구사항 충족 확인**
  - 확인 위치(파일): `apps/flutter/oracle_flutter/android/app/build.gradle.kts` (또는 Gradle 설정 내 `targetSdk`)
  - 확인 위치(콘솔 메뉴): Play Console > 정책 상태/사전 점검 경고(타겟 API 관련)

## 3) iOS

- [ ] **Team / Signing 설정 확인**
  - 확인 위치(파일): `apps/flutter/oracle_flutter/ios/Runner.xcodeproj/project.pbxproj` (Signing, Development Team)
  - 확인 위치(콘솔 메뉴): Apple Developer > Certificates, Identifiers & Profiles / Xcode Signing 설정
- [ ] **Bundle ID 일치 확인**
  - 확인 위치(파일): `apps/flutter/oracle_flutter/ios/Runner.xcodeproj/project.pbxproj`, `apps/flutter/oracle_flutter/ios/Runner/Info.plist`
  - 확인 위치(콘솔 메뉴): App Store Connect > 앱 정보(App Information) > Bundle ID
- [ ] **Privacy Nutrition Label 입력 검증**
  - 확인 위치(파일): 개인정보 처리방침/SDK 데이터 수집 매트릭스 문서
  - 확인 위치(콘솔 메뉴): App Store Connect > 앱 > **App Privacy**
- [ ] **Age Rating 설정 확인**
  - 확인 위치(파일): 앱 기능 및 콘텐츠 정책 문서
  - 확인 위치(콘솔 메뉴): App Store Connect > 앱 버전 > **Age Rating**
- [ ] **Export Compliance 응답 확인**
  - 확인 위치(파일): 암호화 사용 여부 정리 문서(HTTPS, 자체 암호화 기능 포함 여부)
  - 확인 위치(콘솔 메뉴): App Store Connect > 앱 버전 > **Export Compliance**

## 4) IAP/광고

- [ ] **현재 IAP/광고 미사용 선언**
  - 확인 위치(파일):
    - 의존성 확인: `apps/flutter/oracle_flutter/pubspec.yaml` (결제/광고 SDK 패키지 부재 확인)
    - 플랫폼 설정 확인:
      - Android: `apps/flutter/oracle_flutter/android/app/src/main/AndroidManifest.xml` (광고/결제 관련 메타데이터·권한)
      - iOS: `apps/flutter/oracle_flutter/ios/Runner/Info.plist` (광고/추적 관련 키)
  - 확인 위치(콘솔 메뉴):
    - Android: Play Console > 앱 콘텐츠(수익화/광고 관련 질문)
    - iOS: App Store Connect > In-App Purchases / Advertising Identifier 관련 응답
- [ ] **향후 IAP/광고 도입 시 심사 영향 사전 점검**
  - 확인 위치(파일): 제품 로드맵/정책 체크리스트 문서
  - 확인 위치(콘솔 메뉴):
    - Android: Data safety, 콘텐츠 등급, 가족 정책, 결제정책 재검토
    - iOS: App Review Guidelines(결제/광고/추적), App Privacy, ATT 항목 재검토

## 5) 개인정보

- [ ] **앱 내 고지 문구 ↔ 스토어 입력 문구 일치 여부 체크**
  - 확인 위치(파일):
    - 앱 내 문구: `apps/flutter/oracle_flutter/lib/` 내 개인정보/약관/온보딩 안내 UI 코드
    - 정책 문서: 개인정보 처리방침 원문(운영 문서)
  - 확인 위치(콘솔 메뉴):
    - Android: Play Console > 데이터 보안(Data safety) / 앱 액세스
    - iOS: App Store Connect > App Privacy / App Review Information
  - 점검 기준:
    - 수집 항목, 수집 목적, 보관/삭제 정책, 제3자 제공 여부가 앱/스토어/정책문서에서 동일하게 표현되는지 확인

---

### 운영 메모(권장)

- 릴리스 직전 체크는 최소 2인(작성자/검토자)으로 교차 검증합니다.
- 스토어 입력값 변경 시, 본 문서를 함께 업데이트하여 다음 릴리스에 재사용합니다.
