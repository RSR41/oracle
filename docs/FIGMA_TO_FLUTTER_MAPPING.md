# docs/FIGMA_TO_FLUTTER_MAPPING.md

## A. 범위와 원칙
- 목표: `figma_mockup`(React)의 화면/컴포넌트/토큰/내비게이션을 `oracle_flutter`(Flutter)의 Route/Widget/Theme/State로 **1:1 대응표**화.
- 비목표: 실제 구현, 리팩터링, 신규 아키텍처 설계 확정.

## B. 프로젝트 연결 구조 (확정 근거 포함)
1) **React 쪽 화면 전환 방식**: `useState` 기반의 커스텀 `screenStack` 사용 (LIFO 구조).
   - 증거: `src/app/App.tsx:L39-40`, `L44-74`
2) **Flutter 쪽 라우팅**: `go_router`를 이용한 선언적 라우팅 및 `ShellRoute` 기반 탭 시스템.
   - 증거: `lib/app/navigation/app_router.dart:L36-87`
3) **oracle_meeting 패키지 참조**: `oracle_flutter`의 `pubspec.yaml`에서 로컬 경로로 참조 중.
   - 증거: `oracle_flutter/pubspec.yaml:L51-52`

---

## C. Screen 매핑표 (25개 전수 매핑)

| # | React Screen ID | React 파일 경로 | React 진입 (push) | 핵심 UI 섹션 | 상태/데이터 소스 | Flutter Route Path | Flutter Widget | Flutter 파일 경로 | 상태(EXISTS/NEW/PARTIAL) | Evidence(React:Line) |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | onboarding | Onboarding.tsx | App.tsx:L178 | 입력 폼, 시작 버튼 | Local State | `/onboarding` | `OnboardingScreen` | `lib/app/screens/onboarding/onboarding_screen.dart` | EXISTS | App.tsx:L4 |
| 2 | home | Home.tsx | NavBar/App.tsx:L80 | 오늘 운세 점수, 퀵 메뉴 | AppContext | `/home` | `HomeScreen` | `lib/app/screens/tabs/home_screen.dart` | EXISTS | App.tsx:L5 |
| 3 | fortune | Fortune.tsx | NavBar/App.tsx:L83 | 카테고리 탭, 오늘 한마디 | AppContext | `/fortune` | `FortuneScreen` | `lib/app/screens/tabs/fortune_screen.dart` | EXISTS | App.tsx:L6 |
| 4 | compatibility | Compatibility.tsx | NavBar/App.tsx:L86 | 궁합 카드 리스트 | AppContext | `/compatibility` | `CompatibilityScreen` | `lib/app/screens/tabs/compatibility_screen.dart` | EXISTS | App.tsx:L7 |
| 5 | history | History.tsx | NavBar/App.tsx:L89 | 필터, 기록 리스트 | UNKNOWN | `/history` | `HistoryScreen` | `lib/app/screens/tabs/history_screen.dart` | EXISTS | App.tsx:L8 |
| 6 | profile | Profile.tsx | NavBar/App.tsx:L92 | 유저 정보, 설정 링크 | AppContext | `/profile` | `ProfileScreen` | `lib/app/screens/tabs/profile_screen.dart` | EXISTS | App.tsx:L9 |
| 7 | face | FaceReading.tsx | Home:L127 | 카메라 가이드, 분석 버튼 | UNKNOWN | `/face` | `FaceReadingScreen` | `lib/app/screens/face/face_reading_screen.dart` | EXISTS | App.tsx:L95 |
| 8 | ideal-type | IdealType.tsx | Home/Face | 캐릭터 카드 | UNKNOWN | `/ideal-type` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L98 |
| 9 | connection | Connection.tsx | Home:L100 | 인연 리스트 | oracle_meeting | `/connection` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L101 |
| 10 | settings | Settings.tsx | Profile:L104 | 언어/테마 전환 | AppContext | `/settings` | `SettingsScreen` | `lib/app/screens/stack/settings_screen.dart` | EXISTS | App.tsx:L104 |
| 11 | tarot | Tarot.tsx | Home:L72 | 카드 드로우 애니메이션 | UNKNOWN | `/tarot` | `TarotScreen` | `lib/app/screens/tarot/tarot_screen.dart` | EXISTS | App.tsx:L107 |
| 12 | dream | Dream.tsx | Home:L73 | 텍스트 입력, 분석 버튼 | UNKNOWN | `/dream` | `DreamInputScreen` | `lib/app/screens/dream/dream_input_screen.dart` | EXISTS | App.tsx:L110 |
| 13 | chat | Chat.tsx | Connection/Match | 말풍선, 메시지 입력 | oracle_meeting | `/meeting/chat` | `MeetingChatScreen` | `oracle_meeting/.../meeting_chat_screen.dart` | EXISTS | App.tsx:L113 |
| 14 | fortune-today | FortuneToday.tsx | Home/Fortune | 상세 운세 아이템 | UNKNOWN | `/fortune-today` | `FortuneTodayScreen` | `lib/app/screens/fortune/fortune_today_screen.dart` | EXISTS | App.tsx:L117 |
| 15 | calendar | Calendar.tsx | Home:L70 | 월간 뷰, 일별 운세 | UNKNOWN | `/calendar` | `CalendarScreen` | `lib/app/screens/calendar/calendar_screen.dart` | EXISTS | App.tsx:L120 |
| 16 | compat-check | CompatCheck.tsx | Compatibility | 상대 정보 입력 | UNKNOWN | `/compat-check` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L123 |
| 17 | compat-result | CompatResult.tsx | CompatCheck | 하트 형태 그래프 | UNKNOWN | `/compat-result` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L126 |
| 18 | consultation | Consultation.tsx | Home:L114 | 상담사 리스트 | UNKNOWN | `/consultation` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L129 |
| 19 | profile-edit | ProfileEdit.tsx | Profile | 정보 수정 폼 | AppContext | `/profile-edit` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L132 |
| 20 | premium | Premium.tsx | Profile/Popups | 구독 옵션 리스트 | UNKNOWN | `/premium` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L135 |
| 21 | fortune-detail | FortuneDetail.tsx | History | 저장된 운세 상세 | UNKNOWN | `/fortune-detail` | `FortuneDetailScreen` | `lib/app/screens/fortune/fortune_detail_screen.dart` | EXISTS | App.tsx:L152 |
| 22 | compat-detail | CompatDetail.tsx | History | 저장된 궁합 상세 | UNKNOWN | `/compat-detail` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L155 |
| 23 | tarot-detail | TarotDetail.tsx | History | 저장된 타로 상세 | UNKNOWN | `/tarot-detail` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L158 |
| 24 | dream-detail | DreamDetail.tsx | History | 저장된 꿈해몽 상세 | UNKNOWN | `/dream-detail` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L161 |
| 25 | face-detail | FaceDetail.tsx | History | 저장된 관상 상세 | UNKNOWN | `/face-detail` | `ComingSoonScreen` | `lib/app/screens/coming_soon_screen.dart` | PARTIAL | App.tsx:L164 |

---

## D. Component 매핑표

| # | React Component | React 경로 | Props/Variant | Flutter 대응 Widget | Flutter 구현 전략 | 상태 | Evidence(React:Line) |
|---|---|---|---|---|---|---|---|
| 1 | BottomNav | src/app/components/BottomNav.tsx | activeTab, onTabChange | `ScaffoldWithNavBar` | `BottomNavigationBar` 커스텀 | EXISTS | App.tsx:L3 |
| 2 | OracleCard | src/app/components/OracleCard.tsx | title, icon, onClick | `OracleCard` | `StatelessWidget` (Custom) | EXISTS | Home.tsx:L3 |
| 3 | PlaceholderScreen| src/app/components/PlaceholderScreen.tsx | title, icon | `ComingSoonScreen` | 공통 에러/준비중 위젯 | EXISTS | App.tsx:L29 |
| 4 | Button | src/app/components/ui/button.tsx | size, variant | `ElevatedButton`/`FilledButton` | Theme 기반 확장 | EXISTS | button.tsx |
| 5 | Input | src/app/components/ui/input.tsx | type, placeholder | `TextField`/`TextFormField` | `InputDecorationTheme` | EXISTS | input.tsx |

---

## E. Design Token → Flutter Theme 매핑

| Token Category | React (Token/값) | 사용 위치 예시 | Flutter 수용 위치 | 적용 방법 요약 | Evidence(React:Line) |
|---|---|---|---|---|---|
| Color | primary (`#8B6F47`) | bg-primary | `AppColors.primary` | `ColorScheme.primary`에 할당 | theme.css:L15 |
| Color | background (`#FAF8F3`) | bg-background | `ThemeData.scaffoldBackgroundColor`| 전역 배경색 설정 | theme.css:L7 |
| Typography| base (16px) | text-base | `TextTheme.bodyMedium` | `TextStyle(fontSize: 16)` | theme.css:L4 |
| Radius | md (12px) | rounded-2xl | `BorderRadius.circular(16)` | `cardTheme.shape` | theme.css:L62 |
| Shadow | shadow-md | shadow-md | `BoxShadow` (Custom) | `Decoration` 프리셋 정의 | DESIGN_TOKENS.md:L91 |

---

## F. Navigation/전환/애니메이션 매핑

- **React Motion**: `Home.tsx:L34-63`에서 나타나는 `motion.div` (opacity/y 제어).
- **Flutter 대응**:
  - 화면 전환: `go_router`의 `NoTransitionPage` (현재 기본값) 또는 `MaterialPageRoute`.
  - 위젯 애니메이션: `AnimatedOpacity` + `AnimatedContainer` 또는 `TweenAnimationBuilder`.
  - 증거: `app_router.dart:L50` (NoTransitionPage 사용 중)

---

## G. 구현 우선순위 (Flash 모델용 작업 단위)

1) **작업명**: `ComingSoonScreen` 고도화 (인벤토리 기반)
   - 입력: `PlaceholderScreen.tsx`, `ComingSoonScreen.dart`
   - 출력: `lib/app/screens/coming_soon_screen.dart`
   - 완료 기준: React 목업처럼 아이콘과 커스텀 배경색 지원

2) **작업명**: `IdealType` 화면 레이아웃 포팅
   - 입력: `IdealType.tsx`
   - 출력: `lib/app/screens/stack/ideal_type_screen.dart` (NEW)
   - 완료 기준: `AppRouter`에 `/ideal-type` 실제 위젯 매핑

3) **작업명**: `ProfileEdit` 화면 폼 구현
   - 입력: `ProfileEdit.tsx`
   - 출력: `lib/app/screens/stack/profile_edit_screen.dart` (NEW)
   - 완료 기준: `AppState.saveProfile` 호출 및 뒤로가기 동작

---

## H. Self-check
- [x] 새 파일 생성은 `docs/FIGMA_TO_FLUTTER_MAPPING.md` 1개뿐인가?
- [x] Screen 25개 전부 매핑했는가?
- [x] 각 Screen 행에 Evidence가 최소 1개 이상 있는가?
- [x] 추측 단정 없이 UNKNOWN 처리했는가?
