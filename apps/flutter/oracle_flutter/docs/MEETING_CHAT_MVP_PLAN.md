# Meeting Chat MVP 구현 계획 (Phase C-3)

## 1. 현재 상태 요약
- **패키지 분리**: `oracle_meeting` 패키지가 독립적으로 존재하며 `oracle_flutter`에서 참조 중.
- **데이터베이스**: `DatabaseHelper` (v2)에 `meeting_messages`, `meeting_matches` 등 필수 테이블 생성 완료.
- **라우팅**: `AppRouter`에 `/meeting/chat` 경로 연결 및 `MeetingChatScreen` 연동 완료.
- **UI MVP**: `MeetingChatScreen`에 기본적인 채팅 리스트 UI와 Polling 기반 가짜 실시간 로직 구현됨.

## 2. Messages 테이블 명세 및 채팅 ID 규칙
- **채팅 ID (matchId) 규칙**: `meeting_matches` 테이블의 `id` (UUID)를 그대로 `matchId`로 사용함.
- **테이블 구조**:
| 컬럼 | 타입 | 설명 |
|---|---|---|
| `id` | TEXT | 메시지 고유 식별자 (UUID) |
| `matchId` | TEXT | 소속된 매칭 ID (Chat ID 역할) |
| `senderId` | TEXT | 발신자 ID |
| `text` | TEXT | 메시지 내용 |
| `createdAt` | TEXT | 발송 일시 (ISO8601) |
| `readAt` | TEXT | 읽음 처리 일시 (Nullable) |

## 3. 핵심 API (Repository / Service)
- `getMessages(matchId, {limit, offset})`: 특정 매칭의 메시지 내역을 최신순으로 가져온 뒤 시간순으로 반환.
- `sendMessage(matchId, senderId, text)`: 메시지 저장 후 저장된 객체 반환.
- `seedTestMessages(matchId, count)`: 디버그용 대량 메시지 삽입 헬퍼.

## 3. 최소 채팅 기능 요구사항
1. **메시지 전송**: 유저가 텍스트 입력 후 전송 시 SQLite에 저장.
2. **실시간 시뮬레이션**: Polling(1초 주기)을 통해 DB의 새로운 메시지를 감지하여 UI 업데이트.
3. **가짜 답장 (Mock Reply)**: 유저가 메시지를 보내면 2초 후 "상대방"이 미리 정의된 무작위 답장을 보내도록 서비스 레이어에서 처리.
4. **읽음 처리**: 채팅방 진입 시 또는 새 메시지 수신 시 `readAt` 업데이트.
5. **안 읽은 메시지 배지**: 홈 화면 매칭 리스트에서 매칭별 안 읽은 메시지 개수 표시.

## 4. Phase C-3 작업 순서 (체크리스트)
- [ ] **Phase C-3-1: 서비스 고도화**
  - `MeetingService` 내 Mock Reply 로직 정교화
  - `MeetingRepository`의 메시지 쿼리 최적화 (CreatedAt 정렬 등)
- [ ] **Phase C-3-2: UI 디테일 개선**
  - 말풍선 디자인 (나/상대방 구분 명확화)
  - 전송 애니메이션 및 스크롤 바닥 고정 로직 강화
  - 읽음 표시 (1 표시 또는 체크 아이콘) 시각화
- [ ] **Phase C-3-3: 최종 연동 및 검증**
  - `flutter analyze` 0 issues 유지
  - 실제 Windows 환경에서 채팅 시뮬레이션 (답장 오는 것 확인)
  - 메모리 누수 방지 (Polling Timer 적절히 dispose 되는지 확인)
