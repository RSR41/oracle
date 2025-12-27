# Oracle 사주 앱 - 테스트 가이드

## 📋 테스트 개요
이 문서는 MVP 기능이 올바르게 동작하는지 확인하기 위한 테스트 체크리스트입니다.

## ✅ 기능 테스트 체크리스트

### 1. 앱 시작 테스트
- [ ] 앱 실행 시 "사주 입력" 화면이 표시됨
- [ ] TopAppBar에 "사주 입력" 제목이 보임
- [ ] 화면이 크래시 없이 로드됨

### 2. 입력 화면 테스트
- [ ] 생년월일 입력 필드가 보임
- [ ] 시간 입력 필드가 보임 (선택사항 표시)
- [ ] 성별 선택 (남성/여성) 라디오 버튼이 동작함
- [ ] 달력 유형 선택 (양력/음력) 라디오 버튼이 동작함
- [ ] "운세 보기" 버튼이 보임
- [ ] "히스토리", "설정" 버튼이 보임

### 3. 입력 유효성 검증 테스트
- [ ] 빈 날짜 입력 시 에러 메시지 표시
- [ ] 잘못된 날짜 형식 (예: 2024-13-01) 입력 시 에러 표시
- [ ] 잘못된 시간 형식 (예: 25:00) 입력 시 에러 표시
- [ ] 시간 비워두기 허용됨 (에러 없음)
- [ ] 올바른 입력 시 결과 화면으로 이동

### 4. 결과 화면 테스트
- [ ] 입력한 생년월일 정보가 표시됨
- [ ] 성별, 달력 유형이 표시됨
- [ ] "사주 기둥" 섹션이 표시됨 (Mock 데이터)
- [ ] "오늘의 총운" 섹션이 표시됨 (Mock 데이터)
- [ ] "다시 입력" 버튼 클릭 시 입력 화면으로 이동
- [ ] "히스토리" 버튼 클릭 시 히스토리 화면으로 이동
- [ ] 뒤로가기(←) 버튼이 동작함

### 5. 히스토리 화면 테스트
- [ ] 조회한 내역이 리스트로 표시됨
- [ ] 최신 항목이 상단에 표시됨
- [ ] 항목 클릭 시 해당 결과 화면으로 이동
- [ ] 항목별 삭제(🗑) 버튼이 동작함
- [ ] 전체 삭제(🗑) 버튼 클릭 시 확인 다이얼로그 표시
- [ ] 전체 삭제 확인 시 모든 항목 삭제됨
- [ ] 빈 히스토리일 때 안내 메시지 표시
- [ ] 뒤로가기(←) 버튼이 동작함

### 6. 히스토리 10개 제한 테스트
- [ ] 10개 이상 조회 시 가장 오래된 항목이 삭제됨
- [ ] 항상 최대 10개까지만 유지됨

### 7. 설정 화면 테스트
- [ ] 기본 달력 설정 섹션이 보임
- [ ] 양력/음력 선택이 동작함
- [ ] 선택 후 입력 화면에서 해당 설정이 기본값으로 적용됨
- [ ] 뒤로가기(←) 버튼이 동작함

### 8. 설정 유지 테스트
- [ ] 설정에서 "음력" 선택
- [ ] 앱 완전 종료 (Recent Apps에서 스와이프)
- [ ] 앱 재실행
- [ ] 입력 화면에서 달력 유형이 "음력"으로 유지됨

### 9. 네비게이션 테스트
- [ ] 입력 → 결과 → 히스토리 → 결과 흐름 정상
- [ ] 시스템 뒤로가기 버튼이 정상 동작
- [ ] 입력 화면에서 뒤로가기 시 앱 종료

## 🔍 Logcat 확인 항목

### 태그 필터
Logcat에서 아래 태그로 필터링하여 로그 확인:
- `OracleApplication`
- `PreferencesManager`
- `InputViewModel`
- `ValidationUtil`
- `BuildMockSajuUseCase`

### 확인할 로그
```
D/OracleApplication: Application created, DI container initialized
D/PreferencesManager: Loaded default calendar type: SOLAR
D/ValidationUtil: Date validation passed: 1990-01-01
D/BuildMockSajuUseCase: Generating mock saju...
D/PreferencesManager: Saved last result: 1703...
D/PreferencesManager: Appended history item: 1703..., total: 1
```

## 🐛 알려진 제한사항

### MVP 범위 제한
- 사주 계산은 Mock 데이터 (실제 천간지지 계산 없음)
- DatePicker/TimePicker는 텍스트 입력으로 대체
- 외부 라이브러리 미사용 (Navigation Compose 등)

### 추후 개선 예정
- 실제 사주 계산 엔진 연동
- DatePicker/TimePicker UI 개선
- 테마 설정 기능
- 결과 공유 기능

## 🧪 단위 테스트 (선택)

### 테스트 파일 위치
```
app/src/test/java/com/rsr41/oracle/
```

### 테스트 실행
```bash
./gradlew test
```

### 주요 테스트 케이스 (구현 예정)
1. `ValidationUtil` - 날짜/시간 검증 로직
2. `PreferencesManager` - 히스토리 10개 제한 로직
3. `BuildMockSajuUseCase` - Mock 결과 생성

## 📱 테스트 환경 권장사항

### 에뮬레이터
- **API Level**: 34 (Android 14) 이상
- **기기**: Pixel 7 또는 유사 크기
- **RAM**: 2GB 이상

### 실제 기기
- **Android 버전**: 8.0 (Oreo) 이상
- **개발자 옵션**: USB 디버깅 활성화
