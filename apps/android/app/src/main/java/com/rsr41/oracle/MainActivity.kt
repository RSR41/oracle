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
    lateinit var preferencesManager: PreferencesManager
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        // Deep link token 추출
        val deepLinkToken = extractTokenFromIntent()
        Timber.d("MainActivity created, deepLinkToken: $deepLinkToken")
        
        // 저장된 언어 설정 적용
        applyLanguage(preferencesManager.loadAppLanguage())
        
        setContent {
            // 저장된 테마 로드 및 상태 관리
            var themeMode by remember { mutableStateOf(preferencesManager.loadThemeMode()) }
            
            // ThemeMode 변경 시 즉시 반영을 위한 LaunchedEffect
            // (SettingsScreen에서 변경 시 이 Activity가 refresh되면 자동 적용)
            val isDarkTheme = when (themeMode) {
                ThemeMode.LIGHT -> false
                ThemeMode.DARK -> true
                ThemeMode.SYSTEM -> isSystemInDarkTheme()
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
    
    override fun onResume() {
        super.onResume()
        // 설정 화면에서 돌아올 때 언어/테마 재적용
        applyLanguage(preferencesManager.loadAppLanguage())
    }
    
    private fun applyLanguage(language: AppLanguage) {
        val locale = when (language) {
            AppLanguage.KOREAN -> Locale.KOREAN
            AppLanguage.ENGLISH -> Locale.ENGLISH
            AppLanguage.SYSTEM -> Locale.getDefault()
        }
        
        val config = Configuration(resources.configuration)
        config.setLocale(locale)
        
        @Suppress("DEPRECATION")
        resources.updateConfiguration(config, resources.displayMetrics)
        
        Timber.d("Applied language: $language, locale: $locale")
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