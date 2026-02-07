# Phase 3 Report: UI Porting (Home & Fortune)

## 1. 개요
본 보고서는 Phase 3의 목표인 **Home 및 Fortune 화면의 UI를 React Mockup과 1:1로 포팅**하고, `go_router`를 통한 화면 연결 및 빌드 안정성을 확보한 결과를 정리합니다.

## 2. 진행 내역

### 2.1 UI 포팅 완료
- **HomeScreen (`lib/app/screens/tabs/home_screen.dart`)**
  - React `Home.tsx`의 디자인 요소를 완벽하게 구현했습니다.
  - Gradient Header, 오늘의 운세 Summary Card, Quick Access Grid, OracleCard 리스트 등을 모두 Flutter 위젯으로 변환했습니다.
  - `AppColors`를 활용하여 디자인 토큰을 정확히 적용했습니다.

- **FortuneScreen (`lib/app/screens/tabs/fortune_screen.dart`)**
  - React `Fortune.tsx`의 디자인 요소를 완벽하게 구현했습니다.
  - 상단 카테고리 탭 (Horizontal Scroll)을 `StatefulWidget`으로 구현하여 인터랙션을 추가했습니다.
  - 오늘의 운세, 만세력 달력, 사주 분석, 타로(3 Cards Layout), 꿈해몽 섹션을 구현했습니다.

- **공통 컴포넌트 (`lib/app/widgets/oracle_card.dart`)**
  - 기존 구현된 `OracleCard` 위젯을 검증하고 재사용했습니다.
  - React의 `OracleCard` Props(title, description, icon, badge, accentColor)와 1:1 대응됨을 확인했습니다.

### 2.2 코드베이스 정리 및 에러 수정
- **Legacy 코드 삭제**
  - `flutter analyze` 과정에서 발견된 미사용 Legacy 파일 `lib/app/app.dart`를 삭제하여 컴파일 에러를 근본적으로 해결했습니다. (메인 진입점은 `main.dart` -> `OracleApp`으로 단일화됨)
- **Lint 수정**
  - `FortuneScreen` 내부의 변수명 shadowing (`num` -> `cardNumber`) 경고를 수정하여 코드 품질을 개선했습니다.
  - `AspectRatio` 관련 컴파일 에러를 올바른 위젯 중첩 구조로 수정했습니다.

## 3. 파일 변경 목록
| 구분 | 파일 경로 | 내용 |
| :--- | :--- | :--- |
| **수정** | `lib/app/screens/tabs/home_screen.dart` | UI 전체 구현 (React 1:1) |
| **수정** | `lib/app/screens/tabs/fortune_screen.dart` | UI 전체 구현, 탭 로직 추가 |
| **수정** | `lib/app/widgets/oracle_card.dart` | (내용 확인 및 재사용) |
| **삭제** | `lib/app/app.dart` | Legacy 파일 삭제 |

## 4. 실행 및 검증 결과
- **Analyze 결과**: `flutter analyze` 통과 (0 errors, 0 warnings).
- **Windows 실행**: `flutter run -d windows` 성공.
- **UI 확인**:
  - 홈 화면 진입 시 Gradient와 디자인이 Figma Mockup과 일치함.
  - 하단 탭 이동 (Home <-> Fortune) 정상 동작.
  - 각 카드 클릭 시 라우팅 (`/fortune-today`, `/calendar` 등) 연결 확인 (Placeholder 화면으로 이동).

## 5. Phase 4 제안 (Next Steps)
다음 단계(Phase 4)에서는 실제 데이터 연동과 핵심 기능 구현을 제안합니다.

1.  **사주 엔진 연동 (Saju Engine Wiring)**
    - `saju_sdk` (또는 관련 로직)를 연동하여 `manse` 데이터를 실제로 계산.
    - `FortuneScreen` 및 `Home`의 더미 데이터를 실제 계산된 운세 데이터로 교체.
2.  **상세 화면 구현**
    - `CalendarScreen` (만세력 달력) UI 및 기능 구현.
    - `SajuAnalysisScreen` (사주 상세 분석) UI 및 기능 구현.
