package com.rsr41.oracle.ui.screens.home

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
import com.rsr41.oracle.R

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
    onNavigateToTarot: () -> Unit
) {
    val context = LocalContext.current
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.home_title), fontWeight = FontWeight.Bold) },
                actions = {
                    IconButton(onClick = onNavigateToHistory) {
                        Icon(Icons.Default.History, stringResource(R.string.common_history))
                    }
                    IconButton(onClick = onNavigateToSettings) {
                        Icon(Icons.Default.Settings, stringResource(R.string.common_settings))
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer
                )
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // 오늘의 운세 카드
            item {
                TodayFortuneCard(
                    onClick = onNavigateToInput
                )
            }

            // 기능 메뉴 타이틀
            item {
                Text(
                    stringResource(R.string.home_menu),
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )
            }

            // 기능 그리드
            item {
                FeatureGrid(
                    onNavigateToInput = onNavigateToInput,
                    onNavigateToFortune = onNavigateToFortune,
                    onNavigateToCompatibility = onNavigateToCompatibility,
                    onNavigateToFace = onNavigateToFace,
                    onNavigateToTarot = onNavigateToTarot,
                    onNotReady = {
                        Toast.makeText(context, R.string.menu_not_ready, Toast.LENGTH_SHORT).show()
                    }
                )
            }
        }
    }
}

@Composable
private fun TodayFortuneCard(onClick: () -> Unit) {
    Card(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        )
    ) {
        Column(modifier = Modifier.padding(20.dp)) {
            Text(
                stringResource(R.string.home_today_fortune),
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold
            )
            Spacer(modifier = Modifier.height(12.dp))
            Text(
                stringResource(R.string.home_today_fortune_desc),
                style = MaterialTheme.typography.bodyLarge
            )
            Spacer(modifier = Modifier.height(16.dp))
            Button(onClick = onClick) {
                Icon(Icons.Default.ArrowForward, null)
                Spacer(modifier = Modifier.width(8.dp))
                Text(stringResource(R.string.home_view_fortune))
            }
        }
    }
}

@Composable
private fun FeatureGrid(
    onNavigateToInput: () -> Unit,
    onNavigateToFortune: () -> Unit,
    onNavigateToCompatibility: () -> Unit,
    onNavigateToFace: () -> Unit,
    onNavigateToTarot: () -> Unit,
    onNotReady: () -> Unit
) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            FeatureCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_saju),
                icon = Icons.Default.AutoAwesome,
                onClick = onNavigateToInput
            )
            FeatureCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_manse),
                icon = Icons.Default.Timeline,
                onClick = onNavigateToFortune
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            FeatureCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_compatibility),
                icon = Icons.Default.Favorite,
                onClick = onNavigateToCompatibility
            )
            FeatureCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_face),
                icon = Icons.Default.Face,
                onClick = onNavigateToFace
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            FeatureCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_tarot),
                icon = Icons.Default.Style,
                onClick = onNavigateToTarot
            )
            FeatureCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.menu_dream),
                icon = Icons.Default.Nightlight,
                onClick = onNotReady
            )
        }
    }
}

@Composable
private fun FeatureCard(
    modifier: Modifier = Modifier,
    title: String,
    icon: ImageVector,
    onClick: () -> Unit
) {
    Card(
        onClick = onClick,
        modifier = modifier.height(100.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Icon(
                imageVector = icon,
                contentDescription = title,
                tint = MaterialTheme.colorScheme.primary,
                modifier = Modifier.size(32.dp)
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                title,
                style = MaterialTheme.typography.titleMedium
            )
        }
    }
}
