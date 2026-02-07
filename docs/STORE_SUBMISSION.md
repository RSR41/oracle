# Store Submission Guide

이 문서는 1차 출시(RC)를 위한 최종 패키지 설정 및 가이드를 담고 있습니다.

## 1. 최종 확정 메타데이터
- **App Name**: Oracle 사주
- **Android Package**: `com.destiny.oracle`
- **iOS Bundle ID**: `com.destiny.oracle`
- **Version**: `1.1.0+2`

## 2. 브랜드 자산 (Placeholder)
- **아이콘**: `assets/brand/app_icon.png` (1024x1024)
- **스플래시**: `assets/brand/splash.png` (2048x2048)
- **생성 스크립트**: `tools/gen_brand_assets.ps1`

## 3. 리소스 갱신 명령어
빌드 전 아이콘이나 스플래시 설정을 변경했다면 아래 명령어를 순차적으로 실행하십시오.
```powershell
# placeholder 이미지 생성 (원본이 없을 경우)
powershell -File tools/gen_brand_assets.ps1

# 아이콘 및 스플래시 적용
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## 4. 출시 빌드 명령어 (AAB)
베타 기능을 제외한 상태로 빌드하는 표준 명령어입니다.
```powershell
flutter build appbundle --release --dart-define=BETA_FEATURES=false
```

---

## 5. 체크리스트
- [ ] `com.destiny.oracle`로 정상 설치 및 실행되는가?
- [ ] 앱 이름이 "Oracle 사주"로 표시되는가?
- [ ] 앱 시작 시 스플래시 화면이 노출되는가?
- [ ] `BETA_FEATURES=false` 설정 시 소개팅/관상 탭이 숨겨지는가?
