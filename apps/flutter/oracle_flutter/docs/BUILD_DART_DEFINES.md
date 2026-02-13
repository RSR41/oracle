# Flutter 빌드별 `--dart-define` 템플릿

## 1) STORE (스토어 심사용: 오프라인 안전 모드)

```bash
flutter build appbundle --release \
  --dart-define=API_PROFILE=STORE \
  --dart-define=BETA_FEATURES=false \
  --dart-define=AI_ONLINE=false
```

## 2) PHASE2 (AI 기능 검증/운영용)

```bash
flutter build appbundle --release \
  --dart-define=API_PROFILE=PHASE2 \
  --dart-define=API_BASE_URL=https://<backend-domain> \
  --dart-define=BETA_FEATURES=false \
  --dart-define=AI_ONLINE=true
```

## 3) PHASE2 내부 테스트 (베타 기능 포함)

```bash
flutter build apk --debug \
  --dart-define=API_PROFILE=PHASE2 \
  --dart-define=API_BASE_URL=http://10.0.2.2:8080 \
  --dart-define=BETA_FEATURES=true \
  --dart-define=AI_ONLINE=true
```

## 체크 포인트

- `API_PROFILE=PHASE2`면 `API_BASE_URL`을 같이 전달하는 것을 권장합니다.
- Android 에뮬레이터 로컬 서버는 `http://10.0.2.2:8080`을 사용합니다.
- iOS 시뮬레이터 로컬 서버는 `http://localhost:8080`을 사용합니다.
