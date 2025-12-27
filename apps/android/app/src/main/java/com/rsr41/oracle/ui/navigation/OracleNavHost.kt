package com.rsr41.oracle.ui.navigation

import androidx.compose.runtime.Composable
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.rsr41.oracle.ui.screens.*
import com.rsr41.oracle.ui.screens.home.HomeScreen
import com.rsr41.oracle.ui.screens.fortune.FortuneScreen
import com.rsr41.oracle.ui.screens.compatibility.CompatibilityScreen
import com.rsr41.oracle.ui.screens.face.FaceReadingScreen
import com.rsr41.oracle.ui.screens.tarot.TarotScreen
import com.rsr41.oracle.ui.screens.fortune.FortuneViewModel
import com.rsr41.oracle.ui.screens.face.FaceViewModel
import com.rsr41.oracle.ui.screens.compatibility.CompatibilityViewModel

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
fun OracleNavHost(
    navController: NavHostController = rememberNavController(),
    initialToken: String? = null
) {
    // ViewModels (공유가 필요한 경우 여기서 관리)
    val inputViewModel: InputViewModel = hiltViewModel()
    val resultViewModel: ResultViewModel = hiltViewModel()
    val historyViewModel: HistoryViewModel = hiltViewModel()
    val settingsViewModel: SettingsViewModel = hiltViewModel()
    val compatibilityViewModel: com.rsr41.oracle.ui.screens.compatibility.CompatibilityViewModel = hiltViewModel()
    val fortuneViewModel: com.rsr41.oracle.ui.screens.fortune.FortuneViewModel = hiltViewModel()
    val faceViewModel: com.rsr41.oracle.ui.screens.face.FaceViewModel = hiltViewModel()

    NavHost(
        navController = navController,
        startDestination = Routes.HOME
    ) {
        composable(Routes.HOME) {
            HomeScreen(
                onNavigateToInput = { navController.navigate(Routes.INPUT) },
                onNavigateToResult = { 
                    resultViewModel.loadLastResult()
                    navController.navigate(Routes.RESULT) 
                },
                onNavigateToHistory = { 
                    historyViewModel.loadHistory()
                    navController.navigate(Routes.HISTORY) 
                },
                onNavigateToSettings = { 
                    settingsViewModel.loadSettings()
                    navController.navigate(Routes.SETTINGS) 
                },
                onNavigateToFortune = { 
                    fortuneViewModel.loadProfiles()
                    navController.navigate(Routes.FORTUNE) 
                },
                onNavigateToCompatibility = { 
                    compatibilityViewModel.loadProfiles()
                    navController.navigate(Routes.COMPATIBILITY) 
                },
                onNavigateToFace = { navController.navigate(Routes.FACE) },
                onNavigateToTarot = { navController.navigate(Routes.TAROT) }
            )
        }
        
        composable(Routes.INPUT) {
            InputScreen(
                viewModel = inputViewModel,
                onNavigate = { route ->
                    if (route == "RESULT") {
                        resultViewModel.loadLastResult()
                        navController.navigate(Routes.RESULT)
                    } else {
                        navController.navigate(route)
                    }
                }
            )
        }
        
        composable(Routes.RESULT) {
            ResultScreen(
                viewModel = resultViewModel,
                onNavigate = { route -> navController.navigate(route) },
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.HISTORY) {
            HistoryScreen(
                viewModel = historyViewModel,
                onNavigate = { route -> 
                    if (route == "RESULT") {
                        resultViewModel.loadLastResult()
                        navController.navigate(Routes.RESULT)
                    } else {
                        navController.navigate(route)
                    }
                },
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.SETTINGS) {
            SettingsScreen(
                viewModel = settingsViewModel,
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.FORTUNE) {
            FortuneScreen(
                viewModel = fortuneViewModel,
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.COMPATIBILITY) {
            CompatibilityScreen(
                viewModel = compatibilityViewModel,
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.FACE) {
            FaceReadingScreen(
                viewModel = faceViewModel,
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.TAROT) {
            TarotScreen(onBack = { navController.popBackStack() })
        }
    }
}
