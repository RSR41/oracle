# Phase 2 접근 제한 리다이렉트 QA 체크

## 정책
- `FeatureFlags.showBetaFeatures == false`(스토어 릴리즈)인 경우, Phase 2 관련 경로 직접 접근은 모두 `/home`으로 리다이렉트된다.
- 이 정책은 하단 탭 노출 제어(`scaffold_with_navbar.dart`)와 동일한 플래그(`FeatureFlags.showBetaFeatures`)를 기준으로 동작한다.

## 대상 경로
다음 prefix를 가지는 경로는 모두 제한된다.
- `/face` (예: `/face`, `/face-result`, `/face-detail`)
- `/dream` (예: `/dream`, `/dream-result`, `/dream-detail`)
- `/meeting` (예: `/meeting`, `/meeting/history`, `/meeting/chat`)
- `/compat` (예: `/compatibility`, `/compat-check`, `/compat-result`, `/compat-detail`)
- `/ideal-type`
- `/consultation`
- `/yearly-fortune`

## QA 시나리오: 스토어 릴리즈에서 접근 시 리다이렉트
1. 빌드/실행 환경을 스토어 릴리즈 조건(`FeatureFlags.showBetaFeatures == false`)으로 준비한다.
2. 앱 실행 후, 딥링크 또는 라우팅으로 아래 경로에 직접 접근한다.
   - `/face`
   - `/dream`
   - `/meeting/chat`
   - `/compat-check`
   - `/ideal-type`
   - `/consultation`
   - `/yearly-fortune`
3. 각 케이스에서 `/home`으로 즉시 이동되는지 확인한다.
4. 하단 탭에 Meeting/Compat 탭이 노출되지 않는지 함께 확인한다.
