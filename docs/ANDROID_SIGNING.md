# Android 앱 서명 가이드

본 문서는 Oracle 사주 앱의 Android 릴리즈 빌드를 위한 앱 서명 설정 방법입니다.

---

## 현재 상태

| 항목 | 값 |
|------|-----|
| 앱 ID | `com.destiny.oracle` |
| 서명 설정 | ✅ 완료 (`build.gradle.kts`에 key.properties 로드 로직 구현) |
| .gitignore | ✅ key.properties, *.jks 제외됨 |

---

## 서명 설정 절차

### 1단계: Keystore 생성

PowerShell에서 실행:
```powershell
cd oracle/apps/flutter/oracle_flutter

# Java keytool로 keystore 생성
keytool -genkey -v `
  -keystore oracle-release.jks `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias oracle
```

입력 요청 시:
- **keystore 비밀번호**: 안전한 비밀번호 입력 (기록 필수!)
- **key 비밀번호**: 동일하거나 다른 비밀번호 입력
- **이름, 조직, 국가 등**: 실제 정보 또는 임의 값 입력

### 2단계: key.properties 생성

`android/key.properties.example`을 복사하여 `android/key.properties` 생성:
```powershell
cd oracle/apps/flutter/oracle_flutter/android
Copy-Item key.properties.example key.properties
```

`key.properties` 내용 수정:
```properties
storePassword=실제_keystore_비밀번호
keyPassword=실제_key_비밀번호
keyAlias=oracle
storeFile=../oracle-release.jks
```

### 3단계: 서명 확인

```powershell
cd oracle/apps/flutter/oracle_flutter
flutter build appbundle --release
```

빌드 성공 시 서명 완료!

---

## 파일 위치

```
oracle/apps/flutter/oracle_flutter/
├── oracle-release.jks        ← 생성한 keystore (git 제외됨)
└── android/
    ├── key.properties        ← 생성한 설정 파일 (git 제외됨)
    └── key.properties.example ← 템플릿 (git에 포함)
```

---

## 보안 체크리스트

- [ ] `oracle-release.jks` 파일이 git에 커밋되지 않음 확인
- [ ] `android/key.properties` 파일이 git에 커밋되지 않음 확인
- [ ] keystore 비밀번호를 안전한 곳에 백업
- [ ] keystore 파일을 별도 안전한 곳에 백업 (분실 시 앱 업데이트 불가)

---

## Google Play App Signing (권장)

Google Play Console의 App Signing 기능 사용 시:
1. Google이 앱 서명 키를 안전하게 관리
2. 키 분실 시에도 앱 업데이트 가능

설정 방법:
1. Google Play Console → 앱 → **설정** → **앱 서명**
2. **App Signing by Google Play** 활성화
3. 첫 AAB 업로드 시 업로드 키 등록됨

---


## 로컬 시크릿 구성 (권장)

`android/key.properties.example`를 기준으로 **로컬에서만** 실제 시크릿 파일을 구성합니다.

```bash
cd apps/flutter/oracle_flutter/android
cp key.properties.example key.properties
```

`key.properties`를 실제 값으로 변경:

```properties
storePassword=<REAL_STORE_PASSWORD>
keyPassword=<REAL_KEY_PASSWORD>
keyAlias=oracle
storeFile=../oracle-release.jks
```

- `android/key.properties`는 git에 커밋하지 않습니다.
- `storeFile`은 `apps/flutter/oracle_flutter/android` 기준 상대경로입니다.

---

## CI 시크릿 주입 경로

CI에서는 저장소에 `key.properties`를 커밋하지 않고, 빌드 직전에 파일을 생성합니다.

- 생성 경로: `apps/flutter/oracle_flutter/android/key.properties`
- keystore 경로: `apps/flutter/oracle_flutter/oracle-release.jks`

GitHub Actions 예시:

```yaml
- name: Restore Android signing secrets
  working-directory: apps/flutter/oracle_flutter
  shell: bash
  run: |
    echo "$ANDROID_KEYSTORE_BASE64" | base64 --decode > oracle-release.jks
    cat > android/key.properties <<'EOK'
    storePassword=${ANDROID_STORE_PASSWORD}
    keyPassword=${ANDROID_KEY_PASSWORD}
    keyAlias=${ANDROID_KEY_ALIAS}
    storeFile=../oracle-release.jks
    EOK
  env:
    ANDROID_KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
    ANDROID_STORE_PASSWORD: ${{ secrets.ANDROID_STORE_PASSWORD }}
    ANDROID_KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
    ANDROID_KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
```

---

## 트러블슈팅

### 문제: keytool 명령을 찾을 수 없음
```powershell
# Android Studio JDK 경로 추가
$env:PATH += ";C:\Program Files\Android\Android Studio\jbr\bin"
```

### 문제: key.properties 파일을 찾을 수 없음
- 파일 경로 확인: `android/key.properties` (android 폴더 안)
- `build.gradle.kts`가 `rootProject.file("key.properties")` 참조

### 문제: 빌드 시 서명 오류
- storeFile 경로 확인 (`../oracle-release.jks`는 앱 루트 기준)
- 비밀번호에 특수문자가 있으면 따옴표로 감싸기
