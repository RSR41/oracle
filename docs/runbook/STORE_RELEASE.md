# Oracle 사주 - STORE_RELEASE Runbook

본 문서는 Google Play 스토어 1차 심사 제출을 위한 **STORE_RELEASE** 빌드 절차입니다.
모든 명령어는 Windows PowerShell 기준입니다.

---

## 1. 환경 점검 & 준비

### 1-1. Flutter 상태 확인
```powershell
flutter doctor
```
- Flutter 3.8.0 이상 권장
- Android toolchain 체크 완료 확인

### 1-2. 프로젝트 업데이트
```powershell
cd oracle/apps/flutter/oracle_flutter
flutter clean
flutter pub get
```

### 1-3. 사전 검증
`verify_store_ready.ps1` 스크립트를 실행하여 준비 상태를 확인합니다.
```powershell
cd ../../.. # repo root
.\tools\verify_store_ready.ps1
```
> **PASS**가 나와야 진행 가능합니다. (key.properties, placeholder 등 확인)

---

## 2. 서명 설정 (최초 1회)

⚠️ **이미 설정되어 있다면 SKIP하세요.**

### 2-1. Keystore 생성 (없을 경우)
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

---

## 3. STORE_RELEASE 빌드

심사 제출용 빌드는 **AI/서버 기능이 완전히 차단**된 상태여야 합니다.

### 3-1. 빌드 명령어
```powershell
cd apps/flutter/oracle_flutter

flutter build appbundle --release `
  --dart-define=BETA_FEATURES=false `
  --dart-define=AI_ONLINE=false `
  --dart-define=TERMS_URL=https://<YOUR_GITHUB_ID>.github.io/oracle/legal/terms_of_service `
  --dart-define=PRIVACY_URL=https://<YOUR_GITHUB_ID>.github.io/oracle/legal/privacy_policy
```
> `<YOUR_GITHUB_ID>`를 실제 GitHub 아이디로 교체하세요.

### 3-2. 산출물 확인
빌드가 완료되면 아래 경로에 AAB 파일이 생성됩니다.
`build/app/outputs/bundle/release/app-release.aab`

---

## 4. 최종 점검 및 제출

### 4-1. 에뮬레이터 테스트 (옵션)
```powershell
flutter run --release `
  --dart-define=BETA_FEATURES=false `
  --dart-define=AI_ONLINE=false
```
- **체크 포인트**:
  - [ ] 앱 실행 후 크래시 없음
  - [ ] "오늘의 운세" 등 MVP 기능 정상 동작
  - [ ] "AI 분석" / "소개팅" 메뉴가 보이지 않음 (또는 동작 안함)
  - [ ] 설정 > 이용약관 클릭 시 브라우저 열림
  - [ ] 이용약관/개인정보 URL 실제 접근 확인 (HTTPS, 404 없음)

### 4-2. Google Play Console 업로드
1. Google Play Console 로그인
2. 앱 선택 > **프로덕션** (또는 비공개 테스트)
3. **새 버전 만들기**
4. `app-release.aab` 업로드
5. 버전 이름 입력 (예: `1.1.0 Release`)
6. 검토 제출

---

## 5. 문제 해결

### 문법 에러 발생 시
`flutter analyze` 실행하여 문제 확인

### 서명 오류 (Keystore 관련)
- `key.properties`의 비밀번호가 맞는지 확인
- `storeFile` 경로가 올바른지 확인 (`../oracle-release.jks`)

### 법적 페이지 404
- GitHub Pages 배포 설정(Source: main, Folder: /docs) 확인
- URL 오타 확인
