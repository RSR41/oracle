# ORACLE Flutter App

ORACLE 메인 사주 앱(Phase 1)입니다. 빠른 스토어 배포를 목표로 iOS/Android 릴리즈 절차를 정리했습니다.

## 프로젝트 경로
- 메인 앱: `apps/flutter/oracle_flutter`
- 소개팅 기능(추가 앱/모듈): `apps/flutter/oracle_meeting`

## 빠른 시작
```bash
flutter pub get
flutter run
```

## 릴리즈 준비 (핵심)
1. `pubspec.yaml` 버전 업데이트 (`version: x.y.z+build`)
2. Android 서명 파일 준비 (`android/key.properties`, keystore)
3. iOS 서명/프로비저닝 설정 (Xcode)
4. 아래 사전 점검 스크립트 실행

```bash
bash tools/release_preflight.sh
```

자세한 내용은 `docs/MOBILE_RELEASE_GUIDE.md`를 참고하세요.
