package com.rsr41.oracle

import android.content.res.Configuration
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import com.rsr41.oracle.data.local.PreferencesManager
import com.rsr41.oracle.domain.model.AppLanguage
import com.rsr41.oracle.domain.model.ThemeMode
import com.rsr41.oracle.ui.navigation.OracleNavHost
import com.rsr41.oracle.ui.theme.OracleTheme
import dagger.hilt.android.AndroidEntryPoint
import timber.log.Timber
import java.util.Locale
import javax.inject.Inject

/**
 * 메인 액티비티
 * - Hilt 주입 지원
 * - Deep Link 처리
 * - 테마/언어 설정 적용
 */
@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    
    @Inject
    lateinit var settingsRepository: com.rsr41.oracle.repository.SettingsRepository
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        // Deep link token 추출
        val deepLinkToken = extractTokenFromIntent()
        Timber.d("MainActivity created, deepLinkToken: $deepLinkToken")
        
        setContent {
            // Global Settings Observation
            val themeMode by settingsRepository.themeMode.collectAsState(initial = ThemeMode.SYSTEM)
            val appLanguage by settingsRepository.appLanguage.collectAsState(initial = AppLanguage.SYSTEM)

            // Dynamic Theme Application
            val isDarkTheme = when (themeMode) {
                ThemeMode.LIGHT -> false
                ThemeMode.DARK -> true
                ThemeMode.SYSTEM -> isSystemInDarkTheme()
            }
            
            // Locale Application
            LaunchedEffect(appLanguage) {
                applyLanguage(appLanguage)
            }
            
            OracleTheme(darkTheme = isDarkTheme) {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    OracleNavHost(initialToken = deepLinkToken)
                }
            }
        }
    }
    
    private fun applyLanguage(language: AppLanguage) {
        val localeList = when (language) {
            AppLanguage.KOREAN -> androidx.core.os.LocaleListCompat.create(java.util.Locale.KOREAN)
            AppLanguage.ENGLISH -> androidx.core.os.LocaleListCompat.create(java.util.Locale.ENGLISH)
            AppLanguage.SYSTEM -> androidx.core.os.LocaleListCompat.getEmptyLocaleList()
        }
        androidx.appcompat.app.AppCompatDelegate.setApplicationLocales(localeList)
        Timber.d("Applied language: $language")
    }
    
    private fun extractTokenFromIntent(): String? {
        val uri = intent?.data ?: return null
        // oracle://tag/{token} or https://domain/tag/{token}
        return when {
            uri.host == "tag" && uri.pathSegments.isNotEmpty() -> uri.pathSegments.first()
            uri.pathSegments.size >= 2 && uri.pathSegments[0] == "tag" -> uri.pathSegments[1]
            else -> null
        }
    }
}