# Screen Inventory & Navigation

React 프로젝트(`App.tsx`) 분석을 통한 화면 및 라우팅 구조입니다.

## Navigation Structure

이 프로젝트는 React Router(URL 기반) 대신, `App.tsx` 내부 상태(`screenStack`)를 이용한 **스택 기반 네비게이션**을 사용합니다.
Flutter 포팅 시 `go_router`를 사용하여 이를 URL 기반 라우팅으로 변환하거나, `Navigator` 스택을 유지하는 전략이 필요합니다.

### State Management
- `screenStack`: `[{ name: string, data?: any }]` 형태의 스택.
- `activeTab`: 하단 탭 상태 (`home`, `fortune`, `compatibility`, `history`, `profile`).
- `showOnboarding`: 앱 최초 실행 시 온보딩 표시 여부.

## Screen List

| Screen ID (React) | Component | Flutter Route (Proposed) | Description | Params (data) |
|---|---|---|---|---|
| **Main Tabs** | | | | |
| `home` | `Home.tsx` | `/home` | 홈 화면 (오늘의 운세 요약 등) | - |
| `fortune` | `Fortune.tsx` | `/fortune` | 운세 메인 탭 | - |
| `compatibility` | `Compatibility.tsx` | `/compatibility` | 궁합 메인 탭 | - |
| `history` | `History.tsx` | `/history` | 기록 탭 | - |
| `profile` | `Profile.tsx` | `/profile` | 프로필 탭 | - |
| **Features** | | | | |
| `onboarding` | `Onboarding.tsx` | `/onboarding` | 초기 온보딩 | - |
| `face` | `FaceReading.tsx` | `/face` | 관상 분석 기능 | - |
| `ideal-type` | `IdealType.tsx` | `/ideal-type` | 이상형 찾기 결과 | `{ imageUrl, ... }` |
| `connection` | `Connection.tsx` | `/connection` | 인연 찾기 (Beta) | - |
| `settings` | `Settings.tsx` | `/settings` | 설정 화면 | - |
| `tarot` | `Tarot.tsx` | `/tarot` | 타로 카드 뽑기 | - |
| `dream` | `Dream.tsx` | `/dream` | 꿈 해몽 입력 | - |
| `chat` | `Chat.tsx` | `/chat` | 챗봇 상담 | - |
| `fortune-today` | `FortuneToday.tsx` | `/fortune/today` | 오늘의 운세 상세 | - |
| `calendar` | `Calendar.tsx` | `/calendar` | 만세력 달력 | - |
| `consultation` | `Consultation.tsx` | `/consultation` | 전문가 상담 연결 | - |
| `profile-edit` | `ProfileEdit.tsx` | `/profile/edit` | 프로필 수정 | - |
| `premium` | `Premium.tsx` | `/premium` | 프리미엄 구독 | - |
| **Flows** | | | | |
| `compat-check` | `CompatCheck.tsx` | `/compatibility/check` | 궁합 입력/진행 | User Input |
| `compat-result` | `CompatResult.tsx` | `/compatibility/result` | 궁합 결과 | Result Data |
| **Details** | | | | |
| `fortune-detail` | `FortuneDetail.tsx` | `/fortune/:id` | 운세 상세 내역 | `{ id, type, ... }` |
| `compat-detail` | `CompatDetail.tsx` | `/compatibility/:id` | 궁합 상세 내역 | History Item |
| `tarot-detail` | `TarotDetail.tsx` | `/tarot/:id` | 타로 결과 상세 | Tarot Result |
| `dream-detail` | `DreamDetail.tsx` | `/dream/:id` | 꿈 해몽 결과 상세 | Dream Result |
| `face-detail` | `FaceDetail.tsx` | `/face/:id` | 관상 결과 상세 | Face Result |

## Missing / Placeholder Screens
`App.tsx`에서 `PlaceholderScreen`으로 대체된 화면들입니다. Flutter 포팅 시 우선순위를 낮추거나 스켈레톤만 구현해도 됩니다.

- `saju-analysis` (사주 분석)
- `yearly-fortune` (2026년 신년운세)
- `fortune-settings` (운세 설정)
- `connection-settings` (인연 기능 설정)

## Data Flow Notes
- 대부분의 상세 화면은 이전 화면에서 `data` prop으로 전체 객체를 넘겨받습니다.
- Flutter에서는 `GoRouter`의 `extra` 파라미터를 사용하거나, ID 기반으로 다시 Fetch하는 구조로 변경을 고려해야 합니다.
