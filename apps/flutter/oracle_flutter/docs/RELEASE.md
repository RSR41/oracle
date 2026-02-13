# Oracle Flutter Release Guide

## Legal URL configuration (required)

`AppUrls` uses fallback URLs for local development. Before production release, do one of the following:

1. Replace `oracle-user.github.io` in fallback URLs with your real domain.
2. Inject real URLs at build time with `--dart-define` (recommended).

### Release build command

```bash
flutter build appbundle --release \
  --dart-define=TERMS_URL=https://<real-domain>/legal/terms_of_service \
  --dart-define=PRIVACY_URL=https://<real-domain>/legal/privacy_policy
```

> Do not release with the default `https://oracle-user.github.io/...` values.
