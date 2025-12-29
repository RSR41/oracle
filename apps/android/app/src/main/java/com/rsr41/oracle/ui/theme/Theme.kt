package com.rsr41.oracle.ui.theme

import android.app.Activity
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

private val DarkColorScheme = darkColorScheme(
    primary = OracleGold,
    onPrimary = Color.White,
    secondary = OracleTerracotta,
    onSecondary = Color.White,
    tertiary = OracleGold,
    background = OracleBrown,
    onBackground = OracleOffWhite,
    surface = OracleBrown,
    onSurface = OracleOffWhite,
    surfaceVariant = OracleBrown,
    outline = OracleSand
)

private val LightColorScheme = lightColorScheme(
    primary = OracleBrown,
    onPrimary = Color.White,
    secondary = OracleGold,
    onSecondary = Color.White,
    tertiary = OracleTerracotta,
    background = OracleOffWhite,
    onBackground = OracleBrown,
    surface = OracleSurface,
    onSurface = OracleBrown,
    surfaceVariant = OracleSurface, // Card background
    onSurfaceVariant = OracleBrown,
    outline = OracleSand
)

@Composable
fun OracleTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = false,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }

    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = colorScheme.primary.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = !darkTheme
        }
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}