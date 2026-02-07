# Source of Truth & Rules

폴더 간 혼동을 방지하고 작업의 일관성을 유지하기 위한 절대 규칙입니다.

## 0. 작업 루트
- **Repo Root**: `C:\Users\qkrtj\destiny\oracle`
- **Current Branch**: `flutter-port-from-figma-mockup`

## 1. 폴더별 역할 및 규칙 (Strict Rules)

| 구분 | 경로 | 역할 | 규칙 |
|---|---|---|---|
| **✅ 기준 (Source of Truth)** | `oracle/figma_mockup/Fortunetellingappdesign-main` | React Mockup (UI/UX 스펙) | **수정 최소화**. 디자인/플로우의 정답지로 사용. |
| **✅ 참고 (Reference)** | `oracle/figma_tools/figma_1` | Legacy Resource | **수정 금지** (Read-only). 단순 에셋/텍스트 참고용. |
| **✅ 결과물 (Target)** | `oracle/apps/flutter/oracle_flutter` | Flutter App | **구현 반영 위치**. 모든 코드는 여기에 작성. |

### 절대 규칙
1. `figma_1` 폴더는 **읽기 전용**으로 취급한다.
2. `figma_mockup`과 `figma_1`의 내용이 충돌하면 **Mockup**을 따른다.
3. 실제 구현 코드는 오직 `oracle_flutter` 폴더에만 작성한다.
4. Git 작업은 항상 기능 단위 브랜치(`flutter-port-...`)에서 수행한다.

## 2. 상태 점검 리포트 (Phase 1)

### (A) Git Status
- **Branch**: `flutter-port-from-figma-mockup` (Created & Clean)
- **Status**: Ready for porting work.

### (B) 폴더 확인
- `oracle/figma_mockup/Fortunetellingappdesign-main`: **[존재함]** (node_modules 포함)
- `oracle/figma_tools/figma_1`: **[존재함]**
- `oracle/apps/flutter/oracle_flutter`: **[존재함]** (Flutter Project)

### (C) React Mockup 실행 결과
- **Command**: `npm run dev`
- **Result**: **Success** (Vite Server Started)
- **Log Summary**:
  ```
  > vite dev
  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ```
- **Note**: 시스템 환경 이슈로 브라우저 캡처는 불가하나, 서버 구동 및 코드는 정상임을 확인함. `tsx` 코드를 직접 분석하여 포팅 진행.
