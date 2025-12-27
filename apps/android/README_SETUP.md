# Oracle 사주 앱 - Android 개발 환경 설정

## 📋 개요
이 문서는 Windows + VS Code + Android Studio 환경에서 Oracle 사주 앱을 실행하기 위한 설정 가이드입니다.

## 🛠 필수 설치 프로그램

### 1. Android Studio
- 다운로드: https://developer.android.com/studio
- 설치 시 **Android SDK**, **Android Virtual Device** 포함 필수
- 권장 버전: Hedgehog (2023.1.1) 이상

### 2. JDK
- Android Studio에 포함된 JDK 사용 (별도 설치 불필요)
- 프로젝트 JDK Target: **11**

## 📂 프로젝트 열기

### Android Studio에서 열기
1. Android Studio 실행
2. **File > Open** 선택
3. `oracle/apps/android` 폴더 선택 (apps/android 폴더를 직접 선택)
4. "Trust Project" 클릭

### VS Code에서 편집 (선택사항)
- VS Code에서 코드 편집 가능
- 빌드/실행은 반드시 Android Studio 사용

## 🔄 Gradle Sync

프로젝트를 열면 자동으로 Gradle Sync가 시작됩니다.

### Sync 실패 시 체크리스트
1. 인터넷 연결 확인
2. **File > Sync Project with Gradle Files** 클릭
3. **File > Invalidate Caches / Restart** 시도
4. `local.properties`에 SDK 경로 확인:
   ```properties
   sdk.dir=C:\\Users\\[사용자명]\\AppData\\Local\\Android\\Sdk
   ```

## 📱 에뮬레이터 설정

### 1. Device Manager 열기
- **View > Tool Windows > Device Manager** 또는 우측 툴바의 📱 아이콘

### 2. 가상 디바이스 생성
1. **Create Device** 클릭
2. **Phone > Pixel 7** (또는 원하는 기기) 선택
3. **Next** 클릭
4. **API 34 (Android 14)** 또는 **API 35** 선택
   - 다운로드 필요 시 "Download" 클릭
5. **Next > Finish**

### 3. 에뮬레이터 실행
- Device Manager에서 ▶ (플레이) 버튼 클릭
- 에뮬레이터가 완전히 부팅될 때까지 대기 (1-2분 소요)

## ▶️ 앱 실행

### 실행 방법
1. 상단 툴바에서 실행할 디바이스 선택 (에뮬레이터 또는 실제 기기)
2. **Run > Run 'app'** 또는 ▶ (녹색 재생) 버튼 클릭
3. **단축키**: `Shift + F10`

### 실행 성공 확인
- 앱이 "사주 입력" 화면으로 시작되면 성공
- Logcat에서 `OracleApplication: Application created` 로그 확인

## 🐛 문제 해결

### Build Failed 에러
```
> Could not resolve all files for configuration ':app:...'
```
- 해결: **File > Sync Project with Gradle Files**

### Emulator 시작 안 됨
- 원인: Hyper-V 또는 HAXM 미설치
- 해결: Android Studio SDK Manager에서 "Intel x86 Emulator Accelerator (HAXM)" 설치

### 앱이 바로 종료됨
- Logcat에서 에러 메시지 확인
- `OracleApplication`이 `AndroidManifest.xml`에 등록되어 있는지 확인

## 📁 프로젝트 구조
```
oracle/apps/android/
├── app/
│   ├── src/main/
│   │   ├── java/com/rsr41/oracle/
│   │   │   ├── core/util/          # 유틸리티
│   │   │   ├── data/local/         # 로컬 저장소
│   │   │   ├── di/                 # 의존성 주입
│   │   │   ├── domain/model/       # 도메인 모델
│   │   │   ├── domain/usecase/     # 유스케이스
│   │   │   ├── repository/         # 저장소
│   │   │   ├── ui/components/      # 재사용 컴포넌트
│   │   │   ├── ui/navigation/      # 네비게이션
│   │   │   ├── ui/screens/         # 화면 + ViewModel
│   │   │   └── ui/theme/           # 테마
│   │   └── AndroidManifest.xml
│   └── build.gradle.kts
├── build.gradle.kts
├── settings.gradle.kts
└── gradle/
```

## 🔗 관련 문서
- [TEST_GUIDE.md](./TEST_GUIDE.md) - 테스트 가이드
- [PROJECT_STATE_ANDROID.md](./PROJECT_STATE_ANDROID.md) - 프로젝트 상태
