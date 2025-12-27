package com.rsr41.oracle

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.rsr41.oracle.ui.navigation.OracleNavHost
import com.rsr41.oracle.ui.theme.OracleTheme
import dagger.hilt.android.AndroidEntryPoint
import timber.log.Timber

/**
 * 메인 액티비티
 * - Hilt 주입 지원
 * - Deep Link 처리
 */
@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        // Deep link token 추출
        val deepLinkToken = extractTokenFromIntent()
        Timber.d("MainActivity created, deepLinkToken: $deepLinkToken")
        
        setContent {
            OracleTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    OracleNavHost(initialToken = deepLinkToken)
                }
            }
        }
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