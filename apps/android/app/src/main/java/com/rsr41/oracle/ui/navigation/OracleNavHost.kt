package com.rsr41.oracle.ui.navigation

import androidx.activity.compose.BackHandler
import androidx.compose.runtime.*
import androidx.hilt.navigation.compose.hiltViewModel
import com.rsr41.oracle.ui.screens.*
import com.rsr41.oracle.ui.screens.home.HomeScreen
import com.rsr41.oracle.ui.screens.fortune.FortuneScreen
import com.rsr41.oracle.ui.screens.compatibility.CompatibilityScreen
import com.rsr41.oracle.ui.screens.face.FaceReadingScreen
import com.rsr41.oracle.ui.screens.tarot.TarotScreen

/**
 * 네비게이션 라우트 정의
 */
object Routes {
    const val HOME = "HOME"
    const val INPUT = "INPUT"
    const val RESULT = "RESULT"
    const val HISTORY = "HISTORY"
    const val SETTINGS = "SETTINGS"
    const val FORTUNE = "FORTUNE"
    const val COMPATIBILITY = "COMPATIBILITY"
    const val FACE = "FACE"
    const val TAROT = "TAROT"
}

/**
 * 앱 네비게이션 그래프
 */
@Composable
fun OracleNavHost(initialToken: String? = null) {
    var backStack by remember { mutableStateOf(listOf(Routes.HOME)) }
    val currentRoute = backStack.lastOrNull() ?: Routes.HOME

    // ViewModels
    val inputViewModel: InputViewModel = hiltViewModel()
    val resultViewModel: ResultViewModel = hiltViewModel()
    val historyViewModel: HistoryViewModel = hiltViewModel()
    val settingsViewModel: SettingsViewModel = hiltViewModel()

    val onNavigate: (String) -> Unit = { route ->
        backStack = backStack + route
        when (route) {
            Routes.RESULT -> resultViewModel.loadLastResult()
            Routes.HISTORY -> historyViewModel.loadHistory()
            Routes.SETTINGS -> settingsViewModel.loadSettings()
            Routes.INPUT -> inputViewModel.resetToDefaults()
        }
    }

    val onBack: () -> Unit = {
        if (backStack.size > 1) {
            backStack = backStack.dropLast(1)
        }
    }

    BackHandler(enabled = backStack.size > 1) { onBack() }

    when (currentRoute) {
        Routes.HOME -> HomeScreen(
            onNavigateToInput = { onNavigate(Routes.INPUT) },
            onNavigateToResult = { onNavigate(Routes.RESULT) },
            onNavigateToHistory = { onNavigate(Routes.HISTORY) },
            onNavigateToSettings = { onNavigate(Routes.SETTINGS) },
            onNavigateToFortune = { onNavigate(Routes.FORTUNE) },
            onNavigateToCompatibility = { onNavigate(Routes.COMPATIBILITY) },
            onNavigateToFace = { onNavigate(Routes.FACE) },
            onNavigateToTarot = { onNavigate(Routes.TAROT) }
        )
        Routes.INPUT -> InputScreen(
            viewModel = inputViewModel,
            onNavigate = onNavigate
        )
        Routes.RESULT -> ResultScreen(
            viewModel = resultViewModel,
            onNavigate = onNavigate,
            onBack = onBack
        )
        Routes.HISTORY -> HistoryScreen(
            viewModel = historyViewModel,
            onNavigate = onNavigate,
            onBack = onBack
        )
        Routes.SETTINGS -> SettingsScreen(
            viewModel = settingsViewModel,
            onBack = onBack
        )
        Routes.FORTUNE -> FortuneScreen(onBack = onBack)
        Routes.COMPATIBILITY -> CompatibilityScreen(onBack = onBack)
        Routes.FACE -> FaceReadingScreen(onBack = onBack)
        Routes.TAROT -> TarotScreen(onBack = onBack)
        else -> HomeScreen(
            onNavigateToInput = { onNavigate(Routes.INPUT) },
            onNavigateToResult = { onNavigate(Routes.RESULT) },
            onNavigateToHistory = { onNavigate(Routes.HISTORY) },
            onNavigateToSettings = { onNavigate(Routes.SETTINGS) },
            onNavigateToFortune = { onNavigate(Routes.FORTUNE) },
            onNavigateToCompatibility = { onNavigate(Routes.COMPATIBILITY) },
            onNavigateToFace = { onNavigate(Routes.FACE) },
            onNavigateToTarot = { onNavigate(Routes.TAROT) }
        )
    }
}
