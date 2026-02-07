# Meeting MVP (Phase C-3) 시연 가이드

## 1. 개요
`oracle_meeting` 패키지를 통해 구현된 "오늘의 인연" 기능의 전체 시퀀스를 검증합니다. 로컬 SQLite를 기반으로 "추천 -> 좋아요 -> 매칭 -> 채팅"으로 이어지는 E2E 흐름을 시나리오화 합니다.

## 2. 데이터 초기화 및 Seed (디버그/데모 전용)
테스트 편의를 위해 상단 AppBar에 **리셋 버튼(↺)**이 제공됩니다.
> [!IMPORTANT]
> 이 버튼은 **디버그 모드(Debug Mode)**에서만 노출되며, 배포용 릴리즈 빌드에서는 일반 사용자에게 보이지 않도록 격리되어 있습니다.

- **기능**: 모든 기존 데이터(User, Like, Match, Message)를 삭제하고 시연용 데이터를 생성합니다.
- **안전장치**: 예기치 않은 데이터 삭제를 방지하기 위해 **2단계 확인 절차**가 적용되어 있습니다.

## 3. 시연 시나리오 (1분 완주 코스)

발표 시나리오는 다음 **7단계**를 따릅니다. 로직이 고정되어 있어 실패 없이 재현 가능합니다.

1.  **앱 실행 & 진입**: 하단 내비게이션의 **Meeting** 탭을 선택합니다.
2.  **프로필 게이트**: 아직 사주 정보가 없다면 안내 화면이 뜹니다. **'사주 프로필 만들기'**를 눌러 닉네임과 생년월일을 입력합니다.
3.  **데모 데이터 리셋 (↺)**: 상단 AppBar의 리셋 버튼을 누르고 2단계 확인을 거칩니다. (기존 데이터 삭제 및 최적화된 데모셋 생성)
4.  **추천 & 좋아요**: 추천 리스트 최상단(또는 상위)에 있는 **'지수'**님을 찾아 **하트(♥)**를 누릅니다.
    - *참고: 데모 시나리오 상 '지수'님은 항상 매칭이 성공하도록 고정되어 있습니다.*
5.  **매칭 성공**: 팝업에서 **'채팅하기'**를 눌러 즉시 대화방으로 이동합니다.
6.  **실시간 채팅**: 메시지를 보냅니다. **2초 후** 상대방으로부터 결정론적인(Deterministic) 정중한 답장이 옵니다.
7.  **기록 확인**: **History** 탭으로 이동하여 방금 나눈 대화와 운세 기록(더미 포함)이 목록에 남았는지 확인하며 시연을 마칩니다.

---

## 4. 핵심 기술 포인트 (MVP 가치)
- **로컬 우선(Local First)**: 모든 매칭/메시지 데이터는 SQLite에 저장되어 인터넷 없이도 동작합니다.
- **궁합 알고리즘**: 사주 데이터를 기반으로 한 결정론적 점수 계산 로직이 포함되어 있습니다.
- **격리된 시연 환경**: `kDebugMode`를 통한 개발자 도구 격리로 릴리스 안정성을 확보했습니다.

## 5. 관련 파일 정보
- **Repository**: `oracle_meeting/lib/src/repository/meeting_repository.dart`
- **Service**: `oracle_meeting/lib/src/services/meeting_service.dart` (`resetAndSeedAll` 로직 포함)
- **UI (Home)**: `oracle_meeting/lib/src/screens/meeting_home_screen.dart` (Seed 버튼 및 리스트)
- **UI (Chat)**: `oracle_meeting/lib/src/screens/meeting_chat_screen.dart` (채팅 UI 및 Polling)

## 6. 트러블슈팅 (LNK1168)
Windows 빌드 중 파일 잠김(LNK1168) 발생 시 다음 명령어를 실행하세요:
```powershell
taskkill /F /IM flutter.exe /IM dart.exe /IM oracle_flutter.exe
flutter clean; flutter run -d windows
```
