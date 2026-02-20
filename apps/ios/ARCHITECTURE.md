# Oracle 크로스플랫폼 아키텍처

이 문서는 Oracle 프로젝트의 Android와 iOS 앱에 적용되는 아키텍처 표준을 정의합니다.

## 설계 원칙

1. **플랫폼 독립적 Domain**: 비즈니스 로직은 플랫폼에 의존하지 않음
2. **단일 책임 원칙**: 각 클래스/구조체는 하나의 책임만 가짐
3. **의존성 역전**: 고수준 모듈이 저수준 모듈에 의존하지 않음
4. **테스트 용이성**: 모든 레이어가 모킹 가능한 구조

## 레이어 구조

```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│    (SwiftUI / Compose, ViewModels)      │
├─────────────────────────────────────────┤
│            Domain Layer                 │
│  (Entities, UseCases, Repositories)     │
├─────────────────────────────────────────┤
│             Data Layer                  │
│  (Repository Impl, Persistence, API)    │
└─────────────────────────────────────────┘
```

### Domain Layer (플랫폼 100% 독립)

| 폴더 | 역할 | 예시 |
|------|------|------|
| Entities/ | 비즈니스 모델 | BirthInfo, FortuneResult |
| UseCases/ | 비즈니스 로직 (단일 책임) | CalculateFortuneUseCase |
| Repositories/ | 인터페이스 정의 | FortuneRepository (protocol/interface) |
| Engines/ | 계산/처리 엔진 | FortuneEngine, BasicFortuneEngine |

### Data Layer (플랫폼 적응)

| 폴더 | 역할 | 예시 |
|------|------|------|
| Repositories/ | Repository 구현체 | FortuneRepositoryImpl |
| Persistence/ | 로컬 저장 | SwiftDataStore / Room DAO |
| Network/ | API 클라이언트 | APIClient |
| DTO/ | 데이터 전송 객체 | (필요시) |

### Presentation Layer (플랫폼 네이티브)

| 폴더 | 역할 | 예시 |
|------|------|------|
| Views/Screens/ | UI 화면 | FortuneInputView |
| ViewModels/ | 상태 관리 | FortuneViewModel |
| Navigation/ | 화면 전환 | MainTabView |
| Components/ | 재사용 컴포넌트 | OracleButton |
| Theme/ | 디자인 시스템 | Colors |

## 네이밍 규칙

| 개념 | Android (Kotlin) | iOS (Swift) |
|------|------------------|-------------|
| 비즈니스 모델 | `data class BirthInfo` | `struct BirthInfo` |
| UseCase | `class CalculateFortuneUseCase` | `struct CalculateFortuneUseCase` |
| Repository 인터페이스 | `interface FortuneRepository` | `protocol FortuneRepository` |
| Repository 구현 | `class FortuneRepositoryImpl` | `class FortuneRepositoryImpl` |
| ViewModel | `class FortuneViewModel : ViewModel()` | `class FortuneViewModel: ObservableObject` |
| Engine 인터페이스 | `interface FortuneEngine` | `protocol FortuneEngine` |

## 에러 처리

### iOS
```swift
// async throws 사용
func calculate(birthInfo: BirthInfo) async throws -> FortuneResult
```

### Android
```kotlin
// Kotlin Result 또는 sealed class
suspend fun calculate(birthInfo: BirthInfo): Result<FortuneResult>
```

## 데이터 흐름

```
User Input → View → ViewModel → UseCase → Repository → Engine/DataStore
                                                    ↓
User ← View ← ViewModel ← UseCase ← Repository ← Result
```

## 의존성 주입

### iOS (수동 DI)
```swift
@MainActor
final class AppContainer: ObservableObject {
    lazy var fortuneRepository: FortuneRepository = {
        FortuneRepositoryImpl(...)
    }()
}
```

### Android (Hilt)
```kotlin
@Module
@InstallIn(SingletonComponent::class)
object RepositoryModule {
    @Provides
    fun provideFortuneRepository(...): FortuneRepository
}
```

## Android 개선 권장 사항

Phase 1 분석에서 발견된 iOS 우선 적용 개선 사항:

1. **Repository 분리**: `SajuRepository`를 `FortuneRepository`, `ProfileRepository`, `SettingsRepository`로 분리
2. **UseCase 추가**: ViewModel 로직을 UseCase로 이동
3. **에러 처리 통일**: `sealed class Result<T>` 일관 사용
4. **테스트 추가**: JUnit 테스트 작성
