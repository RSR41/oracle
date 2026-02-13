# iOS Signing 설정 가이드

`apps/flutter/oracle_flutter/ios/Runner.xcodeproj`의 Signing 설정 표준입니다.

## Runner Target 기준값

| Configuration | Team | Signing | Provisioning |
|---|---|---|---|
| Debug | `$(ORACLE_IOS_TEAM_ID)` | Automatic | 빈 값(`""`) |
| Release | `$(ORACLE_IOS_TEAM_ID)` | Automatic | 빈 값(`""`) |
| Profile | `$(ORACLE_IOS_TEAM_ID)` | Automatic | 빈 값(`""`) |

- Team ID는 로컬/Xcode 또는 CI에서 `ORACLE_IOS_TEAM_ID` 값으로 주입합니다.
- Automatic signing을 사용하므로, Provisioning Profile은 Xcode가 관리합니다.

## Xcode 확인 절차

1. `open apps/flutter/oracle_flutter/ios/Runner.xcworkspace`
2. `Runner` Target → **Signing & Capabilities**
3. Team에 Apple Developer Team 선택
4. Automatically manage signing 활성화 확인

## CI 권장

- CI에서 `ORACLE_IOS_TEAM_ID` 환경변수를 설정하고, 빌드 전에 Export 하십시오.
- Manual signing이 필요한 경우, 본 문서와 `tools/release_preflight.sh`의 정책을 함께 수정하세요.
