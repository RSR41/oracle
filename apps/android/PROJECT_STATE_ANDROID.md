# Oracle 사주 앱 - Android 프로젝트 상태

## 📊 현재 상태
**버전**: 1.0.0-MVP  
**마지막 업데이트**: 2024-12-27  
**상태**: ✅ MVP 완료

## 🎯 MVP 범위

### 완료된 기능 ✅
| 기능 | 상태 | 설명 |
|------|------|------|
| InputScreen | ✅ | 생년월일, 시간, 성별, 달력유형 입력 |
| ResultScreen | ✅ | Mock 사주 결과 표시 |
| HistoryScreen | ✅ | 최근 10개 조회 내역 관리 |
| SettingsScreen | ✅ | 기본 달력 유형 설정 |
| 입력 유효성 검증 | ✅ | yyyy-MM-dd, HH:mm 형식 검증 |
| 데이터 저장 | ✅ | SharedPreferences + JSON |
| MVVM 아키텍처 | ✅ | ViewModel 분리 |
| 에러 핸들링 | ✅ | JSON 파싱 실패 시 안전 복구 |
| 로깅 | ✅ | 주요 이벤트 Logcat 출력 |

### MVP 제외 항목 (추후 구현)
| 기능 | 우선순위 | 비고 |
|------|----------|------|
| 실제 사주 계산 엔진 | 높음 | 별도 모듈로 개발 예정 |
| DatePicker/TimePicker | 중간 | 현재 텍스트 입력 사용 |
| 결과 공유 기능 | 낮음 | - |
| 다크모드 전환 | 낮음 | 시스템 설정 따름 |
| 다국어 지원 | 낮음 | 현재 한국어만 |

## 📁 파일 구조

```
com.rsr41.oracle/
├── core/
│   └── util/
│       ├── ValidationUtil.kt      # 입력 검증
│       └── DateTimeUtil.kt        # 날짜/시간 포맷
├── data/
│   └── local/
│       └── PreferencesManager.kt  # SharedPreferences 관리
├── di/
│   └── AppContainer.kt            # 의존성 주입 컨테이너
├── domain/
│   ├── model/
│   │   ├── BirthInfo.kt
│   │   ├── CalendarType.kt
│   │   ├── Gender.kt
│   │   ├── HistoryItem.kt
│   │   └── SajuResult.kt
│   └── usecase/
│       └── BuildMockSajuUseCase.kt # Mock 결과 생성
├── repository/
│   ├── SajuRepository.kt          # 인터페이스
│   └── SajuRepositoryImpl.kt      # 구현체
├── ui/
│   ├── components/
│   │   ├── SectionCard.kt
│   │   └── SelectableChipRow.kt
│   ├── navigation/
│   │   ├── NavGraph.kt
│   │   └── Routes.kt
│   ├── screens/
│   │   ├── InputScreen.kt
│   │   ├── InputViewModel.kt
│   │   ├── ResultScreen.kt
│   │   ├── ResultViewModel.kt
│   │   ├── HistoryScreen.kt
│   │   ├── HistoryViewModel.kt
│   │   ├── SettingsScreen.kt
│   │   └── SettingsViewModel.kt
│   └── theme/
│       ├── Color.kt
│       ├── Theme.kt
│       └── Type.kt
├── MainActivity.kt
└── OracleApplication.kt
```

## 🔧 기술 스택
- **언어**: Kotlin
- **UI**: Jetpack Compose + Material3
- **아키텍처**: MVVM + Repository Pattern
- **DI**: 수동 주입 (AppContainer)
- **저장소**: SharedPreferences + org.json
- **네비게이션**: 커스텀 상태 기반 (라이브러리 없음)
- **타겟 SDK**: 35
- **최소 SDK**: 26 (Android 8.0)

## 📝 다음 작업 (TODO)

### 높은 우선순위
1. **실제 사주 계산 엔진 연동**
   - `CalculateRealSajuUseCase` 구현
   - 천간지지 계산 로직
   - 음력/양력 변환

2. **DI 개선**
   - Hilt 도입 검토
   - 테스트 용이성 향상

### 중간 우선순위
3. **UI/UX 개선**
   - DatePickerDialog 적용
   - TimePickerDialog 적용
   - 애니메이션 추가

4. **테스트 코드 작성**
   - ValidationUtil 단위 테스트
   - ViewModel 테스트
   - UI 테스트

### 낮은 우선순위
5. **추가 기능**
   - 결과 이미지 저장/공유
   - 위젯 제공
   - 알림 기능

## 🔗 관련 문서
- [README_SETUP.md](./README_SETUP.md) - 개발 환경 설정
- [TEST_GUIDE.md](./TEST_GUIDE.md) - 테스트 가이드

## 📞 문의
- 이슈: GitHub Issues 활용
- 코드 리뷰: PR 요청
