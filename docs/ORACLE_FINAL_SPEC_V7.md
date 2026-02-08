# Oracle 최종 총정리 명세서 (Final Summary Specification v7)

**최종 수정일**: 2026-02-09
**상태**: Phase 2 (피드백 반영 및 폴리싱) 완료

---

## 1. 최신 개발 현황 (Implemented Features)

### 🎨 테마 및 디자인 (Starry Night Theme)
- **다크 모드**: '별이 빛나는 밤' 테마 적용. 애니메이션 효과가 포함된 별자리 배경과 골드/네이비 색상 조합으로 프리미엄 감성 구현.
- **라이트 모드**: '신비로운 새벽(Mystical Dawn)' 테마 적용. 단순 흰색이 아닌 따뜻한 크림색과 피치/세이지 톤으로 세련된 분위기 유지.
- **애니메이션**: 커스텀 페인터를 활용한 자전/공전/펄스 효과의 별 배경(`StarryBackground`) 구현.

### 🚀 사용자 경험 (UX/Onboarding)
- **온보딩 Flow**: 첫 실행 시 환영 인사와 함께 애니메이션 효과가 포함된 프로필 입력 화면 제공.
- **앱 시작점**: `AppRouter` 및 `AppState`를 통해 최초 실행 여부(`isFirstRun`) 감지 및 자동 리다이렉션.

### 🔮 핵심 운세 기능 (Fortune Services)
- **사주/만세력**: 생년월시 기반 간지 산출 및 일일 운세 점수 시각화.
- **로직 개선**: 만세력 캘린더의 운세 데이터(좋음/보통/조심)를 날짜 기반 시드(Seed)를 사용하여 자연스럽고 불규칙하게 생성되도록 개선.
- **타로/꿈해몽/관상**: 각 기능별 기본 UI 및 결과 출력 로직 완료 (Beta 상태 관리 포함).

### 🛠 인프라 및 설정 (Settings & Infrastructure)
- **히스토리(History)**: SQLite 기반의 로컬 저장소 구축. 사주, 타로, 꿈해몽 결과를 영구 보관.
- **설정(Settings)**: 다국어(한국어/영어), 테마 전환, 법적 고지(이용약관/개인정보처리방침) 인앱 팝업 구현.
- **플랫폼 지원**: Web(Chrome) 환경에서도 DB 에러 없이 실행되도록 예외 처리 완료 (`kIsWeb` 대응).

---

## 2. Oracle 전체 파일 구조도 (Latest Structure)

```text
oracle/
├── apps/
│   ├── flutter/
│   │   ├── oracle_flutter/ (메인 앱 패키지)
│   │   │   ├── assets/              # 이미지, 브랜드 자산 (app_icon, splash)
│   │   │   ├── lib/
│   │   │   │   ├── main.dart        # 앱 진입점 및 Provider 초기화
│   │   │   │   └── app/
│   │   │   │       ├── config/      # API URL, 기능 토글 (FeatureFlags)
│   │   │   │       ├── database/    # SQLite Helper 및 Repository
│   │   │   │       ├── i18n/        # 다국어 번역 파일
│   │   │   │       ├── models/      # 데이터 모델 (SajuProfile, FortuneResult)
│   │   │   │       ├── navigation/  # GoRouter 설정 및 네비게이션 상태
│   │   │   │       ├── screens/     # 각 섹션별 화면 구현
│   │   │   │       │   ├── calendar/   # 만세력 캘린더
│   │   │   │       │   ├── onboarding/ # 초기 온보딩/프로필 입력
│   │   │   │       │   ├── tabs/       # 기본 하단 탭 (Home, Fortune, History, Profile)
│   │   │   │       │   └── (dream, face, tarot, fortune) # 상세 기능별 화면
│   │   │   │       ├── state/       # 전역 상태 관리 (AppState)
│   │   │   │       ├── theme/       # 테마 정의 (AppColors, AppTheme)
│   │   │   │       └── widgets/     # 공통 위젯 (StarryBackground 등)
│   │   │   └── pubspec.yaml         # 의존성 설정
│   │   └── oracle_meeting/          # 소개팅/미팅 라이브러리 (패키지)
│   └── android/                     # (Legacy) 원본 안드로이드 네이티브 앱
├── backend/                         # NestJS 기반 백엔드 (API 서버)
├── docs/                            # 프로젝트 문서화 및 가이드 (v7 포함)
└── figma_mockup/                    # 피그마 디자인 참조 및 handoff 가이드
```

---

## 3. 향후 계획 (Next Steps)

1.  **이미지 교체**: NanoBanana로 생성된 실제 자산(타로 카드, 오행 아이콘 등)을 `assets/`에 배치.
2.  **배포 준비**: 앱 아이콘 및 스플래시 이미지의 최종 적용 및 빌드 테스트.
3.  **베타 해제**: 미팅(소개팅) 기능의 UI 연동 및 LLM 기반 상세 해석 로직 고도화.
4.  **히스토리 고도화**: `assets_and_history_guide.md`에 따라 각 기능별 결과 저장 로직 통합.
