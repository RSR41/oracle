# Oracle iOS 프로젝트 인계 문서

> **작성일**: 2026-01-15  
> **작성 환경**: Windows (VS Code + Antigravity)  
> **대상 환경**: macOS + Xcode 15.0+

---

## 1. 프로젝트 개요

| 항목 | 내용 |
|------|------|
| **저장소** | https://github.com/RSR41/oracle |
| **브랜치** | main |
| **로컬 경로** | `oracle/` (Git clone 위치) |
| **iOS 코드 경로** | `oracle/apps/ios/` |
| **Android 참조** | `oracle/apps/android/app/src/main/java/com/rsr41/oracle/` |
| **목표** | Android 사주 운세 앱과 100% 동일한 iOS 앱 개발 |

---

## 2. 완료된 작업 (Phase 1-4)

### Phase 1: Android 앱 분석 ✅

**폴더 구조 분석 결과:**
| 레이어 | 경로 | 파일 수 | 역할 |
|--------|------|---------|------|
| Domain | `domain/model/` | 11개 | 비즈니스 모델 (BirthInfo, SajuResult 등) |
| Domain | `domain/engine/` | 3개 | 계산 엔진 인터페이스 |
| Domain | `domain/usecase/` | 4개 | UseCase 패턴 |
| Data | `data/engine/` | 1개 | BasicFortuneEngine 구현 |
| Data | `data/local/` | 13개 | Room DB + DataStore |
| Data | `data/repository/` | 3개 | Repository 구현 |
| UI | `ui/screens/` | 19개 | Compose 화면 |
| Core | `core/di/` | 6개 | Hilt DI 모듈 |

**Fortune 기능 상세:**
- **입력 필드**: nickname, date (yyyy-MM-dd), time (HH:mm), gender, calendarType, timeUnknown, isLeapMonth
- **계산 엔진**: `BasicFortuneEngine` - 천간(10개)/지지(12개) 기반 사주 계산
- **결과 출력**: pillars (사주 기둥), elements (오행), luckyColors, luckyNumbers, interpretation
- **저장 방식**: Room (HistoryEntity) + DataStore (PreferencesManager)

**기타 기능 상태:**
| 기능 | Android 상태 | iOS 상태 |
|------|-------------|----------|
| Saju/Fortune | 실제 구현 | ✅ 구현 완료 |
| Tarot | 실제 구현 | 🔜 Placeholder |
| Dream | DB 기반 구현 | 🔜 Placeholder |
| Face | Mock 분석 | 🔜 Placeholder |
| Compatibility | 실제 구현 | 🔜 Placeholder |
| Settings | 실제 구현 | 🔜 Placeholder |

### Phase 2: 크로스플랫폼 아키텍처 설계 ✅

**레이어 구조 표준:**
```
Domain (플랫폼 독립)
├── Entities/      비즈니스 모델
├── UseCases/      비즈니스 로직 (단일 책임)
├── Repositories/  인터페이스 (Protocol)
└── Engines/       계산 엔진

Data (플랫폼 적응)
├── Repositories/  구현체
├── Persistence/   SwiftData
└── Network/       (향후)

Presentation (플랫폼 네이티브)
├── Navigation/    화면 전환
├── Screens/       View + ViewModel
├── Components/    재사용 컴포넌트
└── Theme/         디자인 시스템
```

**네이밍 규칙:**
| 개념 | Android | iOS |
|------|---------|-----|
| Entity | `data class` | `struct` |
| UseCase | `class XxxUseCase` | `struct XxxUseCase` |
| Repository 인터페이스 | `interface XxxRepository` | `protocol XxxRepository` |
| Repository 구현 | `class XxxRepositoryImpl` | `class XxxRepositoryImpl` |
| ViewModel | `class XxxViewModel : ViewModel()` | `class XxxViewModel: ObservableObject` |

### Phase 3-4: iOS 코드 생성 ✅

**생성된 파일 위치:** `oracle/apps/ios/`

**파일 구조:**
```
apps/ios/
├── .gitignore
├── README.md
├── ARCHITECTURE.md
└── OracleIOS/
    ├── App/
    │   ├── OracleIOSApp.swift          # @main 진입점
    │   └── DI/
    │       └── AppContainer.swift      # DI 컨테이너
    │
    ├── Domain/
    │   ├── Entities/
    │   │   ├── Gender.swift            # enum Gender
    │   │   ├── CalendarType.swift      # enum CalendarType
    │   │   ├── BirthInfo.swift         # struct BirthInfo
    │   │   ├── FortuneResult.swift     # struct FortuneResult, Pillar, FourPillars
    │   │   ├── SajuResult.swift        # struct SajuResult (레거시 호환)
    │   │   ├── HistoryType.swift       # enum HistoryType
    │   │   ├── HistoryRecord.swift     # struct HistoryRecord, HistoryItem
    │   │   └── Profile.swift           # struct Profile
    │   ├── Engines/
    │   │   ├── FortuneEngine.swift     # protocol FortuneEngine
    │   │   └── BasicFortuneEngine.swift# 천간지지 계산 구현
    │   ├── Repositories/
    │   │   ├── FortuneRepository.swift # protocol FortuneRepository
    │   │   ├── ProfileRepository.swift # protocol ProfileRepository
    │   │   └── SettingsRepository.swift# protocol SettingsRepository + ThemeMode, AppLanguage
    │   └── UseCases/
    │       ├── CalculateFortuneUseCase.swift
    │       ├── SaveHistoryUseCase.swift
    │       └── GetHistoryUseCase.swift
    │
    ├── Data/
    │   ├── Persistence/
    │   │   ├── Models/
    │   │   │   ├── HistoryModel.swift  # @Model SwiftData
    │   │   │   └── ProfileModel.swift  # @Model SwiftData
    │   │   └── SwiftDataStore.swift    # CRUD 메서드
    │   └── Repositories/
    │       ├── FortuneRepositoryImpl.swift
    │       ├── ProfileRepositoryImpl.swift
    │       └── SettingsRepositoryImpl.swift
    │
    ├── Presentation/
    │   ├── Theme/
    │   │   └── Colors.swift            # Color extension (Warm Beige/Gold)
    │   ├── Components/
    │   │   └── OracleComponents.swift  # OracleButton, OracleCard, etc.
    │   ├── Navigation/
    │   │   └── MainTabView.swift       # TabView + Navigation
    │   └── Screens/
    │       ├── Fortune/
    │       │   ├── FortuneViewModel.swift
    │       │   ├── FortuneInputView.swift
    │       │   └── FortuneResultView.swift
    │       └── History/
    │           └── HistoryView.swift
    │
    └── Resources/
        ├── ko.lproj/
        │   └── Localizable.strings     # 한국어
        └── en.lproj/
            └── Localizable.strings     # 영어
```

**총 31개 Swift 파일 생성됨**

---

## 3. 핵심 파일 요약

### OracleIOSApp.swift (진입점)
```swift
@main
struct OracleIOSApp: App {
    let modelContainer: ModelContainer  // SwiftData 컨테이너
    @StateObject private var container: AppContainer  // DI
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(container)
                .modelContainer(modelContainer)
        }
    }
}
```

### AppContainer.swift (DI)
- 모든 Repository, UseCase, ViewModel 생성 및 관리
- `fortuneViewModel` 프로퍼티로 접근

### BasicFortuneEngine.swift (핵심 계산)
- 천간 10개: 갑을병정무기경신임계
- 지지 12개: 자축인묘진사오미신유술해
- 년주/월주/일주/시주 계산
- 오행 분석 및 해석 생성

### FortuneViewModel.swift
- 입력 상태 관리 (nickname, date, time, gender, calendarType, etc.)
- 검증, 계산, 저장 기능
- `@Published` 프로퍼티로 UI 바인딩

### MainTabView.swift
- 5개 탭: Fortune, Tarot, Dream, Face, Settings
- Fortune 탭만 구현, 나머지는 Placeholder

---

## 4. 맥북에서 해야 할 작업

### 필수 작업
1. ✅ Git pull로 최신 코드 받기
2. ✅ Xcode에서 iOS 프로젝트 생성
3. ✅ 생성된 Swift 파일 프로젝트에 추가
4. ✅ 빌드 및 에러 수정
5. ✅ 시뮬레이터에서 실행 확인

### 선택 작업 (Phase 5-7)
- [ ] 단위 테스트 작성
- [ ] Tarot, Dream, Face, Compatibility 구현
- [ ] Settings 화면 구현
- [ ] 다크 모드 지원

---

## 5. 알려진 이슈 및 주의사항

### 예상되는 빌드 에러
1. **SwiftData @Model 관련**: `HistoryModel`, `ProfileModel`에서 컴파일 에러 가능성
2. **Localizable.strings**: Xcode에서 인식 안 될 수 있음 → 수동 추가 필요
3. **modelContainer 주입**: 뷰 계층에서 누락 시 런타임 에러

### 중요 설정값
- **Minimum Deployment**: iOS 17.0
- **Swift Language Version**: 5.9
- **Use SwiftData**: Yes

---

## 6. 참조 문서

| 문서 | 경로 | 내용 |
|------|------|------|
| README.md | `apps/ios/README.md` | 프로젝트 개요 및 빌드 방법 |
| ARCHITECTURE.md | `apps/ios/ARCHITECTURE.md` | 아키텍처 표준 |
| Android 코드 | `apps/android/app/src/main/java/com/rsr41/oracle/` | 참조용 원본 |

---

**인계자**: Windows Antigravity  
**인수자**: macOS Antigravity  
**인계일**: 2026-01-15
