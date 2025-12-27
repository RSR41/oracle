# =====================================================================
# tools/apply_android_all.ps1
# =====================================================================
# Oracle Android 앱 - 전체 파일 자동 생성/업데이트 스크립트
#
# [생성/수정 파일 목록]
# - apps/android/README_SETUP.md
# - apps/android/TEST_GUIDE.md
# - apps/android/PROJECT_STATE_ANDROID.md
# - apps/android/app/build.gradle.kts
# - apps/android/app/src/main/AndroidManifest.xml
# - apps/android/app/src/main/java/com/rsr41/oracle/OracleApplication.kt
# - apps/android/app/src/main/java/com/rsr41/oracle/di/AppModule.kt
# - apps/android/app/src/main/java/com/rsr41/oracle/data/local/PreferencesManager.kt
# - apps/android/app/src/main/java/com/rsr41/oracle/data/remote/ApiService.kt
# - apps/android/app/src/main/java/com/rsr41/oracle/data/remote/dto/*.kt
# - apps/android/app/src/main/java/com/rsr41/oracle/data/repository/OracleRepository.kt
# - apps/android/app/src/main/java/com/rsr41/oracle/ui/MainActivity.kt
# - apps/android/app/src/main/java/com/rsr41/oracle/ui/navigation/NavGraph.kt
# - apps/android/app/src/main/java/com/rsr41/oracle/ui/screens/*.kt
# - apps/android/app/src/main/java/com/rsr41/oracle/ui/components/CommonComponents.kt
# - apps/android/app/src/main/res/values/strings.xml
#
# [실행 방법]
# 1. 레포 루트(oracle/)에서 PowerShell 실행
# 2. .\tools\apply_android_all.ps1
# 3. Android Studio에서 apps/android 프로젝트 열기
# 4. Gradle Sync
# 5. 에뮬레이터/실기기 실행
#
# [Android Studio 프로젝트가 없을 때]
# - apps/android/README_SETUP.md 참조
# - Android Studio에서 Empty Compose Activity 생성 후 이 스크립트 재실행
# =====================================================================

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$repoRoot = Get-Location
$androidRoot = Join-Path $repoRoot "apps\android"

Write-Host "Oracle Android 파일 생성 시작..." -ForegroundColor Green

# 디렉토리 생성 함수
function Ensure-Directory {
    param([string]$path)
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

# 파일 작성 함수
function Write-FileUTF8 {
    param(
        [string]$path,
        [string]$content
    )
    Ensure-Directory (Split-Path $path -Parent)
    [System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
    Write-Host "생성: $path" -ForegroundColor Cyan
}

# =====================================================================
# README_SETUP.md
# =====================================================================
$readmeSetup = @"
# Oracle Android 앱 - 초기 설정 가이드

## 1. Android Studio 프로젝트 생성 (처음 한 번만)

현재 ``apps/android/``에는 프로젝트가 없습니다. 다음 순서로 생성하세요:

### 1.1 Android Studio 실행
- Android Studio Ladybug 이상 권장
- JDK 17 이상 필요

### 1.2 New Project 생성
1. **File → New → New Project**
2. **Empty Activity** 선택 (Compose 옵션 체크)
3. 설정:
   - Name: ``Oracle``
   - Package name: ``com.rsr41.oracle`` (변경 시 코드 수정 필요)
   - Save location: ``<레포루트>/apps/android``
   - Language: ``Kotlin``
   - Minimum SDK: ``API 26 (Android 8.0)``
   - Build configuration language: ``Kotlin DSL``
4. **Finish** 클릭

### 1.3 패키지명 변경이 필요한 경우
- ``com.rsr41.oracle``을 다른 패키지로 바꾸려면:
  1. Android Studio에서 프로젝트 생성 시 원하는 패키지명 입력
  2. 이 스크립트(``tools/apply_android_all.ps1``) 내부의 모든 ``com.rsr41.oracle``을 찾아 변경
  3. 스크립트 재실행

## 2. 스크립트 실행

프로젝트 생성 후:
``````powershell
cd <레포루트>
.\tools\apply_android_all.ps1
``````

이 스크립트는:
- 모든 Kotlin 소스 파일 생성
- ``AndroidManifest.xml`` 업데이트
- ``build.gradle.kts`` 의존성 추가
- 문서 파일 생성

## 3. Gradle Sync

1. Android Studio에서 ``apps/android`` 프로젝트 열기
2. 상단 ``Sync Now`` 클릭 (또는 ``File → Sync Project with Gradle Files``)
3. 의존성 다운로드 대기 (첫 실행 시 5-10분 소요)

### 흔한 오류 해결

**오류: JDK version 불일치**
- ``File → Project Structure → SDK Location``에서 JDK 17+ 확인

**오류: Gradle sync failed**
- ``gradle/wrapper/gradle-wrapper.properties`` 확인
- Gradle 8.2 이상 권장

**오류: Compose compiler 버전 불일치**
- ``build.gradle.kts``에서 Compose BOM 버전 확인

## 4. 앱 설정 (``local.properties`` 또는 환경변수)

``apps/android/local.properties``에 추가:
``````properties
# API 서버 (예시 - 실제 도메인으로 변경)
API_BASE_URL=https://api.yourdomain.com
PUBLIC_BASE_URL=https://yourdomain.com

# Mock 모드 (서버 없이 앱 단독 테스트)
MOCK_MODE=true
``````

또는 ``build.gradle.kts``에서 직접 수정

## 5. 실행

### 에뮬레이터
1. ``Tools → Device Manager``
2. **Create Virtual Device** (Pixel 5, API 33 권장)
3. ``Run → Run 'app'``

### 실기기
1. USB 디버깅 활성화 (개발자 옵션)
2. USB 연결
3. ``Run → Run 'app'``

## 6. 딥링크 테스트

``TEST_GUIDE.md`` 참조

## 7. 다음 단계

- ``PROJECT_STATE_ANDROID.md``: 현재 구현 상태
- ``TEST_GUIDE.md``: 테스트 명령
- ``app/src/main/java/com/rsr41/oracle/``: 코드 구조

---

**주의사항**
- ``Oracle`` 명칭은 상표 충돌 가능성 있음 (출시 전 확인 필요)
- NFC 태그에는 개인정보 저장 금지 (token만)
- 모든 결과는 "오락/참고용" 고지 필수
"@

Write-FileUTF8 (Join-Path $androidRoot "README_SETUP.md") $readmeSetup

# =====================================================================
# TEST_GUIDE.md
# =====================================================================
$testGuide = @"
# Oracle Android 앱 - 테스트 가이드

## 1. 딥링크 테스트 (ADB)

### 준비
- 앱이 설치되어 있어야 함
- 기기/에뮬레이터가 ADB에 연결되어 있어야 함

### Custom Scheme 테스트
``````bash
adb shell am start -a android.intent.action.VIEW -d "oracle://tag/TESTTOKEN123"
``````

### HTTPS App Links 테스트 (예시 URL)
``````bash
adb shell am start -a android.intent.action.VIEW -d "https://yourdomain.com/tag/TESTTOKEN123"
``````

**주의**: ``https://yourdomain.com``은 플레이스홀더입니다. 실제 도메인으로 변경하세요.

## 2. Mock 모드 테스트

``MOCK_MODE=true``로 설정하면 서버 없이 앱 단독 테스트 가능:

1. 앱 실행
2. 딥링크로 진입 → 프로필 입력
3. 오늘 운세 확인
4. 관상 업로드 (Mock 데이터 반환)

## 3. 실제 서버 연결 테스트

``MOCK_MODE=false``로 설정 후:

1. ``API_BASE_URL`` 확인
2. 네트워크 로그 확인 (Logcat에서 ``OkHttp`` 검색)
3. 에러 발생 시 Retrofit 응답 확인

## 4. 구조 확인
``````powershell
cd apps/android
tree /A /F | Out-File -Encoding utf8 ..\..\structure_android.txt
``````

## 5. Logcat 필터링
``````bash
adb logcat | grep -E "Oracle|Retrofit|OkHttp"
``````

## 6. 체크리스트

- [ ] 딥링크 (Custom Scheme) 작동
- [ ] 딥링크 (HTTPS) 작동
- [ ] 프로필 입력 → 저장
- [ ] 오늘 운세 조회
- [ ] 체크인 (1일 1회)
- [ ] 관상 업로드
- [ ] PWA 열기 (Custom Tabs)
- [ ] 네트워크 오류 재시도
- [ ] 고지 문구 표시

## 7. 다음 채팅 시 포함할 정보

에러 발생 시:
- Logcat 전체 스택 트레이스
- ``structure_android.txt``
- ``PROJECT_STATE_ANDROID.md``의 Resume Prompt
"@

Write-FileUTF8 (Join-Path $androidRoot "TEST_GUIDE.md") $testGuide

# =====================================================================
# PROJECT_STATE_ANDROID.md
# =====================================================================
$projectState = @"
# Oracle Android 앱 - 프로젝트 상태

생성일: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## 생성된 파일
``````
apps/android/
├── README_SETUP.md
├── TEST_GUIDE.md
├── PROJECT_STATE_ANDROID.md
├── app/
│   ├── build.gradle.kts
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/com/rsr41/oracle/
│       │   ├── OracleApplication.kt
│       │   ├── di/
│       │   │   └── AppModule.kt
│       │   ├── data/
│       │   │   ├── local/
│       │   │   │   └── PreferencesManager.kt
│       │   │   ├── remote/
│       │   │   │   ├── ApiService.kt
│       │   │   │   └── dto/
│       │   │   │       ├── TagResponse.kt
│       │   │   │       ├── ProfileRequest.kt
│       │   │   │       ├── ProfileResponse.kt
│       │   │   │       ├── CheckinRequest.kt
│       │   │   │       ├── CheckinResponse.kt
│       │   │   │       ├── TodayReportRequest.kt
│       │   │   │       ├── TodayReportResponse.kt
│       │   │   │       └── FaceUploadResponse.kt
│       │   │   └── repository/
│       │   │       └── OracleRepository.kt
│       │   └── ui/
│       │       ├── MainActivity.kt
│       │       ├── navigation/
│       │       │   └── NavGraph.kt
│       │       ├── screens/
│       │       │   ├── SplashScreen.kt
│       │       │   ├── HomeScreen.kt
│       │       │   ├── TagEntryScreen.kt
│       │       │   ├── ProfileScreen.kt
│       │       │   ├── TodayReportScreen.kt
│       │       │   └── FaceInsightScreen.kt
│       │       └── components/
│       │           └── CommonComponents.kt
│       └── res/values/
│           └── strings.xml
``````

## 완료된 기능

- [x] Hilt DI 설정
- [x] Retrofit + OkHttp 네트워크 계층
- [x] DataStore Preferences
- [x] Navigation Compose
- [x] 딥링크 (Custom Scheme + HTTPS)
- [x] Mock 모드 지원
- [x] 6개 화면 구현
  - [x] Splash
  - [x] Home
  - [x] TagEntry
  - [x] Profile
  - [x] TodayReport
  - [x] FaceInsight
- [x] 공통 UI 컴포넌트 (로딩/오류/재시도)
- [x] 고지 문구 (오락/참고용)
- [x] Custom Tabs (PWA 열기)
- [x] Photo Picker
- [x] Multipart 업로드

## 남은 작업 (TODO)

### 필수
- [ ] 실제 서버 연동 테스트
- [ ] 에러 핸들링 강화 (네트워크 타임아웃, 서버 5xx)
- [ ] 로딩 상태 개선 (Skeleton UI)
- [ ] 이미지 캐시 정책 (Coil 추가 고려)
- [ ] ProGuard/R8 설정 (릴리즈 빌드)
- [ ] 서명 키 생성 (배포용)

### 선택
- [ ] 다크 모드
- [ ] 다국어 (i18n)
- [ ] 푸시 알림 (FCM)
- [ ] 앱 아이콘/스플래시 이미지
- [ ] 애니메이션 개선

## 알려진 이슈

- 패키지명 ``com.rsr41.oracle``은 예시이며, 실제 도메인 소유 시 변경 필요
- ``Oracle`` 명칭 상표 리스크 (스토어 등록 전 확인)
- Photo Picker API 33+ 요구 (하위 버전 fallback 필요)

## Resume Prompt (다음 채팅 시 복사)
현재 Oracle Android 앱 상태:

레포: oracle/apps/android/
패키지: com.rsr41.oracle
생성된 파일: (PROJECT_STATE_ANDROID.md 참조)
완료: 기본 MVP 구현 완료
다음 작업: [여기에 작업 내용 기입]

에러 로그:
[여기에 Logcat/빌드 에러 붙여넣기]
구조 확인:
[tree /A /F 출력 또는 structure_android.txt 내용]
요청사항:
[구체적인 수정/추가 기능 요청]

## 빌드 정보

- minSdk: 26
- targetSdk: 34
- Kotlin: 1.9+
- Compose: BOM 2024.02+
- Hilt: 2.48+
- Retrofit: 2.9+

---

**다음 단계**
1. Android Studio Gradle Sync
2. 에뮬레이터 실행
3. ``TEST_GUIDE.md`` 테스트 수행
4. 에러 발생 시 Resume Prompt 사용
"@

Write-FileUTF8 (Join-Path $androidRoot "PROJECT_STATE_ANDROID.md") $projectState

# =====================================================================
# build.gradle.kts (app level)
# =====================================================================
$buildGradle = @"
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.dagger.hilt.android")
    id("kotlin-kapt")
}

android {
    namespace = "com.rsr41.oracle"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.rsr41.oracle"
        minSdk = 26
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }

        // 빌드 설정 주입
        val apiBaseUrl: String = project.findProperty("API_BASE_URL") as String? 
            ?: "https://api.example.com"
        val publicBaseUrl: String = project.findProperty("PUBLIC_BASE_URL") as String?
            ?: "https://example.com"
        val mockMode: String = project.findProperty("MOCK_MODE") as String? ?: "true"

        buildConfigField("String", "API_BASE_URL", "\"${"$"}apiBaseUrl\"")
        buildConfigField("String", "PUBLIC_BASE_URL", "\"${"$"}publicBaseUrl\"")
        buildConfigField("boolean", "MOCK_MODE", mockMode)
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        compose = true
        buildConfig = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.8"
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {
    // Compose BOM
    implementation(platform("androidx.compose:compose-bom:2024.02.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    
    // Core
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.activity:activity-compose:1.8.2")
    
    // Navigation
    implementation("androidx.navigation:navigation-compose:2.7.6")
    
    // Hilt
    implementation("com.google.dagger:hilt-android:2.50")
    kapt("com.google.dagger:hilt-android-compiler:2.50")
    implementation("androidx.hilt:hilt-navigation-compose:1.1.0")
    
    // Retrofit
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")
    
    // DataStore
    implementation("androidx.datastore:datastore-preferences:1.0.0")
    
    // Custom Tabs
    implementation("androidx.browser:browser:1.7.0")
    
    // Photo Picker
    implementation("androidx.activity:activity-ktx:1.8.2")
    
    // Debug
    debugImplementation("androidx.compose.ui:ui-tooling")
    debugImplementation("androidx.compose.ui:ui-test-manifest")
}
"@

Ensure-Directory (Join-Path $androidRoot "app")
Write-FileUTF8 (Join-Path $androidRoot "app\build.gradle.kts") $buildGradle

# =====================================================================
# AndroidManifest.xml
# =====================================================================
$manifest = @"
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

    <application
        android:name=".OracleApplication"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Material3.DayNight.NoActionBar"
        android:usesCleartextTraffic="true">

        <activity
            android:name=".ui.MainActivity"
            android:exported="true"
            android:theme="@style/Theme.Material3.DayNight.NoActionBar">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

            <!-- Custom Scheme -->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="oracle" android:host="tag" />
            </intent-filter>

            <!-- HTTPS App Links (예시 - 실제 도메인으로 변경) -->
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="https" android:host="yourdomain.com" android:pathPrefix="/tag/" />
            </intent-filter>
        </activity>
    </application>
</manifest>
"@

$manifestDir = Join-Path $androidRoot "app\src\main"
Write-FileUTF8 (Join-Path $manifestDir "AndroidManifest.xml") $manifest

# =====================================================================
# strings.xml
# =====================================================================
$strings = @"
<resources>
    <string name="app_name">Oracle</string>
    <string name="disclaimer">이 결과는 오락/참고용입니다</string>
</resources>
"@

$valuesDir = Join-Path $manifestDir "res\values"
Write-FileUTF8 (Join-Path $valuesDir "strings.xml") $strings

# =====================================================================
# Kotlin 소스 파일들
# =====================================================================
$javaDir = Join-Path $manifestDir "java\com\rsr41\oracle"

# OracleApplication.kt
$appClass = @"
package com.rsr41.oracle

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class OracleApplication : Application()
"@

Write-FileUTF8 (Join-Path $javaDir "OracleApplication.kt") $appClass

# AppModule.kt
$appModule = @"
package com.rsr41.oracle.di

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore
import com.rsr41.oracle.BuildConfig
import com.rsr41.oracle.data.local.PreferencesManager
import com.rsr41.oracle.data.remote.ApiService
import com.rsr41.oracle.data.repository.OracleRepository
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit
import javax.inject.Singleton

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "oracle_prefs")

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideDataStore(@ApplicationContext context: Context): DataStore<Preferences> {
        return context.dataStore
    }

    @Provides
    @Singleton
    fun providePreferencesManager(dataStore: DataStore<Preferences>): PreferencesManager {
        return PreferencesManager(dataStore)
    }

    @Provides
    @Singleton
    fun provideOkHttpClient(): OkHttpClient {
        val logging = HttpLoggingInterceptor().apply {
            level = if (BuildConfig.DEBUG) HttpLoggingInterceptor.Level.BODY
                    else HttpLoggingInterceptor.Level.NONE
        }
        return OkHttpClient.Builder()
            .addInterceptor(logging)
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .build()
    }

    @Provides
    @Singleton
    fun provideRetrofit(client: OkHttpClient): Retrofit {
        return Retrofit.Builder()
            .baseUrl(BuildConfig.API_BASE_URL)
            .client(client)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    @Provides
    @Singleton
    fun provideApiService(retrofit: Retrofit): ApiService {
        return retrofit.create(ApiService::class.java)
    }

    @Provides
    @Singleton
    fun provideOracleRepository(
        apiService: ApiService,
        preferencesManager: PreferencesManager
    ): OracleRepository {
        return OracleRepository(apiService, preferencesManager)
    }
}
"@

Write-FileUTF8 (Join-Path $javaDir "di\AppModule.kt") $appModule

# PreferencesManager.kt
$prefsManager = @"
package com.rsr41.oracle.data.local

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class PreferencesManager @Inject constructor(
    private val dataStore: DataStore<Preferences>
) {
    companion object {
        val PROFILE_ID_KEY = stringPreferencesKey("profile_id")
        val TOKEN_KEY = stringPreferencesKey("token")
        val LAST_CHECKIN_KEY = stringPreferencesKey("last_checkin")
    }

    val profileIdFlow: Flow<String?> = dataStore.data.map { it[PROFILE_ID_KEY] }
    val tokenFlow: Flow<String?> = dataStore.data.map { it[TOKEN_KEY] }
    val lastCheckinFlow: Flow<String?> = dataStore.data.map { it[LAST_CHECKIN_KEY] }

    suspend fun saveProfileId(profileId: String) {
        dataStore.edit { it[PROFILE_ID_KEY] = profileId }
    }

    suspend fun saveToken(token: String) {
        dataStore.edit { it[TOKEN_KEY] = token }
    }

    suspend fun saveLastCheckin(dateKey: String) {
        dataStore.edit { it[LAST_CHECKIN_KEY] = dateKey }
    }

    suspend fun clear() {
        dataStore.edit { it.clear() }
    }
}
"@

Write-FileUTF8 (Join-Path $javaDir "data\local\PreferencesManager.kt") $prefsManager

# DTO files
$dtoDir = Join-Path $javaDir "data\remote\dto"

$tagResponse = @"
package com.rsr41.oracle.data.remote.dto

data class TagResponse(
    val token: String,
    val status: String,
    val boundProfileId: String?
)
"@
Write-FileUTF8 (Join-Path $dtoDir "TagResponse.kt") $tagResponse

$profileRequest = @"
package com.rsr41.oracle.data.remote.dto

data class ProfileRequest(
    val birthDate: String,
    val birthTime: String?,
    val timeUnknown: Boolean,
    val calendarType: String,
    val gender: String
)
"@
Write-FileUTF8 (Join-Path $dtoDir "ProfileRequest.kt") $profileRequest

$profileResponse = @"
package com.rsr41.oracle.data.remote.dto

data class ProfileResponse(
    val profileId: String
)
"@
Write-FileUTF8 (Join-Path $dtoDir "ProfileResponse.kt") $profileResponse

$checkinRequest = @"
package com.rsr41.oracle.data.remote.dto

data class CheckinRequest(
    val profileId: String,
    val token: String?
)
"@
Write-FileUTF8 (Join-Path $dtoDir "CheckinRequest.kt") $checkinRequest

$checkinResponse = @"
package com
.rsr41.oracle.data.remote.dto
data class CheckinResponse(
val dateKey: String,
val unlocked: Boolean,
val alreadyCheckedIn: Boolean? = null
)
"@
Write-FileUTF8 (Join-Path $dtoDir "CheckinResponse.kt") $checkinResponse
$todayReportRequest = @"
package com.rsr41.oracle.data.remote.dto
data class TodayReportRequest(
val profileId: String,
val token: String?
)
"@
Write-FileUTF8 (Join-Path $dtoDir "TodayReportRequest.kt") $todayReportRequest
$todayReportResponse = @"
package com.rsr41.oracle.data.remote.dto
data class TodayReportResponse(
val dateKey: String,
val preview: String,
val full: String?,
val unlocked: Boolean
)
"@
Write-FileUTF8 (Join-Path $dtoDir "TodayReportResponse.kt") $todayReportResponse
$faceUploadResponse = @"
package com.rsr41.oracle.data.remote.dto
data class FaceUploadResponse(
val dateKey: String,
val summaryText: String,
val flags: List<String>
)
"@
Write-FileUTF8 (Join-Path $dtoDir "FaceUploadResponse.kt") $faceUploadResponse
ApiService.kt
$apiService = @"
package com.rsr41.oracle.data.remote
import com.rsr41.oracle.data.remote.dto.*
import okhttp3.MultipartBody
import retrofit2.http.*
interface ApiService {
@GET("public/tag/{token}")
suspend fun getTag(@Path("token") token: String): TagResponse

@POST("public/profile")
suspend fun createProfile(@Body request: ProfileRequest): ProfileResponse

@POST("public/checkin")
suspend fun checkin(@Body request: CheckinRequest): CheckinResponse

@POST("public/today-report")
suspend fun getTodayReport(@Body request: TodayReportRequest): TodayReportResponse

@Multipart
@POST("public/face/upload")
suspend fun uploadFace(@Part image: MultipartBody.Part): FaceUploadResponse
}
"@
Write-FileUTF8 (Join-Path $javaDir "data\remote\ApiService.kt") $apiService
OracleRepository.kt
$repository = @"
package com.rsr41.oracle.data.repository
import com.rsr41.oracle.BuildConfig
import com.rsr41.oracle.data.local.PreferencesManager
import com.rsr41.oracle.data.remote.ApiService
import com.rsr41.oracle.data.remote.dto.*
import kotlinx.coroutines.flow.first
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import javax.inject.Inject
class OracleRepository @Inject constructor(
private val apiService: ApiService,
private val preferencesManager: PreferencesManager
) {
suspend fun getProfileId(): String? = preferencesManager.profileIdFlow.first()
suspend fun getToken(): String? = preferencesManager.tokenFlow.first()
suspend fun getLastCheckin(): String? = preferencesManager.lastCheckinFlow.first()
suspend fun saveProfileId(profileId: String) = preferencesManager.saveProfileId(profileId)
suspend fun saveToken(token: String) = preferencesManager.saveToken(token)
suspend fun saveLastCheckin(dateKey: String) = preferencesManager.saveLastCheckin(dateKey)

suspend fun validateTag(token: String): Result<TagResponse> {
    return try {
        if (BuildConfig.MOCK_MODE) {
            Result.success(TagResponse(token, "active", null))
        } else {
            Result.success(apiService.getTag(token))
        }
    } catch (e: Exception) {
        Result.failure(e)
    }
}

suspend fun createProfile(request: ProfileRequest): Result<ProfileResponse> {
    return try {
        if (BuildConfig.MOCK_MODE) {
            val mockId = "mock_profile_" + System.currentTimeMillis()
            Result.success(ProfileResponse(mockId))
        } else {
            Result.success(apiService.createProfile(request))
        }
    } catch (e: Exception) {
        Result.failure(e)
    }
}

suspend fun checkin(profileId: String, token: String?): Result<CheckinResponse> {
    return try {
        if (BuildConfig.MOCK_MODE) {
            val today = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.US)
                .format(java.util.Date())
            Result.success(CheckinResponse(today, true, false))
        } else {
            Result.success(apiService.checkin(CheckinRequest(profileId, token)))
        }
    } catch (e: Exception) {
        Result.failure(e)
    }
}

suspend fun getTodayReport(profileId: String, token: String?): Result<TodayReportResponse> {
    return try {
        if (BuildConfig.MOCK_MODE) {
            val today = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.US)
                .format(java.util.Date())
            Result.success(
                TodayReportResponse(
                    dateKey = today,
                    preview = "오늘은 긍정적인 에너지가 가득한 날입니다.",
                    full = "전체 운세: 새로운 기회가 찾아올 수 있으니 주변을 잘 살펴보세요. 오후에는 중요한 결정을 내리기 좋은 시간입니다.",
                    unlocked = true
                )
            )
        } else {
            Result.success(apiService.getTodayReport(TodayReportRequest(profileId, token)))
        }
    } catch (e: Exception) {
        Result.failure(e)
    }
}

suspend fun uploadFace(imageFile: File): Result<FaceUploadResponse> {
    return try {
        if (BuildConfig.MOCK_MODE) {
            val today = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.US)
                .format(java.util.Date())
            Result.success(
                FaceUploadResponse(
                    dateKey = today,
                    summaryText = "밝고 긍정적인 인상을 주는 표정입니다. 자신감 있는 모습이 돋보입니다.",
                    flags = listOf("good_quality", "clear_image")
                )
            )
        } else {
            val requestFile = imageFile.asRequestBody("image/*".toMediaTypeOrNull())
            val body = MultipartBody.Part.createFormData("image", imageFile.name, requestFile)
            Result.success(apiService.uploadFace(body))
        }
    } catch (e: Exception) {
        Result.failure(e)
    }
}
}
"@
Write-FileUTF8 (Join-Path $javaDir "data\repository\OracleRepository.kt") $repository
MainActivity.kt
$mainActivity = @"
package com.rsr41.oracle.ui
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.core.view.WindowCompat
import dagger.hilt.android.AndroidEntryPoint
@AndroidEntryPoint
class MainActivity : ComponentActivity() {
override fun onCreate(savedInstanceState: Bundle?) {
super.onCreate(savedInstanceState)
WindowCompat.setDecorFitsSystemWindows(window, false)
    setContent {
        MaterialTheme {
            Surface {
                com.rsr41.oracle.ui.navigation.NavGraph(
                    deepLinkToken = extractDeepLinkToken(intent)
                )
            }
        }
    }
}

override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    setIntent(intent)
}

private fun extractDeepLinkToken(intent: Intent?): String? {
    val data = intent?.data ?: return null
    // oracle://tag/{token} 또는 https://.../tag/{token}
    val segments = data.pathSegments
    return if (segments.size >= 2 && segments[0] == "tag") {
        segments[1]
    } else null
}
}
"@
Write-FileUTF8 (Join-Path $javaDir "ui\MainActivity.kt") $mainActivity
NavGraph.kt
$navGraph = @"
package com.rsr41.oracle.ui.navigation
import androidx.compose.runtime.Composable
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.rsr41.oracle.ui.screens.*
sealed class Screen(val route: String) {
    object Splash : Screen("splash")
    object Home : Screen("home")
    object TagEntry : Screen("tag_entry/{token}") {
        fun createRoute(token: String) = "tag_entry/{"
"}token"
    }
    object Profile : Screen("profile?fromTag={fromTag}") {
        fun createRoute(fromTag: Boolean = false) = "profile?fromTag={"
"}fromTag"
    }
    object TodayReport : Screen("today_report")
    object FaceInsight : Screen("face_insight")
}

@Composable
fun NavGraph(deepLinkToken: String? = null) {
val navController = rememberNavController()
NavHost(
    navController = navController,
    startDestination = Screen.Splash.route
) {
    composable(Screen.Splash.route) {
        SplashScreen(
            navController = navController,
            deepLinkToken = deepLinkToken
        )
    }

    composable(Screen.Home.route) {
        HomeScreen(navController = navController)
    }

    composable(
        route = Screen.TagEntry.route,
        arguments = listOf(navArgument("token") { type = NavType.StringType })
    ) { backStackEntry ->
        val token = backStackEntry.arguments?.getString("token") ?: ""
        TagEntryScreen(
            navController = navController,
            token = token
        )
    }

    composable(
        route = Screen.Profile.route,
        arguments = listOf(navArgument("fromTag") {
            type = NavType.BoolType
            defaultValue = false
        })
    ) { backStackEntry ->
        val fromTag = backStackEntry.arguments?.getBoolean("fromTag") ?: false
        ProfileScreen(
            navController = navController,
            fromTag = fromTag
        )
    }

    composable(Screen.TodayReport.route) {
        TodayReportScreen(navController = navController)
    }

    composable(Screen.FaceInsight.route) {
        FaceInsightScreen(navController = navController)
    }
}
}
"@
Write-FileUTF8 (Join-Path $javaDir "ui\navigation\NavGraph.kt") $navGraph
CommonComponents.kt
$commonComponents = @"
package com.rsr41.oracle.ui.components
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
@Composable
fun LoadingView() {
Box(
modifier = Modifier.fillMaxSize(),
contentAlignment = Alignment.Center
) {
CircularProgressIndicator()
}
}
@Composable
fun ErrorView(message: String, onRetry: () -> Unit) {
Column(
modifier = Modifier
.fillMaxSize()
.padding(16.dp),
verticalArrangement = Arrangement.Center,
horizontalAlignment = Alignment.CenterHorizontally
) {
Text(
text = message,
style = MaterialTheme.typography.bodyLarge,
textAlign = TextAlign.Center
)
Spacer(modifier = Modifier.height(16.dp))
Button(onClick = onRetry) {
Text("다시 시도")
}
}
}
@Composable
fun DisclaimerFooter() {
Box(
modifier = Modifier
.fillMaxWidth()
.background(Color(0xFFFFF9C4))
.padding(12.dp),
contentAlignment = Alignment.Center
) {
Text(
text = "이 결과는 오락/참고용입니다",
style = MaterialTheme.typography.bodySmall,
color = Color(0xFF5D4037)
)
}
}
"@
Write-FileUTF8 (Join-Path $javaDir "ui\components\CommonComponents.kt") $commonComponents
Screens
$screensDir = Join-Path $javaDir "ui\screens"
SplashScreen.kt
$splashScreen = @"
package com.rsr41.oracle.ui.screens
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.navigation.NavController
import com.rsr41.oracle.data.repository.OracleRepository
import com.rsr41.oracle.ui.navigation.Screen
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.delay
import javax.inject.Inject
@HiltViewModel
class SplashViewModel @Inject constructor(
private val repository: OracleRepository
) : ViewModel() {
suspend fun getProfileId(): String? = repository.getProfileId()
}
@Composable
fun SplashScreen(
navController: NavController,
deepLinkToken: String?,
viewModel: SplashViewModel = hiltViewModel()
) {
LaunchedEffect(Unit) {
delay(1000)
val profileId = viewModel.getProfileId()
    if (deepLinkToken != null) {
        navController.navigate(Screen.TagEntry.createRoute(deepLinkToken)) {
            popUpTo(Screen.Splash.route) { inclusive = true }
        }
    } else if (profileId != null) {
        navController.navigate(Screen.Home.route) {
            popUpTo(Screen.Splash.route) { inclusive = true }
        }
    } else {
        navController.navigate(Screen.Profile.createRoute(fromTag = false)) {
            popUpTo(Screen.Splash.route) { inclusive = true }
        }
    }
}

Box(
    modifier = Modifier.fillMaxSize(),
    contentAlignment = Alignment.Center
) {
    Text("Oracle")
}
}
"@
Write-FileUTF8 (Join-Path $screensDir "SplashScreen.kt") $splashScreen
HomeScreen.kt
$homeScreen = @"
package com.rsr41.oracle.ui.screens
import android.content.Context
import android.net.Uri
import androidx.browser.customtabs.CustomTabsIntent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import com.rsr41.oracle.BuildConfig
import com.rsr41.oracle.data.repository.OracleRepository
import com.rsr41.oracle.ui.components.DisclaimerFooter
import com.rsr41.oracle.ui.components.ErrorView
import com.rsr41.oracle.ui.components.LoadingView
import com.rsr41.oracle.ui.navigation.Screen
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject
@HiltViewModel
class HomeViewModel @Inject constructor(
private val repository: OracleRepository
) : ViewModel() {
var uiState by mutableStateOf<HomeUiState>(HomeUiState.Loading)
    private set

init {
    loadData()
}

fun loadData() {
    viewModelScope.launch {
        uiState = HomeUiState.Loading
        try {
            val profileId = repository.getProfileId()
            val token = repository.getToken()
            if (profileId == null) {
                uiState = HomeUiState.Error("프로필이 없습니다")
                return@launch
            }

            val result = repository.getTodayReport(profileId, token)
            result.fold(
                onSuccess = { report ->
                    uiState = HomeUiState.Success(
                        preview = report.preview,
                        unlocked = report.unlocked
                    )
                },
                onFailure = { uiState = HomeUiState.Error(it.message ?: "오류 발생") }
            )
        } catch (e: Exception) {
            uiState = HomeUiState.Error(e.message ?: "알 수 없는 오류")
        }
    }
}

fun checkin() {
    viewModelScope.launch {
        val profileId = repository.getProfileId() ?: return@launch
        val token = repository.getToken()
        repository.checkin(profileId, token).fold(
            onSuccess = { response ->
                repository.saveLastCheckin(response.dateKey)
                loadData()
            },
            onFailure = { }
        )
    }
}
}
sealed class HomeUiState {
object Loading : HomeUiState()
data class Success(val preview: String, val unlocked: Boolean) : HomeUiState()
data class Error(val message: String) : HomeUiState()
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
navController: NavController,
viewModel: HomeViewModel = hiltViewModel()
) {
val context = LocalContext.current
Scaffold(
    topBar = {
        TopAppBar(title = { Text("Oracle") })
    }
) { padding ->
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(padding)
    ) {
        when (val state = viewModel.uiState) {
            is HomeUiState.Loading -> LoadingView()
            is HomeUiState.Error -> ErrorView(state.message) { viewModel.loadData() }
            is HomeUiState.Success -> {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Card(modifier = Modifier.fillMaxWidth()) {
                        Column(modifier = Modifier.padding(16.dp)) {
                            Text("오늘의 운세", style = MaterialTheme.typography.titleMedium)
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(state.preview)
                        }
                    }

                    Button(
                        onClick = { viewModel.checkin() },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("체크인 (1일 1회)")
                    }

                    Button(
                        onClick = { navController.navigate(Screen.TodayReport.route) },
                        modifier = Modifier.fillMaxWidth(),
                        enabled = state.unlocked
                    ) {
                        Text(if (state.unlocked) "전체 결과 보기" else "잠금 해제 필요")
                    }

                    Button(
                        onClick = { navController.navigate(Screen.FaceInsight.route) },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("관상 분석")
                    }

                    Button(
                        onClick = { navController.navigate(Screen.Profile.createRoute()) },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("프로필 수정")
                    }

                    Button(
                        onClick = { openPWA(context) },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("PWA 열기")
                    }

                    Spacer(modifier = Modifier.weight(1f))
                    DisclaimerFooter()
                }
            }
        }
    }
}
}
private fun openPWA(context: Context) {
val url = BuildConfig.PUBLIC_BASE_URL
val intent = CustomTabsIntent.Builder().build()
intent.launchUrl(context, Uri.parse(url))
}
"@
Write-FileUTF8 (Join-Path $screensDir "HomeScreen.kt") $homeScreen
TagEntryScreen.kt
$tagEntryScreen = @"
package com.rsr41.oracle.ui.screens
import androidx.compose.runtime.*
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import com.rsr41.oracle.data.repository.OracleRepository
import com.rsr41.oracle.ui.components.ErrorView
import com.rsr41.oracle.ui.components.LoadingView
import com.rsr41.oracle.ui.navigation.Screen
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject
@HiltViewModel
class TagEntryViewModel @Inject constructor(
private val repository: OracleRepository
) : ViewModel() {
var uiState by mutableStateOf<TagEntryUiState>(TagEntryUiState.Loading)
    private set

fun validateToken(token: String, navController: NavController) {
    viewModelScope.launch {
        uiState = TagEntryUiState.Loading
        repository.saveToken(token)

        val result = repository.validateTag(token)
        result.fold(
            onSuccess = {
                val profileId = repository.getProfileId()
                if (profileId == null) {
                    navController.navigate(Screen.Profile.createRoute(fromTag = true)) {
                        popUpTo(Screen.TagEntry.route) { inclusive = true }
                    }
                } else {
                    navController.navigate(Screen.TodayReport.route) {
                        popUpTo(Screen.TagEntry.route) { inclusive = true }
                    }
                }
            },
            onFailure = {
                uiState = TagEntryUiState.Error(it.message ?: "토큰 검증 실패")
            }
        )
    }
}
}
sealed class TagEntryUiState {
object Loading : TagEntryUiState()
data class Error(val message: String) : TagEntryUiState()
}
@Composable
fun TagEntryScreen(
navController: NavController,
token: String,
viewModel: TagEntryViewModel = hiltViewModel()
) {
LaunchedEffect(token) {
viewModel.validateToken(token, navController)
}
when (val state = viewModel.uiState) {
    is TagEntryUiState.Loading -> LoadingView()
    is TagEntryUiState.Error -> ErrorView(state.message) {
        viewModel.validateToken(token, navController)
    }
}
}
"@
Write-FileUTF8 (Join-Path $screensDir "TagEntryScreen.kt") $tagEntryScreen
ProfileScreen.kt
$profileScreen = @"
package com.rsr41.oracle.ui.screens
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import com.rsr41.oracle.data.remote.dto.ProfileRequest
import com.rsr41.oracle.data.repository.OracleRepository
import com.rsr41.oracle.ui.components.ErrorView
import com.rsr41.oracle.ui.components.LoadingView
import com.rsr41.oracle.ui.navigation.Screen
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject
@HiltViewModel
class ProfileViewModel @Inject constructor(
private val repository: OracleRepository
) : ViewModel() {
var uiState by mutableStateOf<ProfileUiState>(ProfileUiState.Idle)
    private set

fun saveProfile(
    birthDate: String,
    birthTime: String?,
    timeUnknown: Boolean,
    calendarType: String,
    gender: String,
    navController: NavController,
    fromTag: Boolean
) {
    viewModelScope.launch {
        uiState = ProfileUiState.Loading
        val request = ProfileRequest(
            birthDate = birthDate,
            birthTime = birthTime,
            timeUnknown = timeUnknown,
            calendarType = calendarType,
            gender = gender
        )

        val result = repository.createProfile(request)
        result.fold(
            onSuccess = { response ->
                repository.saveProfileId(response.profileId)
                if (fromTag) {
                    navController.navigate(Screen.TodayReport.route) {
                        popUpTo(Screen.Profile.route) { inclusive = true }
                    }
                } else {
                    navController.navigate(Screen.Home.route) {
                        popUpTo(Screen.Profile.route) { inclusive = true }
                    }
                }
            },
            onFailure = {
                uiState = ProfileUiState.Error(it.message ?: "프로필 저장 실패")
            }
        )
    }
}
}
sealed class ProfileUiState {
object Idle : ProfileUiState()
object Loading : ProfileUiState()
data class Error(val message: String) : ProfileUiState()
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ProfileScreen(
navController: NavController,
fromTag: Boolean,
viewModel: ProfileViewModel = hiltViewModel()
) {
var birthDate by remember { mutableStateOf("") }
var birthTime by remember { mutableStateOf("") }
var timeUnknown by remember { mutableStateOf(false) }
var calendarType by remember { mutableStateOf("solar") }
var gender by remember { mutableStateOf("unspecified") }
Scaffold(
    topBar = {
        TopAppBar(title = { Text("프로필 입력") })
    }
) { padding ->
    when (val state = viewModel.uiState) {
        is ProfileUiState.Loading -> LoadingView()
        is ProfileUiState.Error -> ErrorView(state.message) {
            viewModel.saveProfile(birthDate, birthTime, timeUnknown, calendarType, gender, navController, fromTag)
        }
        is ProfileUiState.Idle -> {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                OutlinedTextField(
                    value = birthDate,
                    onValueChange = { birthDate = it },
                    label = { Text("생년월일 (YYYY-MM-DD)") },
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = birthTime,
                    onValueChange = { birthTime = it },
                    label = { Text("출생 시간 (HH:MM)") },
                    enabled = !timeUnknown,
                    modifier = Modifier.fillMaxWidth()
                )

                Row(verticalAlignment = androidx.compose.ui.Alignment.CenterVertically) {
                    Checkbox(checked = timeUnknown, onCheckedChange = { timeUnknown = it })
                    Text("시간 모름")
                }

                Text("양력/음력")
                Row {
                    RadioButton(selected = calendarType == "solar", onClick = { calendarType = "solar" })
                    Text("양력")
                    Spacer(modifier = Modifier.width(16.dp))
                    RadioButton(selected = calendarType == "lunar", onClick = { calendarType = "lunar" })
                    Text("음력")
                }

                Text("성별")
                Row {
                    RadioButton(selected = gender == "male", onClick = { gender = "male" })
                    Text("남성")
                    Spacer(modifier = Modifier.width(16.dp))
                    RadioButton(selected = gender == "female", onClick = { gender = "female" })
                    Text("여성")
                    Spacer(modifier = Modifier.width(16.dp))
                    RadioButton(selected = gender == "unspecified", onClick = { gender = "unspecified" })
                    Text("기타")
                }

                Button(
                    onClick = {
                        viewModel.saveProfile(
                            birthDate, birthTime, timeUnknown, calendarType, gender,
                            navController, fromTag
                        )
                    },
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("저장")
                }
            }
        }
    }
}
}
"@
Write-FileUTF8 (Join-Path $screensDir "ProfileScreen.kt") $profileScreen
TodayReportScreen.kt
$todayReportScreen = @"
package com.rsr41.oracle.ui.screens
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import com.rsr41.oracle.data.repository.OracleRepository
import com.rsr41.oracle.ui.components.DisclaimerFooter
import com.rsr41.oracle.ui.components.ErrorView
import com.rsr41.oracle.ui.components.LoadingView
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject
@HiltViewModel
class TodayReportViewModel @Inject constructor(
private val repository: OracleRepository
) : ViewModel() {
var uiState by mutableStateOf<TodayReportUiState>(TodayReportUiState.Loading)
    private set

init {
    loadReport()
}

fun loadReport() {
    viewModelScope.launch {
        uiState = TodayReportUiState.Loading
        val profileId = repository.getProfileId()
        val token = repository.getToken()

        if (profileId == null) {
            uiState = TodayReportUiState.Error("프로필이 없습니다")
            return@launch
        }

        val result = repository.getTodayReport(profileId, token)
        result.fold(
            onSuccess = { report ->
                uiState = TodayReportUiState.Success(
                    preview = report.preview,
                    full = report.full,
                    unlocked = report.unlocked
                )
            },
            onFailure = {
                uiState = TodayReportUiState.Error(it.message ?: "오류 발생")
            }
        )
    }
}
}
sealed class TodayReportUiState {
object Loading : TodayReportUiState()
data class Success(val preview: String, val full: String?, val unlocked: Boolean) : TodayReportUiState()
data class Error(val message: String) : TodayReportUiState()
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TodayReportScreen(
navController: NavController,
viewModel: TodayReportViewModel = hiltViewModel()
) {
Scaffold(
topBar = {
TopAppBar(
title = { Text("오늘의 운세") },
navigationIcon = {
IconButton(onClick = { navController.popBackStack() }) {
Text("←")
}
}
)
}
) { padding ->
Column(
modifier = Modifier
.fillMaxSize()
.padding(padding)
) {
when (val state = viewModel.uiState) {
is TodayReportUiState.Loading -> LoadingView()
is TodayReportUiState.Error -> ErrorView(state.message) { viewModel.loadReport() }
is TodayReportUiState.Success -> {
Column(
modifier = Modifier
.fillMaxSize()
.padding(16.dp)
) {
Card(modifier = Modifier.fillMaxWidth()) {
Column(modifier = Modifier.padding(16.dp)) {
Text("미리보기", style = MaterialTheme.typography.titleMedium)
Spacer(modifier = Modifier.height(8.dp))
Text(state.preview)
}
}
                    if (state.unlocked && state.full != null) {
                        Spacer(modifier = Modifier.height(16.dp))
                        Card(modifier = Modifier.fillMaxWidth()) {
                            Column(modifier = Modifier.padding(16.dp)) {
                                Text("전체 운세", style = MaterialTheme.typography.titleMedium)
                                Spacer(modifier = Modifier.height(8.dp))
                                Text(state.full)
                            }
                        }
                    }

                    Spacer(modifier = Modifier.weight(1f))
                    DisclaimerFooter()
                }
            }
        }
    }
}
}
"@
Write-FileUTF8 (Join-Path $screensDir "TodayReportScreen.kt") $todayReportScreen
FaceInsightScreen.kt
$faceInsightScreen = @"
package com.rsr41.oracle.ui.screens
import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import com.rsr41.oracle.data.repository.OracleRepository
import com.rsr41.oracle.ui.components.DisclaimerFooter
import com.rsr41.oracle.ui.components.ErrorView
import com.rsr41.oracle.ui.components.LoadingView
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import java.io.File
import javax.inject.Inject
@HiltViewModel
class FaceInsightViewModel @Inject constructor(
private val repository: OracleRepository
) : ViewModel() {
var uiState by mutableStateOf<FaceInsightUiState>(FaceInsightUiState.Idle)
    private set

fun uploadImage(uri: Uri, context: android.content.Context) {
    viewModelScope.launch {
        uiState = FaceInsightUiState.Loading
        try {
            val inputStream = context.contentResolver.openInputStream(uri)
            val file = File(context.cacheDir, "temp_face.jpg")
            inputStream?.use { input ->
                file.outputStream().use { output ->
                    input.copyTo(output)
                }
            }

            val result = repository.uploadFace(file)
            file.delete()

            result.fold(
                onSuccess = { response ->
                    uiState = FaceInsightUiState.Success(
                        summaryText = response.summaryText,
                        flags = response.flags
                    )
                },
                onFailure = {
                    uiState = FaceInsightUiState.Error(it.message ?: "업로드 실패")
                }
            )
        } catch (e: Exception) {
            uiState = FaceInsightUiState.Error(e.message ?: "알 수 없는 오류")
        }
    }
}
}
sealed class FaceInsightUiState {
object Idle : FaceInsightUiState()
object Loading : FaceInsightUiState()
data class Success(val summaryText: String, val flags: List<String>) : FaceInsightUiState()
data class Error(val message: String) : FaceInsightUiState()
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FaceInsightScreen(
navController: NavController,
viewModel: FaceInsightViewModel = hiltViewModel()
) {
val context = LocalContext.current
val launcher = rememberLauncherForActivityResult(
contract = ActivityResultContracts.PickVisualMedia()
) { uri ->
uri?.let { viewModel.uploadImage(it, context) }
}
Scaffold(
    topBar = {
        TopAppBar(
            title = { Text("관상 분석") },
            navigationIcon = {
                IconButton(onClick = { navController.popBackStack() }) {
                    Text("←")
                }
            }
        )
    }
) { padding ->
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(padding)
    ) {
        when (val state = viewModel.uiState) {
            is FaceInsightUiState.Loading -> LoadingView()
            is FaceInsightUiState.Error -> ErrorView(state.message) { }
            is FaceInsightUiState.Idle -> {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp)
                ) {
                    Text(
                        "주의: 이 기능은 인종, 민족, 건강, 범죄성 등 민감한 속성을 추정하지 않으며, 오락/참고용입니다.",
                        style = MaterialTheme.typography.bodySmall
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Button(
                        onClick = {
                            launcher.launch(
                                PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)
                            )
                        },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("사진 선택")
                    }
                    Spacer(modifier = Modifier.weight(1f))
                    DisclaimerFooter()
                }
            }
            is FaceInsightUiState.Success -> {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp)
                ) {
                    Card(modifier = Modifier.fillMaxWidth()) {
                        Column(modifier = Modifier.padding(16.dp)) {
                            Text("분석 결과", style = MaterialTheme.typography.titleMedium)
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(state.summaryText)
                            if (state.flags.isNotEmpty()) {
                                Spacer(modifier = Modifier.height(8.dp))
                                Text("플래그: ${"$"}{state.flags.joinToString(", ")}")
                            }
                        }
                    }
                    Spacer(modifier = Modifier.height(16.dp))
                    Button(
                        onClick = {
                            launcher.launch(
                                PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)
                            )
                        },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("다시 분석")
                    }
                    Spacer(modifier = Modifier.weight(1f))
                    DisclaimerFooter()
                }
            }
        }
    }
}
}
"@
Write-FileUTF8 (Join-Path $screensDir "FaceInsightScreen.kt") $faceInsightScreen
Write-Host ""
Write-Host "==============================================" -ForegroundColor Green
Write-Host "Oracle Android 파일 생성 완료!" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green
Write-Host ""
Write-Host "다음 단계:" -ForegroundColor Yellow
Write-Host "1. apps/android/README_SETUP.md 읽기" -ForegroundColor Cyan
Write-Host "2. Android Studio에서 Empty Compose Activity 프로젝트 생성" -ForegroundColor Cyan
Write-Host "3. 프로젝트 위치: apps/android" -ForegroundColor Cyan
Write-Host "4. 패키지명: com.rsr41.oracle" -ForegroundColor Cyan
Write-Host "5. 프로젝트 생성 후 이 스크립트 재실행" -ForegroundColor Cyan
Write-Host "6. Gradle Sync" -ForegroundColor Cyan
Write-Host "7. TEST_GUIDE.md 참조하여 테스트" -ForegroundColor Cyan
Write-Host ""