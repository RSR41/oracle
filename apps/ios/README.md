# Oracle iOS - 사주 운세 앱

Android Oracle 앱의 iOS 버전으로, 동일한 기능과 개선된 아키텍처를 제공합니다.

## 개발 환경

- **Xcode**: 15.0+
- **iOS**: 17.0+
- **Swift**: 5.9+
- **UI**: SwiftUI
- **데이터 저장**: SwiftData
- **비동기**: async/await

## 빌드 및 실행

### Xcode에서 프로젝트 생성

이 코드는 Xcode에서 수동으로 프로젝트를 생성한 후 사용합니다:

1. Xcode → File → New → Project
2. iOS → App 선택
3. Product Name: **OracleIOS**
4. Organization: **com.rsr41**
5. Interface: **SwiftUI**
6. Storage: **SwiftData** (체크)
7. Include Tests: **Yes**
8. 저장 위치: `apps/ios/`
9. 생성된 `ContentView.swift` 삭제
10. `OracleIOS/` 폴더 내 파일들을 프로젝트에 드래그앤드롭

### 빌드

```bash
cd apps/ios
xcodebuild -project OracleIOS.xcodeproj \
           -scheme OracleIOS \
           -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
           build
```

### 테스트

```bash
xcodebuild -project OracleIOS.xcodeproj \
           -scheme OracleIOS \
           -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
           test
```

## 프로젝트 구조

```
OracleIOS/
├── App/
│   ├── OracleIOSApp.swift       # @main 진입점
│   └── DI/
│       └── AppContainer.swift   # 의존성 주입
│
├── Domain/                      # 플랫폼 독립 레이어
│   ├── Entities/                # 비즈니스 모델
│   ├── UseCases/                # 비즈니스 로직
│   ├── Repositories/            # 인터페이스 (Protocols)
│   └── Engines/                 # 계산 엔진
│
├── Data/                        # 플랫폼 적응 레이어
│   ├── Repositories/            # Repository 구현체
│   └── Persistence/             # SwiftData 모델
│
├── Presentation/                # iOS 네이티브 레이어
│   ├── Navigation/              # 화면 전환
│   ├── Screens/                 # 화면별 View/ViewModel
│   ├── Components/              # 재사용 컴포넌트
│   └── Theme/                   # 디자인 시스템
│
└── Resources/                   # 리소스
    ├── ko.lproj/                # 한국어
    └── en.lproj/                # 영어
```

## 기능 매핑 (Android ↔ iOS)

| 기능 | Android | iOS | 상태 |
|------|---------|-----|------|
| 사주 입력 | InputScreen.kt | FortuneInputView.swift | ✅ |
| 사주 결과 | ResultScreen.kt | FortuneResultView.swift | ✅ |
| 히스토리 | HistoryScreen.kt | HistoryView.swift | ✅ |
| 타로 | TarotScreen.kt | PlaceholderView | 🔜 |
| 꿈해몽 | DreamScreen.kt | PlaceholderView | 🔜 |
| 관상 | FaceReadingScreen.kt | PlaceholderView | 🔜 |
| 설정 | SettingsScreen.kt | PlaceholderView | 🔜 |

## 입력 항목 (Fortune)

Android와 동일:
- [x] 생년월일 (yyyy-MM-dd)
- [x] 출생 시간 (HH:mm, 선택)
- [x] 성별 (남/여)
- [x] 달력 타입 (양력/음력)
- [x] 윤달 (음력일 때)
- [x] 프로필 저장 옵션

## 아키텍처 개선 (Android 대비)

| 항목 | Android | iOS 개선 |
|------|---------|----------|
| Repository 분리 | SajuRepository 하나에 모든 기능 | FortuneRepository, ProfileRepository, SettingsRepository 분리 |
| UseCase 활용 | ViewModel에 로직 집중 | UseCase 패턴 적극 활용 |
| DI | Hilt | 수동 DI (AppContainer) |
| 데이터 저장 | Room + DataStore | SwiftData + UserDefaults |

## 향후 계획

- [ ] 단위 테스트 작성
- [ ] Tarot, Dream, Face, Compatibility 기능 구현
- [ ] Settings 화면 구현
- [ ] 다크 모드 지원
