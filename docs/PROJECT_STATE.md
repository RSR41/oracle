# Project State: Oracle Flutter (Phase 2 Completed)

이 문서는 Phase E-6 및 추가 기능 강화(테마, 온보딩, 만세력 로직 개선) 작업이 완료된 시점의 프로젝트 상태를 확정합니다.

## 근거 데이터 (Evidence)
- **FeatureFlags**: [feature_flags.dart](file:///C:/Users/qkrtj/destiny/oracle/apps/flutter/oracle_flutter/lib/app/config/feature_flags.dart#L1-L33)
- **Beta Navigation 차단**: [scaffold_with_navbar.dart](file:///C:/Users/qkrtj/destiny/oracle/apps/flutter/oracle_flutter/lib/app/navigation/scaffold_with_navbar.dart#L31-L44)
- **라우트 리다이렉션**: [app_router.dart](file:///C:/Users/qkrtj/destiny/oracle/apps/flutter/oracle_flutter/lib/app/navigation/app_router.dart#L65-L205)
- **미팅 히스토리 섹션**: [history_screen.dart](file:///C:/Users/qkrtj/destiny/oracle/apps/flutter/oracle_flutter/lib/app/screens/tabs/history_screen.dart#L215-L260)

---

## 1. 현재 릴리즈 목표 (1차 출시 MVP)
사주(Saju) 서비스를 중심으로 한 안정적인 기능 제공을 목표로 합니다.
- **사주 정보 입력 및 결과 생성**: 사용자의 생년월시 기반 사주 풀이.
- **운세(Fortune) 서비스**: 오늘의 운세, 캘린더, 사주 분석.
- **타로**: 3장 카드 뽑기 및 해석 제공.
- **꿈해몽**: 꿈 내용 입력 후 해석 제공.
- **관상(얼굴 분석)**: 이미지 업로드/촬영 → 결과 텍스트 출력.
- **기록(History) 관리**: 생성된 모든 운세 및 사주 결과의 로컬 저장 및 조회.
- **Profile**: 기본 사용자 정보 관리.

## 2. 동작 확인 완료 (Phase E-6)
- [x] **MVP 기능 5개 항상 노출**:
  - 사주(/fortune-today, /saju-analysis)
  - 만세력(/calendar)
  - 타로(/tarot, /tarot-result)
  - 꿈해몽(/dream, /dream-result)
  - 관상(/face, /face-result)
- [x] **베타 기능 격리**:
  - `FeatureFlags.showBetaFeatures`를 통한 전역 제어.
  - 소개팅 전체(/meeting, /meeting/*) 하단 탭 및 라우트 차단.
  - 이상형 이미지 생성 기능 베타 처리.
  - 라우터 레벨에서 비활성화된 기능 접근 시 `/home`으로 강제 리다이렉트.

## 3. 제한 및 리스크 (Limitations)
- **베타 기능 접근**: `/meeting`, `/connection`, `/ideal-type` 등은 리다이렉션으로 보호되고 있으며, 딥링크를 통한 강제 진입 시에도 홈으로 튕겨나가도록 설계되었습니다.
- **디버그 모드 기본값**: 개발 편의를 위해 `kDebugMode`에서는 베타 기능이 기본적으로 'ON'입니다. 릴리즈 빌드 전 반드시 환경 변수 점검이 필요합니다.

## 4. 미구현/보류 (베타/Next)
- **소개팅(Meeting)**: 핵심 로직은 라이브러리화되어 있으나 UI 및 상세 연동은 1차 출시 제외.
- **이상형 이미지 생성**: 관상 화면 내 이상형 그리기 기능은 베타 처리.
- **LLM 연동**: Template 기반 해석에서 AI 기반 해석으로 전환 예정 (Phase 4+).

## 5. Definition of Done (DoD) 출시 전 최종 점검
1. [x] `BETA_FEATURES=false` 설정 시 모든 베타 진입점이 사라지는가?
2. [ ] 사주 입력부터 결과 저장까지 끊김 없이 작동하는가?
3. [ ] 히스토리에서 저장된 데이터가 정확히 복원되는가?
4. [x] 하단 4개 탭(Home, Fortune, History, Profile)의 네비게이션이 정확한가?
5. [ ] 릴리즈 빌드 시 아이콘 및 스플래시 이미지가 적용되어 있는가?
6. [ ] 네트워크 단절 시에도 로컬 DB(SQLite) 조회가 가능한가?
7. [x] 비정상적인 경로(/meeting 등) 진입 시 홈으로 정상 리다이렉트 되는가?
8. [ ] 다국어(i18n) 대응이 모든 화면에서 누락 없이 적용되었는가?
9. [x] `flutter analyze` 결과가 No issues인가?
10. [ ] 릴리즈 모드 성능이 60fps를 유지하는가?
