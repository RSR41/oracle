import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// key.properties 로드 (릴리즈 서명용)
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val isReleaseTaskRequested = gradle.startParameter.taskNames.any { taskName ->
    taskName.contains("Release", ignoreCase = true)
}

fun requireKeystoreProperty(key: String): String {
    val value = keystoreProperties.getProperty(key)?.trim()
    require(!value.isNullOrEmpty()) { "android/key.properties 필수 키 누락: $key" }
    return value
}

if (isReleaseTaskRequested) {
    require(keystorePropertiesFile.exists()) {
        "릴리즈 빌드는 android/key.properties가 필요합니다."
    }
    FileInputStream(keystorePropertiesFile).use { input ->
        keystoreProperties.load(input)
    }

    val requiredKeys = listOf("keyAlias", "keyPassword", "storeFile", "storePassword")
    requiredKeys.forEach { key ->
        requireKeystoreProperty(key)
    }
}

android {
    namespace = "com.destiny.oracle"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.destiny.oracle"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 릴리즈 서명 설정
    signingConfigs {
        create("release") {
            if (isReleaseTaskRequested) {
                keyAlias = requireKeystoreProperty("keyAlias")
                keyPassword = requireKeystoreProperty("keyPassword")
                storeFile = file(requireKeystoreProperty("storeFile"))
                storePassword = requireKeystoreProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // 코드 난독화 및 리소스 축소 (선택적)
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
