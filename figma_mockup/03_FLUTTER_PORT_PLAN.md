# Flutter Porting Plan

React 원본 소스(`oracle/figma_mockup/Fortunetellingappdesign-main`)를 Flutter(`oracle/apps/flutter/oracle_flutter`)로 이식하기 위한 계획입니다.

## 0. Project Strategy
- **Target Path**: `oracle/apps/flutter/oracle_flutter` (기존 프로젝트 활용 권장)
- **Reason**: 현재 진행 중인 Flutter 프로젝트 네이밍(`FortuneScreen`, `NavState` 등)이 React 소스와 매우 유사합니다. 새로 만들기보다 기존 코드에 디자인 토큰과 누락된 화면을 "채워넣는" 방식이 효율적입니다.

## 1. Foundation Phase (기반 작업)
1. **Design Token Migration**:
    - `02_DESIGN_TOKENS_FOR_FLUTTER.md` 내용을 `lib/app/theme/app_colors.dart` 및 `app_theme.dart`에 적용.
    - 특히 Semantic Color(`primary`, `background` 등) 외에 `warmCream`, `softBeige` 같은 원본 팔레트를 추가 정의.
2. **Tab Navigation Sync**:
    - React의 `screenStack` 로직이 `NavState`(`nav_state.dart`)와 동일함.
    - `App.tsx`의 `handleNavigate` 로직(탭 스위칭 vs 스택 푸시)이 `NavState.navigate`와 일치하는지 재검증.

## 2. Core Screens (골격 구현)
이미 뼈대가 잡아진 화면(`Home`, `Fortune`) 외에 나머지 탭 화면 포팅.
- [ ] `Compatibility.tsx` → `compatibility_screen.dart`
- [ ] `History.tsx` → `history_screen.dart`
- [ ] `Profile.tsx` → `profile_screen.dart`

## 3. High Priority Features (핵심 기능)
React 소스에서 이미 구현된 로직이 있는 핵심 기능들 포팅.
1. **Fortune Flows**:
    - `FortuneToday.tsx`: 애니메이션 및 카드 UI.
    - `FortuneDetail.tsx`: 상세화면 레이아웃.
2. **Compatibility Flows**:
    - `CompatCheck.tsx` (입력) → `CompatResult.tsx` (결과)
    - 데이터 전달 방식(`Playground` -> `GoRouter extra`) 구현.
3. **Settings & Onboarding**:
    - `Onboarding.tsx`의 단계별 UI 포팅.
    - `Settings.tsx`의 토글 및 메뉴 리스트 포팅.

## 4. Design Polish (디자인 완성도)
- React의 `framer-motion` 애니메이션을 Flutter `Animate` 패키지나 `TweenAnimationBuilder`로 변환.
- `theme.css`의 `shadow`, `border-radius` 정밀 보정.
- 아이콘 교체 (Lucide React → Phosphor Icons or Cupertino/Material mix).

## 5. Mock Data & Logic
- React의 `models/` 폴더 내 더미 데이터를 `lib/app/data/`로 이동.
- 로컬 스토리지 로직(`contexts/AppContext`)을 `shared_preferences` 리포지토리로 변환.
