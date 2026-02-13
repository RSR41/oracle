# ORACLE 모바일 배포 가이드 (iOS / Android)

`Oracle app final summary statement`의 Phase 1 목표(빠른 스토어 출시)에 맞춘 최소 릴리즈 가이드입니다.

## 1) 공통 사전 점검

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

- `pubspec.yaml` 버전(`version`) 증가
- 앱 아이콘/스플래시 최신화 (`flutter_launcher_icons`, `flutter_native_splash`)
- 개인정보/약관 URL, 문의 메일 점검

## 2) Android 빠른 배포

### 준비물
- `android/key.properties` 생성 (예시는 `android/key.properties.example` 참고)
- 업로드 키스토어 파일 준비

### 빌드
```bash
flutter build appbundle --release
```

### 업로드
- Google Play Console > 내부 테스트 트랙 먼저 업로드
- 크래시/ANR/로그인/결제 등 핵심 플로우 수동 점검
- 이상 없으면 운영 트랙 승격

## 3) iOS 빠른 배포

### 준비물
- Apple Developer의 App ID/Provisioning Profile/Certificate
- Xcode에서 Team, Bundle Identifier(`com.destiny.oracle`) 확인

### 빌드
```bash
flutter build ipa --release
```

### 업로드
- Xcode Organizer 또는 Transporter로 TestFlight 업로드
- 최소 1회 내부 테스터 검증 후 App Store 제출

## 4) 권장 배포 순서 (실수 방지)
1. Android 내부 테스트
2. iOS TestFlight 내부 테스트
3. 치명 버그(크래시, 네비게이션, 저장 기능) 수정
4. Android/iOS 동시 심사 제출

## 5) 릴리즈 체크 자동화
아래 스크립트는 키 파일/설정 파일 유무를 빠르게 확인합니다.

```bash
bash tools/release_preflight.sh
```

> 주의: 이 스크립트는 설정 누락을 빠르게 찾기 위한 용도이며, 실제 빌드/서명 성공을 100% 보장하지는 않습니다.
