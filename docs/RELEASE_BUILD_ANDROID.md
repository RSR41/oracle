# Android 릴리즈 빌드 가이드

본 문서는 Oracle 사주 앱의 Android 릴리즈 AAB 빌드 절차입니다.

---

## 사전 요구사항

- Flutter SDK 3.8.0 이상
- Android SDK
- Java 11 이상
- Keystore 설정 완료 (→ [ANDROID_SIGNING.md](./ANDROID_SIGNING.md))

---

## 빌드 절차

### 1단계: 앱 루트로 이동
```powershell
cd oracle/apps/flutter/oracle_flutter
```

### 2단계: 의존성 설치
```powershell
flutter pub get
```

### 3단계: 정적 분석
```powershell
flutter analyze
```
> `No issues found!`가 나와야 진행

### 4단계: 릴리즈 AAB 빌드

#### 기본 빌드 (베타 기능 숨김)
```powershell
flutter build appbundle --release --dart-define=BETA_FEATURES=false
```

#### 법적 URL 포함 빌드 (스토어 제출용)
```powershell
flutter build appbundle --release `
  --dart-define=BETA_FEATURES=false `
  --dart-define=TERMS_URL=https://YOUR_USERNAME.github.io/oracle/legal/terms_of_service `
  --dart-define=PRIVACY_URL=https://YOUR_USERNAME.github.io/oracle/legal/privacy_policy
```

> ⚠️ `YOUR_USERNAME`을 실제 GitHub 사용자명으로 교체!

### 5단계: 빌드 결과 확인
```powershell
Get-ChildItem build\app\outputs\bundle\release\
```

출력:
```
app-release.aab
```

---

## dart-define 옵션 정리

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `BETA_FEATURES` | 베타 기능 표시 여부 | `false` (릴리즈) |
| `TERMS_URL` | 이용약관 URL | GitHub Pages fallback |
| `PRIVACY_URL` | 개인정보처리방침 URL | GitHub Pages fallback |

---

## 빌드 전 체크리스트

### 필수
- [ ] Keystore 생성 및 `key.properties` 설정 완료
- [ ] `flutter analyze` 에러 0개
- [ ] `BETA_FEATURES=false` 설정
- [ ] 법적 문서 placeholder 교체 완료 (→ [PLACEHOLDERS.md](./legal/PLACEHOLDERS.md))
- [ ] GitHub Pages 배포 완료 및 URL 확인

### 권장
- [ ] `pubspec.yaml` 버전 업데이트 (예: `1.2.0+3`)
- [ ] 에뮬레이터/실기기에서 릴리즈 모드 테스트

---

## 빌드 후 테스트

### 에뮬레이터 테스트
```powershell
flutter run --release --dart-define=BETA_FEATURES=false
```

### MVP 기능 확인
- [ ] 사주 (오늘의 운세) 동작
- [ ] 만세력 (캘린더) 동작
- [ ] 타로 동작
- [ ] 꿈해몽 동작
- [ ] 관상 (얼굴 분석) 동작

### 베타 기능 숨김 확인
- [ ] 소개팅 탭/메뉴 **없음**
- [ ] 이상형 생성 메뉴 **없음**

### 법적 링크 확인
- [ ] 설정 화면 → 이용약관 탭 → 브라우저 열림
- [ ] 설정 화면 → 개인정보처리방침 탭 → 브라우저 열림
- [ ] 오픈소스 라이선스 탭 → 라이선스 페이지 표시

---

## 산출물 경로

```
oracle/apps/flutter/oracle_flutter/build/app/outputs/bundle/release/app-release.aab
```

이 파일을 Google Play Console에 업로드합니다.

---

## 다음 단계

→ [STORE_SUBMISSION_CHECKLIST.md](./STORE_SUBMISSION_CHECKLIST.md)
