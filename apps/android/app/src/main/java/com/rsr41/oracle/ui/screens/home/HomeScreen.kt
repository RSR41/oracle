package com.rsr41.oracle.ui.screens.home

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import android.widget.Toast
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import com.rsr41.oracle.R
import com.rsr41.oracle.ui.components.*

/**
 * 홈 화면 - 오늘의 운세 프리뷰 + 기능 메뉴
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    onNavigateToInput: () -> Unit,
    onNavigateToResult: () -> Unit,
    onNavigateToHistory: () -> Unit,
    onNavigateToSettings: () -> Unit,
    onNavigateToFortune: () -> Unit,
    onNavigateToCompatibility: () -> Unit,
    onNavigateToFace: () -> Unit,
    onNavigateToTarot: () -> Unit,
    onNavigateToDream: () -> Unit
) {
    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.home_title),
                actions = {
                    IconButton(onClick = onNavigateToHistory) {
                        Icon(Icons.Default.History, stringResource(R.string.common_history), tint = MaterialTheme.colorScheme.onSurface)
                    }
                    IconButton(onClick = onNavigateToSettings) {
                        Icon(Icons.Default.Settings, stringResource(R.string.common_settings), tint = MaterialTheme.colorScheme.onSurface)
                    }
                }
            )
        }
    ) {
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp),
            contentPadding = PaddingValues(bottom = 32.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            item { Spacer(modifier = Modifier.height(8.dp)) }

            // Today's Fortune (Main Hero)
            item {
                TodayFortuneCard(
                    onClick = onNavigateToInput
                )
            }

            // Daily Lucky Color (New)
            item {
                DailyLuckyCard()
            }

            // Menu Section
            item {
                OracleSectionTitle(
                    text = stringResource(R.string.home_menu)
                )
            }

            item {
                FeatureGrid(
                    onNavigateToInput = onNavigateToInput,
                    onNavigateToFortune = onNavigateToFortune,
                    onNavigateToCompatibility = onNavigateToCompatibility,
                    onNavigateToFace = onNavigateToFace,
                    onNavigateToTarot = onNavigateToTarot,
                    onNavigateToDream = onNavigateToDream
                )
            }
        }
    }
}

@Composable
private fun TodayFortuneCard(onClick: () -> Unit) {
    OracleCard(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth(),
        backgroundColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    stringResource(R.string.home_today_fortune),
                    style = MaterialTheme.typography.headlineMedium,
                    color = MaterialTheme.colorScheme.primary
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    stringResource(R.string.home_today_fortune_desc),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f)
                )
            }
            Icon(
                imageVector = Icons.Default.AutoAwesome,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.primary,
                modifier = Modifier.size(48.dp)
            )
        }
        Spacer(modifier = Modifier.height(24.dp))
        OracleButton(
            text = stringResource(R.string.home_view_fortune),
            onClick = onClick,
            modifier = Modifier.fillMaxWidth()
        )
    }
}

@Composable
private fun FeatureGrid(
    onNavigateToInput: () -> Unit,
    onNavigateToFortune: () -> Unit,
    onNavigateToCompatibility: () -> Unit,
    onNavigateToFace: () -> Unit,
    onNavigateToTarot: () -> Unit,
    onNavigateToDream: () -> Unit
) {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            FeatureItem(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_saju),
                icon = Icons.Default.AutoAwesome,
                onClick = onNavigateToInput
            )
            FeatureItem(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_manse),
                icon = Icons.Default.Timeline,
                onClick = onNavigateToFortune
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            FeatureItem(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_compatibility),
                icon = Icons.Default.Favorite,
                onClick = onNavigateToCompatibility
            )
            FeatureItem(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_face),
                icon = Icons.Default.Face,
                onClick = onNavigateToFace
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            FeatureItem(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_tarot),
                icon = Icons.Default.Style,
                onClick = onNavigateToTarot
            )
            FeatureItem(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_dream),
                icon = Icons.Default.Nightlight,
                onClick = onNavigateToDream
            )
        }
    }
}

@Composable
private fun FeatureItem(
    modifier: Modifier = Modifier,
    title: String,
    icon: ImageVector,
    onClick: () -> Unit
) {
    OracleCard(
        onClick = onClick,
        modifier = modifier.height(110.dp)
    ) {
        Column(
            modifier = Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Icon(
                imageVector = icon,
                contentDescription = title,
                tint = MaterialTheme.colorScheme.primary,
                modifier = Modifier.size(28.dp)
            )
            Spacer(modifier = Modifier.height(12.dp))
            Text(
                title,
                style = MaterialTheme.typography.titleMedium,
                textAlign = TextAlign.Center
            )
        }
    }
}

@Composable
private fun DailyLuckyCard() {
    // Simple deterministic daily color
    val today = java.time.LocalDate.now()
    val colors = listOf(
        stringResource(R.string.color_gold) to androidx.compose.ui.graphics.Color(0xFFFFD700),
        stringResource(R.string.color_red) to androidx.compose.ui.graphics.Color(0xFFFF4500),
        stringResource(R.string.color_blue) to androidx.compose.ui.graphics.Color(0xFF4169E1),
        stringResource(R.string.color_green) to androidx.compose.ui.graphics.Color(0xFF228B22),
        stringResource(R.string.color_silver) to androidx.compose.ui.graphics.Color(0xFFC0C0C0)
    )
    val index = Math.abs(today.hashCode()) % colors.size
    val (colorName, colorValue) = colors[index]

    OracleCard(
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    stringResource(R.string.home_lucky_today_title),
                    style = MaterialTheme.typography.titleMedium,
                    color = MaterialTheme.colorScheme.primary
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    stringResource(R.string.home_lucky_item_fmt, colorName),
                    style = MaterialTheme.typography.bodyMedium
                )
            }
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .background(colorValue, androidx.compose.foundation.shape.CircleShape)
            )
        }
    }
}
