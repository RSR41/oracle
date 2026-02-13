# Google Play 스토어 제출 체크리스트

본 문서는 Oracle 사주 앱의 Google Play Console 제출을 위한 최종 체크리스트입니다.

---

## Phase 1: 코드 준비

### 코드 품질
- [ ] `flutter analyze` 에러 0개
- [ ] 콘솔 로그/디버그 코드 제거 확인

### 버전 관리
- [ ] `pubspec.yaml` 버전 업데이트 (현재: `1.1.0+2`)
- [ ] 릴리즈 노트 작성

### 베타 기능 숨김
- [ ] `BETA_FEATURES=false` 빌드 확인
- [ ] MVP 5개 기능만 노출: 사주, 만세력, 타로, 꿈해몽, 관상
- [ ] 베타 기능 숨김: 소개팅, 이상형 생성

---

## Phase 2: 법적 문서 준비

### placeholder 교체
→ [PLACEHOLDERS.md](./legal/PLACEHOLDERS.md) 참조

- [ ] `TODO(FILL_ME): 회사명` → 실제 회사명
- [ ] `TODO(FILL_ME): 대표자명` → 실제 대표자명
- [ ] `TODO(FILL_ME): 이메일` → 실제 이메일
- [ ] `TODO(FILL_ME): 주소` → 실제 주소
- [ ] `TODO(FILL_ME): 개인정보보호책임자명` → 실제 책임자명
- [ ] `TODO(FILL_ME): 연락처` → 실제 연락처

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

## Phase 3: 앱 서명 및 빌드

### Keystore 설정
→ [ANDROID_SIGNING.md](./ANDROID_SIGNING.md) 참조

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

## Phase 4: 앱 테스트

### 릴리즈 모드 테스트
- [ ] 에뮬레이터/실기기에서 `flutter run --release` 실행
- [ ] MVP 기능 5개 모두 동작 확인
- [ ] 베타 기능 숨김 확인
- [ ] 설정 화면 법적 링크 동작 확인
- [ ] 앱 크래시 없음 확인

---

## Phase 5: Google Play Console 등록

### 앱 정보
- [ ] 앱 이름: Oracle 사주
- [ ] 간단한 설명 (80자 이내)
- [ ] 자세한 설명 (4000자 이내)
- [ ] 앱 카테고리: 라이프스타일

### 스토어 등록정보
- [ ] 앱 아이콘 (512x512 PNG)
- [ ] 기능 그래픽 (1024x500 PNG)
- [ ] 휴대폰 스크린샷 (최소 2장)
  - 홈 화면
  - 운세 결과 화면
  - 설정 화면 (법적 링크 포함)

### 콘텐츠 등급
- [ ] 콘텐츠 등급 설문 완료
- [ ] 예상 등급: 전체 이용가 (3+)

### 개인정보처리방침
- [ ] 개인정보처리방침 URL 입력 (GitHub Pages URL)

---

## Phase 6: 데이터 안전 섹션

Oracle 사주 앱의 데이터 수집 현황:

### 답변 가이드
| 질문 | 답변 | 근거 |
|------|------|------|
| 데이터 수집 여부 | ✅ 예 | 생년월일, 출생시간 등 수집 |
| 데이터 공유 여부 | ❌ 아니오 | 서버 전송 없음 |
| 데이터 암호화 | ✅ 예 | SQLite 로컬 저장 |
| 데이터 삭제 요청 | ✅ 가능 | 앱 삭제 시 전체 삭제 |

### 수집 데이터 유형
| 유형 | 수집 | 용도 | 필수 |
|------|------|------|------|
| 개인 정보 - 이름 | ✅ | 앱 기능 | 선택 |
| 개인 정보 - 생년월일 | ✅ | 앱 기능 | 필수 |
| 사진 및 동영상 | ✅ | 앱 기능 (관상) | 선택 |

### 관상 기능 관련
- ❌ 서버로 전송되지 않음
- ❌ 제3자와 공유되지 않음
- ✅ 기기 내 로컬 처리만

---

## Phase 7: 제출

- [ ] AAB 파일 업로드
- [ ] 출시 노트 작성
- [ ] 검토 제출

### 심사 기간
- 신규 앱: 1~3일 (최대 7일)
- 업데이트: 1시간~1일

---

## 최종 체크리스트 요약

| 단계 | 상태 |
|------|------|
| 코드 품질 | ⬜ |
| 법적 문서 | ⬜ |
| 앱 서명 | ⬜ |
| AAB 빌드 | ⬜ |
| 앱 테스트 | ⬜ |
| 스토어 정보 | ⬜ |
| 데이터 안전 | ⬜ |
| 제출 | ⬜ |
