# Oracle Android App

상용 수준의 사주(운세) 앱 - Jetpack Compose + Hilt + MVVM

## 🚀 빠른 시작

### 1. Android Studio에서 열기
```
File > Open > oracle/apps/android 선택
```

### 2. Gradle Sync
```
File > Sync Project with Gradle Files
```

### 3. 실행
에뮬레이터 또는 실기기 선택 후 ▶ Run

---

## 📁 프로젝트 구조

```
com.rsr41.oracle/
├── core/
│   ├── di/          # Hilt DI Modules
│   ├── network/     # Retrofit, ApiResponse
│   └── result/      # Result wrapper
├── data/
│   ├── api/         # API Service
│   ├── dto/         # DTOs
│   ├── local/       # SharedPreferences
│   └── repository/  # Remote Repository
├── domain/
│   ├── model/       # Domain Models
│   └── usecase/     # UseCases
├── repository/      # Local Repository
├── ui/
│   ├── navigation/  # NavHost
│   ├── screens/     # 화면 + ViewModels
│   ├── components/  # 공통 컴포넌트
│   └── theme/       # Material3 Theme
├── MainActivity.kt
└── OracleApplication.kt
```

---

## 🎯 기능

| 기능 | 상태 | 설명 |
|------|------|------|
| 홈 화면 | ✅ | 기능 카드 그리드 |
| 사주 입력 | ✅ | 생년월일/성별/양음력 |
| 결과 화면 | ✅ | Mock 사주 결과 |
| 히스토리 | ✅ | 최근 10개 저장 |
| 설정 | ✅ | 기본 달력 설정 |
| 만세력/대운 | ✅ | 탭 UI (대운/세운/월운) |
| 궁합 | ✅ | 프로필 선택 UI |
| 관상 | ✅ | 사진 업로드 UI |
| 타로 | ✅ | 카드 선택 UI |

---

## 🔧 기술 스택

- **Kotlin** + **Jetpack Compose** + **Material3**
- **Hilt** DI
- **Retrofit** + **Kotlinx Serialization**
- **DataStore** / SharedPreferences
- **Timber** 로깅

---

## 📝 백엔드 연동

`app/build.gradle.kts` 또는 `local.properties`에서 API URL 설정:
```properties
API_BASE_URL=https://your-api.example.com
```

---

## 🐛 문제 해결

```powershell
# 레포 루트에서 빌드 검증 실행
.\tools\verify_android.ps1
```

자세한 내용: [DEBUG_PLAYBOOK_ANDROID.md](../../docs/DEBUG_PLAYBOOK_ANDROID.md)

---

## 📄 라이센스

MIT License
