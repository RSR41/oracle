# Oracle Android App - Debug Playbook

## 빌드 에러 발생 시 대처법

### 1. 로그 제출 규칙

에러 발생 시 다음 정보를 함께 제공해주세요:

```
1. 에러 메시지 전문 (스크린샷 또는 텍스트)
2. 어떤 작업을 하다가 발생했는지 (Sync, Build, Run 등)
3. `logs/android_verify.log` 파일 내용 (있다면)
```

---

## 2. 흔한 에러 및 해결법

### JAVA_HOME 관련

```
ERROR: JAVA_HOME is set to an invalid directory
```

**해결:**
1. Android Studio 열기
2. File > Settings > Build, Execution, Deployment > Build Tools > Gradle
3. "Gradle JDK"를 Android Studio 내장 JDK로 변경
4. 또는 환경변수 JAVA_HOME 설정

---

### SDK 위치 에러

```
SDK location not found
```

**해결:**
`apps/android/local.properties` 파일 생성:
```properties
sdk.dir=C:\\Users\\YOUR_USERNAME\\AppData\\Local\\Android\\Sdk
```

---

### Unresolved reference

```
Unresolved reference: SomeClass
```

**해결:**
1. 해당 클래스의 import 확인
2. `File > Sync Project with Gradle Files`
3. `Build > Clean Project` 후 다시 빌드

---

### Could not resolve dependency

```
Could not resolve com.google.dagger:hilt-android:2.51.1
```

**해결:**
1. 인터넷 연결 확인
2. `File > Invalidate Caches / Restart`
3. VPN 사용 시 끄고 다시 시도

---

### KSP / KAPT 에러

```
ksp could not find kapt
```

**해결:**
`app/build.gradle.kts`에서 ksp 플러그인 확인:
```kotlin
plugins {
    alias(libs.plugins.ksp)
}
```

---

## 3. 디버깅 체크리스트

- [ ] Android Studio 최신 버전 사용 중인가?
- [ ] Gradle Sync 성공했는가?
- [ ] `local.properties`에 SDK 경로가 있는가?
- [ ] 인터넷 연결이 안정적인가?
- [ ] `File > Invalidate Caches` 시도했는가?

---

## 4. 로그 수집 명령어

```powershell
# 레포 루트에서 실행
.\tools\verify_android.ps1

# 로그 확인
Get-Content .\logs\android_verify.log
```

---

## 5. 도움 요청 시

위 정보를 모두 확인한 후에도 해결이 안 되면, 다음과 함께 질문해주세요:

1. 전체 에러 로그
2. 수정했던 파일 목록
3. 시도했던 해결책
