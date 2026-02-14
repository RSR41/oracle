# 스토어 제출 체크리스트 (iOS/Android 공통)

본 문서는 Oracle 사주 앱의 App Store Connect / Google Play Console 제출 준비 상태를 한 문서에서 관리하기 위한 체크리스트입니다.

> QA 실행 기준은 [SMOKE_TEST.md](./SMOKE_TEST.md)와 동일해야 합니다. 제출 전 두 문서를 함께 갱신해 테스트-제출 간 불일치를 방지하세요.

---

## 1) 공통 제출 메타데이터

| 항목 | 현재값 | 입력 위치 | 완료여부 |
|---|---|---|---|
| 앱 설명 (국문) | TODO | App Store Connect / Play Console 스토어 설명 | ⬜ |
| 앱 설명 (영문) | TODO | App Store Connect / Play Console 스토어 설명 | ⬜ |
| 키워드 | TODO | App Store Connect (Keywords), Play Console (검색 최적화) | ⬜ |
| 문의 메일 | TODO | App Store Connect (Support URL/Contact), Play Console (앱 지원) | ⬜ |
| 릴리즈 노트 | TODO | App Store Connect (What’s New), Play Console (출시 노트) | ⬜ |
### 교체 확인
```powershell
Select-String -Path "docs\legal\*.md" -Pattern "TODO\(FILL_ME\)"
```
> 결과 없음 = 모든 placeholder 교체 완료

### GitHub Pages 배포
→ [DEPLOY_LEGAL_PAGES.md](./legal/DEPLOY_LEGAL_PAGES.md) 참조

- [ ] GitHub Pages 설정 완료 (Settings → Pages → /docs)
- [ ] 이용약관 URL 접근 확인: `https://oracle-saju.github.io/oracle/legal/terms_of_service`
- [ ] 개인정보처리방침 URL 접근 확인: `https://oracle-saju.github.io/oracle/legal/privacy_policy`

---

## 2) iOS 제출 항목 (App Store Connect)

| 항목 | 현재값 | 입력 위치 | 완료여부 |
|---|---|---|---|
| Bundle ID | TODO (예: com.company.oracle) | Apple Developer / Xcode Target / App Store Connect 앱 식별자 | ⬜ |
| Signing Team | TODO | Xcode Signing & Capabilities / Apple Developer Team | ⬜ |
| Privacy Nutrition Label | TODO | App Store Connect > App Privacy | ⬜ |
| 심사 노트 (Review Notes) | TODO | App Store Connect > App Review Information | ⬜ |
| 스크린샷 규격/개수 | TODO | App Store Connect > Media Manager (기기별 권장 규격 및 최소 장수 충족) | ⬜ |
- [ ] `oracle-release.jks` 생성 완료
- [ ] `android/key.properties` 생성 완료
- [ ] Keystore 파일 안전한 곳에 백업

### AAB 빌드
→ [RELEASE_BUILD_ANDROID.md](./RELEASE_BUILD_ANDROID.md) 참조

- [ ] 빌드 명령 실행:
```powershell
flutter build appbundle --release `
  --dart-define=BETA_FEATURES=false `
  --dart-define=TERMS_URL=https://oracle-saju.github.io/oracle/legal/terms_of_service `
  --dart-define=PRIVACY_URL=https://oracle-saju.github.io/oracle/legal/privacy_policy
```
- [ ] `app-release.aab` 생성 확인

---

## 3) Android 제출 항목 (Play Console)

| 항목 | 현재값 | 입력 위치 | 완료여부 |
|---|---|---|---|
| 앱 서명 (App Signing) | TODO | Play Console > App integrity | ⬜ |
| Data Safety | TODO | Play Console > App content > Data safety | ⬜ |
| 콘텐츠 등급 | TODO | Play Console > App content > Content rating | ⬜ |
| 타깃 연령 | TODO | Play Console > App content > Target audience | ⬜ |
| 정책 선언 (Policy declarations) | TODO | Play Console > App content > 정책별 선언 섹션 | ⬜ |
### 릴리즈 모드 테스트
- [ ] 에뮬레이터/실기기에서 `flutter run --release` 실행
- [ ] MVP 기능 5개 모두 동작 확인
- [ ] 베타 기능 숨김 확인
- [ ] 설정 화면 법적 링크 동작 확인
- [ ] 앱 크래시 없음 확인
- [ ] 권한 문구 스크린샷/실기기 확인 (카메라/갤러리 접근 및 저장 권한 팝업)

---

## 4) QA 연동 체크 (SMOKE_TEST 상호 참조)

- [ ] [SMOKE_TEST.md](./SMOKE_TEST.md)의 전체 항목이 최신 빌드 기준으로 완료되었는지 확인
- [ ] 본 문서의 **현재값**이 실제 앱 빌드/콘솔 입력값과 일치하는지 확인
- [ ] QA 결과(특히 법적 링크, 기능 노출, 크래시 여부)와 스토어 설명/심사 노트가 상충하지 않는지 확인

---

## 5) 제출 직전 최종 확인

- [ ] iOS/Android 모두 메타데이터 저장 및 검증 완료
- [ ] 릴리즈 바이너리(AAB/IPA)와 릴리즈 노트 버전 일치
- [ ] 정책/개인정보/연령 등급 관련 경고 없음
- [ ] 내부 공유용 제출 스냅샷(입력 화면 캡처) 보관

