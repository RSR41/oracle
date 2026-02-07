# Delta Report: Old vs New Figma Mockup

이 리포트는 `oracle/figma_tools/figma_1`(기존 기준)과 `oracle/figma_mockup/Fortunetellingappdesign-main`(신규 React Mockup)의 차이를 비교분석하여 Flutter 포팅의 명확한 기준을 제시합니다.

## 1. 개요 (Overview)

| 구분 | 기존 기준 (figma_1) | 신규 기준 (Mockup) |
|---|---|---|
| **경로** | `oracle/figma_tools/figma_1` | `oracle/figma_mockup/Fortunetellingappdesign-main` |
| **형식** | 정적 리소스 / JSON 데이터 위주 | **실행 가능한 React App** (Vite + TS) |
| **디자인 토큰** | 기본 색상/폰트 정의 파일 존재 | `theme.css`에 상세 정의된 **Tailwind 기반 토큰** |
| **화면 구성** | 개별 에셋 및 파편화된 구조 | **완전한 라우팅 및 탭 구조** (`App.tsx`) |
| **상호작용** | 없음 (정적 파일) | **Tab Switching, Modal, Flow** 구현됨 |

## 2. 화면 목록 및 라우팅 (Screen & Routing Difference)

신규 Mockup은 **단일 진입점(`App.tsx`)** 을 통해 모든 화면이 유기적으로 연결되어 있습니다. 기존 파일들보다 훨씬 구체적인 "Flow"를 제공합니다.

| 화면 (Tab/Feature) | 기존 (figma_1) | 신규 (Mockup) 및 라우트 | 변경점/구현 필요 |
|---|---|---|---|
| **App Shell** | - | `App.tsx` (Screen Stack 구조) | **스택 기반 네비게이션** 로직 포팅 필요 |
| **Home** | `home_*.json/png` | `Home.tsx` (`/home`) | 요약 카드, 바로가기 그리드 등 레이아웃 구체화 |
| **Fortune** | `fortune_*.json` | `Fortune.tsx` (`/fortune`) | 리스트형 뷰, 카테고리 탭 구현됨 |
| **Compatibility** | `match_*.json` | `Compatibility.tsx` (`/compatibility`) | 파트너 선택 -> 결과 확인(`CompatCheck` -> `CompatResult`) 흐름 명확화 |
| **Face Reading** | `face_*.json` | `FaceReading.tsx` (`/face`) | 업로드/촬영 -> 분석 대기 -> 결과 흐름 |
| **Settings** | - | `Settings.tsx` (`/settings`) | 다크모드 토글, 메뉴 리스트화 |
| **History** | `history_*.json` | `History.tsx` (`/history`) | 타임라인 UI 구현됨 |

## 3. Flutter 포팅 우선순위 (Top 10)

신규 React Mockup의 구조가 훨씬 "앱"에 가깝습니다. 이를 기준으로 Flutter 구조를 재편해야 합니다.

1.  **디자인 토큰 이식 (`theme.css` -> `AppTheme`)**: `Warm/Oracle` 팔레트 적용.
2.  **App Shell 구조 (`ScaffoldWithNavBar`)**: React의 `App.tsx` + `BottomNav.tsx` 구조를 `go_router`의 `ShellRoute`로 구현.
3.  **Home Screen (`Home.tsx`)**: 앱의 첫인상을 결정하는 메인 대시보드.
4.  **Fortune Main (`Fortune.tsx`)**: 핵심 콘텐츠 진입점. 카테고리별 탭/리스트.
5.  **Navigation Logic (`NavState`)**: React의 `screenStack` 로직과 유사한 Flutter의 `NavState` 검증 및 동기화.
6.  **Compatibility Flow (`CompatCheck` -> `CompatResult`)**: 입력과 결과가 분리된 State Flow 구현.
7.  **Sheduler/Calendar (`Calendar.tsx`)**: 만세력 기능 UI (라이브러리 검토 필요).
8.  **Card Components**: `OracleCard` 등 공통 위젯의 스타일 정교화 (Shadow, Gradient).
9.  **Animation**: React `framer-motion` 효과를 Flutter `Animate`로 변환.
10. **Settings (`Settings.tsx`)**: 다크모드 등 전역 상태 제어.

## 4. 결론 (Conclusion)

- **포팅 기준**: 무조건 **신규 Mockup (`oracle/figma_mockup/Fortunetellingappdesign-main`)** 을 기준으로 삼습니다.
- **기존 파일**: `figma_1` 폴더는 텍스트 에셋이나 로직 참고용으로만 사용하고 UI 구조는 신규 Mockup을 따릅니다.
- **실행**: 브라우저 실행 불가 시, 소스 코드(`tsx`)를 "Design Spec"으로 간주하여 1:1로 포팅합니다.
