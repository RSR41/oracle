# Flutter Repository Structure: Oracle & Meeting

이 문서는 `oracle/apps/flutter/` 하위에 위치한 두 핵심 프로젝트의 구조와 상호 관계를 설명합니다.

---

## 1. 개요 (Overview)

| 프로젝트명 | 경로 | 역할 |
| :--- | :--- | :--- |
| **oracle_flutter** | `apps/flutter/oracle_flutter` | 사주(Saju) 서비스를 제공하는 메인 어플리케이션 |
| **oracle_meeting** | `apps/flutter/oracle_meeting` | 사주 기반 소개팅(Matching) 기능을 담당하는 라이브러리/모듈 |

> [!NOTE]
> `oracle_flutter`는 `oracle_meeting`을 로컬 패키지 의존성(`path: ../oracle_meeting`)으로 참조하여 소개팅 기능을 통합합니다.

---

## 2. oracle_flutter (Main App)
사주 입력, 운세 분석, 결과 히스토리 관리 등 앱의 전반적인 UI와 로직을 포함합니다.

### 📁 Directory Map
```text
lib/
├── main.dart             # 앱 엔트리 포인트 (AppState 초기화)
└── app/
    ├── config/           # 기능 토글(FeatureFlags), 상수 등 설정
    ├── database/         # SQLite(HistoryRepository) 관련 로직
    ├── i18n/             # 다국어(JSON) 지원 엔진
    ├── models/           # 데이터 모델 (FortuneResult, UserProfile 등)
    ├── navigation/       # 라우팅 시스템 (GoRouter, ScaffoldWithNavBar)
    ├── screens/          # 주요 화면 (Home, Fortune, History, Profile)
    ├── services/         # 비즈니스 로직 (FortuneService 등)
    ├── state/            # 전역 상태 관리 (AppState, Provider)
    ├── theme/            # 디자인 시스템 (AppColors, Typography)
    └── widgets/          # 재사용 가능한 UI 컴포넌트
```

---

## 3. oracle_meeting (Feature Library)
사주 매칭 및 사용자 간의 커넥션을 담당하는 독립적인 기능 모듈입니다.

### 📁 Directory Map
```text
lib/
├── meeting.dart          # 라이브러리 외부 노출 인터페이스
└── src/
    ├── models/           # 소개팅 전용 모델 (MatchCandidate, Message)
    ├── repository/       # 매칭 데이터 저장소 (로컬/리모트 추상화)
    ├── screens/          # 소개팅 관련 화면 (CandidateList, Chatting)
    ├── services/         # 매칭 알고리즘 및 서비스 로직
    └── widgets/          # 소개팅 전용 UI 컴포넌트
```

---

## 4. 구조적 특징 및 데이터 흐름

### (1) 의존성 방향
`oracle_flutter (App)` → `oracle_meeting (Library)`
- 앱 레벨에서 소개팅 탭을 열 때 `oracle_meeting`의 화면이나 서비스를 호출합니다.
- `FeatureFlags.showBetaFeatures` 값에 따라 앱 내 진입점이 동적으로 노출/차단됩니다.

### (2) 데이터 공유
- **사주 정보**: 메인 앱(`AppState`)에 저장된 사용자의 사주 데이터를 `oracle_meeting` 서비스의 입력값으로 활용합니다.
- **결과 로그**: 소개팅 결과나 매칭 내역은 `oracle_flutter`의 `HistoryRepository`를 통해 메인 앱의 히스토리 탭에 통합 저장될 수 있습니다.

---

## 5. 향후 확장 계획
- **모듈화**: 관상(Face Reading)이나 타로(Tarot) 기능도 `oracle_meeting`처럼 별도 패키지로 분리하여 메인 앱의 비대화를 방지할 예정입니다.
- **테스트**: `oracle_meeting`은 독립적인 테스트 코드를 `test/` 폴더에서 운영하여 라이브러리로서의 안정성을 확보합니다.
