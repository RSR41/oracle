package com.rsr41.oracle.ui.navigation

import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
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
import com.rsr41.oracle.ui.screens.dream.DreamScreen
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
    const val DREAM = "DREAM"
}

/**
 * 앱 네비게이션 그래프
 */
@Composable
fun OracleNavHost(
    navController: NavHostController = rememberNavController(),
    initialToken: String? = null
) {
    // 딥링크 토큰 처리
    LaunchedEffect(initialToken) {
        if (!initialToken.isNullOrBlank()) {
            // 토큰이 있으면 결과 화면으로 즉시 이동하거나 특정 로직 수행
            // navController.navigate("${Routes.RESULT}?token=$initialToken")
        }
    }

    NavHost(
        navController = navController,
        startDestination = Routes.HOME
    ) {
        composable(Routes.HOME) {
            val historyViewModel: HistoryViewModel = hiltViewModel()
            val settingsViewModel: SettingsViewModel = hiltViewModel()
            val fortuneViewModel: FortuneViewModel = hiltViewModel()
            val compatibilityViewModel: CompatibilityViewModel = hiltViewModel()
            
            HomeScreen(
                onNavigateToInput = { navController.navigate(Routes.INPUT) },
                onNavigateToResult = { navController.navigate(Routes.RESULT) },
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
                onNavigateToTarot = { navController.navigate(Routes.TAROT) },
                onNavigateToDream = { navController.navigate(Routes.DREAM) }
            )
        }
        
        composable(Routes.INPUT) {
            val inputViewModel: InputViewModel = hiltViewModel()
            val resultViewModel: ResultViewModel = hiltViewModel()
            
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
            val resultViewModel: ResultViewModel = hiltViewModel()
            
            ResultScreen(
                viewModel = resultViewModel,
                onNavigate = { route -> navController.navigate(route) },
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.HISTORY) {
            val historyViewModel: HistoryViewModel = hiltViewModel()
            val resultViewModel: ResultViewModel = hiltViewModel()
            
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
            val settingsViewModel: SettingsViewModel = hiltViewModel()
            
            SettingsScreen(
                viewModel = settingsViewModel,
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.FORTUNE) {
            val fortuneViewModel: FortuneViewModel = hiltViewModel()
            
            FortuneScreen(
                viewModel = fortuneViewModel,
                onBack = { navController.popBackStack() },
                onNavigateToInput = { navController.navigate(Routes.INPUT) }
            )
        }
        
        composable(Routes.COMPATIBILITY) {
            val compatibilityViewModel: CompatibilityViewModel = hiltViewModel()
            
            CompatibilityScreen(
                viewModel = compatibilityViewModel,
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.FACE) {
            val faceViewModel: FaceViewModel = hiltViewModel()
            
            FaceReadingScreen(
                viewModel = faceViewModel,
                onBack = { navController.popBackStack() }
            )
        }
        
        composable(Routes.TAROT) {
            TarotScreen(onBack = { navController.popBackStack() })
        }
        
        composable(Routes.DREAM) {
            DreamScreen(onBack = { navController.popBackStack() })
        }
    }
}
