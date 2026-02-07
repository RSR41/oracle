# FIGMA_MOCKUP_INVENTORY.md

본 문서는 `oracle/figma_mockup` (실제 루트: `Fortunetellingappdesign-main`) 프로젝트의 현 상태를 조사한 증거 기반 인벤토리입니다. 모든 정보는 소스 코드 및 설정 파일의 확정적 내용에 기초합니다.

---

## 1. 프로젝트 개요 (팩트 기반)

- **프레임워크**: React 18.3.1 (package.json:L51)
- **빌드 도구**: Vite 6.3.5 (package.json:L74)
- **스타일링**: Tailwind 4.1.12 (package.json:L72), @tailwindcss/vite 플러그인 사용 (vite.config.ts:L11)
- **주요 라이브러리**:
  - `motion` (구 framer-motion) v12.23.24: 애니메이션 처리 (package.json:L49)
  - `lucide-react`: 아이콘 세트 (package.json:L48)
  - `radix-ui`: UI 기본 컴포넌트 (package.json:L16-41)
- **엔트리 포인트**: `src/main.tsx` (App 초기화), `src/app/App.tsx` (메인 레이아웃 및 라우팅)

---

## 2. 라우팅 구조 확정

### 2-1) 라우터 방식
- **방식**: `react-router-dom`을 사용하지 않고, `useState` 기반의 **Custom Screen Stack** 방식을 사용함.
- **핵심 로직**: `src/app/App.tsx:L39-74`
  - `activeTab`: 하단 네비게이션 탭 상태 관리
  - `screenStack`: 화면 전환 이력(Stack) 관리 (`handleNavigate`, `handleBack` 메서드)

### 2-2) Route(Screen) 매핑 테이블 (상태 기반)
| Screen Name | 컴포넌트 | 파일 경로 | 진입 조건/트리거 | 근거 |
|---|---|---|---|---|
| home | Home | `src/app/screens/Home.tsx` | 기본 탭 (initialLocation) | App.tsx:L40,80 |
| fortune | Fortune | `src/app/screens/Fortune.tsx` | 하단 탭 클릭 | App.tsx:L83 |
| compatibility | Compatibility | `src/app/screens/Compatibility.tsx` | 하단 탭 클릭 | App.tsx:L86 |
| history | History | `src/app/screens/History.tsx` | 하단 탭 클릭 | App.tsx:L89 |
| profile | Profile | `src/app/screens/Profile.tsx` | 하단 탭 클릭 | App.tsx:L92 |
| chat | Chat | `src/app/screens/Chat.tsx` | 매칭 완료 후 진입 | App.tsx:L113 |
| fortune-today | FortuneToday | `src/app/screens/FortuneToday.tsx` | 홈 화면 카드 클릭 | App.tsx:L117 |

*(기타 25개 화면이 App.tsx의 switch-case문에 매핑되어 있음)*

---

## 3. 화면(Screen) 인벤토리

전체 25개의 화면 컴포넌트가 `src/app/screens/`에 존재합니다.

| Screen ID | Screen Name | 파일 경로 | 데이터 소스 | 사용자 액션 (주요) | 근거 |
|---|---|---|---|---|---|
| Home | 홈 | `src/app/screens/Home.tsx` | AppContext / i18n | 카드 클릭 -> 상세 이동 | Home.tsx:L58, L80 |
| Fortune | 운세 메인 | `src/app/screens/Fortune.tsx` | 하드코딩 / i18n | 카테고리 탭 변경 | Fortune.tsx:L25 |
| History | 기록 | `src/app/screens/History.tsx` | UNKNOWN | 목록 필터링, 상세 보기 | History.tsx |
| Onboarding | 온보딩 | `src/app/screens/Onboarding.tsx` | Local State | 정보 입력 후 완료 | App.tsx:L178 |
| Chat | 채팅 | `src/app/screens/Chat.tsx` | Mock (배열) | 메시지 입력 및 전송 | Chat.tsx |

---

## 4. 컴포넌트(Component) 인벤토리

### 4-1) 주요 재사용 컴포넌트
| Component | 파일 경로 | 역할 | 주요 Props | 근거 |
|---|---|---|---|---|
| BottomNav | `src/app/components/BottomNav.tsx` | 하단 탭 바 | `activeTab`, `onTabChange` | BottomNav.tsx:L5 |
| OracleCard | `src/app/components/OracleCard.tsx` | 카드 레이아웃 | `title`, `description`, `icon`, `onClick` | OracleCard.tsx:L5 |
| PlaceholderScreen | `src/app/components/PlaceholderScreen.tsx` | 미구현 화면 대체 | `title`, `icon`, `onBack` | PlaceholderScreen.tsx:L5 |

### 4-2) UI 원자 컴포넌트 (shadcn/ui 기반)
- 위치: `src/app/components/ui/`
- 개수: 48개 (accordion, button, card, input, tabs 등)
- 근거: `src/app/components/ui/` 디렉토리 리스트

---

## 5. 디자인 시스템/토큰 (포팅 데이터)

### 5-1) 핵심 토큰 (DESIGN_TOKENS.md 기반)
| Token Type | Name | Value | 근거 |
|---|---|---|---|
| Color (Primary) | primary | `#8B6F47` | DESIGN_TOKENS.md:L8 |
| Color (Bg) | background-light | `#FDFBF8` | DESIGN_TOKENS.md:L18 |
| Typography | base | 16px (1rem) | DESIGN_TOKENS.md:L47 |
| Radius | lg | 16px (1rem) | DESIGN_TOKENS.md:L81 |
| Shadow | md | `0 4px 6px -1px rgb(0 0 0 / 0.1)` | DESIGN_TOKENS.md:L91 |

### 5-2) Runtime CSS 테마 (theme.css)
- CSS 변수를 통해 Light/Dark 모드 지원 (theme.css:L3-121)
- 예: `--primary: #8B6F47` (Light), `--primary: #C4A574` (Dark)

---

## 6. 사용자 플로우 분석

1. **초기 진입 플로우**
   - Onboarding (src/app/screens/Onboarding.tsx) -> [onComplete] -> Home (src/app/screens/Home.tsx)
   - 근거: `App.tsx:L177-178`
2. **Tab 전환 플로우**
   - BottomNav 클릭 -> [onTabChange] -> setActiveTab -> renderScreen(switch-case)
   - 근거: `App.tsx:L185`, `L71-74`
3. **상세 정보 확인 플로우**
   - Home 카드 클릭 -> [onNavigate] -> setScreenStack (push) -> 상세 화면 노출
   - 근거: `App.tsx:L44-57`

---

## 7. Flutter 포팅 관점 체크리스트

| 항목 | 상태 | 근거 | 포팅 리스크 |
|---|---|---|---|
| 애니메이션 | Yes | `motion/react` 사용 (Home.tsx:L15) | Flutter `AnimationController` 전환 필요 |
| i18n | Yes | `useApp().t` 호출 (Home.tsx:L22) | `Translations` 클래스 연동 필요 |
| 로컬 데이터 | Yes | `AppContext` 사용 | `SharedPreferences` 또는 `Provider` 연동 필요 |
| 다크 모드 | Yes | `dark` variant (theme.css:L1) | Flutter `ThemeData` 전환 필요 |
| 외부 API | No | Mock 데이터 기반 | 현재는 데이터가 정적이어서 리스크 낮음 |

---

## 8. 최종 요약

- **총 화면 수**: 25개
- **총 재사용 컴포넌트 수**: 4개 (UI 원자 컴포넌트 48개 제외)
- **가장 중요한 파일 TOP 3**:
  1. `src/app/App.tsx`: 시스템 라우팅 및 상태 관리의 심장
  2. `DESIGN_TOKENS.md`: 디자인 시스템의 기준점
  3. `src/app/contexts/AppContext.tsx`: 글로벌 데이터 관리 로직

**추가 확인 필요 사항**:
- 실제 데이터 영속성(Persistence) 여부 및 `AppContext.tsx` 상세 로직 확인.
