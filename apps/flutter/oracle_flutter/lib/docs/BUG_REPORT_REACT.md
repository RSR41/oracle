# BUG REPORT (React)

**기준 경로**: `oracle/figma_tools/figma_1`
**분석 일시**: 2026-01-30

## 1. 미구현 화면 호출 (Fatal)
- **증상**: 히스토리 목록에서 아이템 클릭 시 화면이 전환되지 않거나 홈으로 튕김.
- **분석**:
  - `History.tsx:134`: `onNavigate('${item.type}-detail', { id: item.id })` 를 통해 상세 화면으로 이동 시도.
  - `App.tsx`: `renderScreen`의 `switch`문에 `-detail`로 끝나는 케이스가 전혀 없음.
- **영향 범위**: 히스토리 기능 전체 (상세 보기 불가능).

## 2. BottomNav 표시 조건 오류
- **증상**: 특정 화면(관상, 타로, 꿈해몽 등) 진입 시 하단 네비게이션 바가 사라져 홈으로 돌아오기 불편함.
- **분석**:
  - `App.tsx:140`: `['home', 'fortune', 'compatibility', 'history', 'profile'].includes(currentScreen.name)` 조건일 때만 `BottomNav` 렌더링.
  - `face`, `tarot`, `dream`, `chat` 등의 화면은 이 목록에 포함되지 않음.
- **영향 범위**: 사용자 경험(UX) 저해.

## 3. 동적 라우트 파라미터 미활용
- **증상**: 상세 화면으로 이동했더라도(구현되었다 가정 시) 어떤 데이터를 보여줄지 판단하는 로직이 부족할 가능성.
- **분석**:
  - `App.tsx`의 `case 'ideal-type'` (L73) 등 일부만 `data`를 전달받아 사용함.
  - 대부분의 `case`는 `onNavigate`에 전달된 `data`를 무시하고 컴포넌트만 렌더링 중.

## 4. 하드코딩된 색상값 산재
- **증상**: 테마 변경 시 특정 UI 요소의 색상이 동적으로 변하지 않음.
- **분석**:
  - `Compatibility.tsx`, `Fortune.tsx`, `Home.tsx` 등 다수의 파일에서 `bg-[#9DB4A0]`와 같은 Tailwind Arbitrary Value 사용.
- **코드 근거**:
  - `Compatibility.tsx:137`: `<div className="bg-[#9DB4A0] ...">`
  - `FaceReading.tsx:199`: `<div className="bg-[#E9C5B5] ...">`

---

## 5. 재현 시나리오

### 시나리오 1: 히스토리 상세 보기 실패
1. 하단 탭 `히스토리` 클릭
2. 리스트 중 아무 아이템(예: 사주 아이템) 클릭
3. `onNavigate('fortune-detail', ...)` 발생
4. `App.tsx`에서 케이스를 찾지 못해 `default`인 `Home` 화면으로 초기화됨 (또는 아무 변화 없음)

### 시나리오 2: 관상 분석 화면에서 네비게이션 실종
1. 홈 화면에서 `관상` 버튼 클릭
2. 관상 분석 화면(`face`) 진입
3. 하단 `BottomNav`가 사라짐을 확인
4. 뒤로가기 버튼이 없는 경우 앱을 재실행해야 함 (단, `FaceReading`은 `onBack`을 받긴 함)

### 시나리오 3: 테마 변경 시 색상 불일치
1. 설정을 통해 `다크 모드`로 변경
2. 홈 화면 또는 궁합 화면의 카드 배경색 확인
3. `bg-[#9DB4A0]` 등으로 하드코딩된 영역은 여전히 밝은 색상을 유지하여 눈부심 유발

### 시나리오 4: 이상형 생성 데이터 전달 오류
1. 관상 분석 완료 후 `이상형 생성` 클릭
2. `App.tsx`에서 `data`를 `IdealType`에 넘겨주지만, 정작 `tarot`이나 `dream`으로 이동 시에는 `data`가 전달되어도 컴포넌트에서 활용하는 로직이 부재함 (컴포넌트 정의 확인 필요)

### 시나리오 5: 온보딩 무한 반복 가능성
1. 앱 최초 진입 후 온보딩 완료
2. `setShowOnboarding(false)` 호출
3. 앱을 새로고침(또는 재진입) 시 로컬 스토리지 저장이 없어 다시 온보딩이 뜸
- **코드 근거**: `App.tsx:24` `useState(true)` 초기값 고정 및 `useEffect`를 통한 지속성 로직 부재.
