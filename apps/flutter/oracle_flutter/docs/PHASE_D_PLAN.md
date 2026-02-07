# Phase D: Meeting 고도화 및 데모 안정화 계획

현재 Phase C-3까지 Meeting MVP의 핵심 기능(추천, 매칭, 채팅)이 구현되었습니다. Phase D에서는 이를 실제 앱 서비스 수준으로 끌어올리고, 데모의 안정성을 극대화하는 작업을 진행합니다.

## 핵심 목표
1. **데모 도구의 완성**: 개발/시연 전용 기능을 일반 유저에게 노출되지 않도록 격리.
2. **실제 프로필 연동**: 하드코딩된 'me' 유저 정보를 `AppState`와 연동.
3. **UX 안정성**: 대량 데이터나 에러 상황에서도 앱이 견고하게 동작하도록 보강.

## 상세 작업 항목

### D-1: Seed 기능 디버그/데모 전용 격리
- 현재 `MeetingHomeScreen` 상단에 있는 리셋 버튼을 `kDebugMode`에서만 노출되도록 수정.
- Seed 데이터 생성 로직을 `MeetingService`에서 분리하여 `MeetingDemoHelper`(가칭)로 관리.

### D-2: hasSajuProfile 실제 데이터 연결
- 현재 `ScaffoldWithNavBar`에서 단순 boolean으로 체크하던 `hasSajuProfile`을 실제 DB에 저장된 내 프로필 존재 여부와 동기화.
- `MeetingService`에서 'me'라고 사용하던 하드코딩 ID를 실제 사용자 UUID로 교체.

### D-3: 대량 데이터 및 예외 상황 UI 안전장치
- 추천 리스트/채팅 내역 로딩 시 UX 개선 (CircularProgressIndicator 또는 Shimmer).
- 리스트 끝(End of List) 표시 및 추가 로드(Pagination) UI 피드백 강화.
- 무선 네트워크 단절 시나리오 등을 고려한 에러 처리 (현재는 로컬 DB이므로 DB 트랜잭션 실패 위주).

### D-4: 데모 시나리오 1분 완주 최적화
- 리셋 후 '지수'님과의 대화방이 즉시 생성되는 흐름이 자연스러운지 재점검.
- Polling 주기와 자동 답장(Mock Reply) 타이밍을 시연 속도에 맞춰 미세 조정.

---
## 성공 기준
- `flutter analyze` 시 이슈 0건 유지.
- Windows 환경에서 1분 이내에 "리셋 -> 추천 -> 채팅 -> 답장 수신" 전 과정을 오류 없이 시연 가능.
