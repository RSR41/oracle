package com.rsr41.oracle.ui.screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.rsr41.oracle.R
import com.rsr41.oracle.core.util.DateTimeUtil
import com.rsr41.oracle.domain.model.HistoryRecord
import com.rsr41.oracle.domain.model.HistoryType
import com.rsr41.oracle.ui.components.*
import java.text.SimpleDateFormat
import java.util.*

@Composable
fun HistoryScreen(
    viewModel: HistoryViewModel,
    onNavigate: (String) -> Unit,
    onBack: () -> Unit
) {
    // Navigation effect
    LaunchedEffect(viewModel.shouldNavigateToResult) {
        if (viewModel.shouldNavigateToResult) {
            onNavigate("RESULT") 
            viewModel.onNavigatedToResult()
        }
    }

    // Clear dialog
    var showClearDialog by remember { mutableStateOf(false) }

    if (showClearDialog) {
        AlertDialog(
            onDismissRequest = { showClearDialog = false },
            title = { Text(stringResource(R.string.history_clear_title), style = MaterialTheme.typography.titleLarge) },
            text = { Text(stringResource(R.string.history_clear_confirm), style = MaterialTheme.typography.bodyMedium) },
            confirmButton = {
                TextButton(
                    onClick = {
                        viewModel.clearAll()
                        showClearDialog = false
                    }
                ) {
                    Text(stringResource(R.string.common_delete), color = MaterialTheme.colorScheme.error, fontWeight = FontWeight.Bold)
                }
            },
            dismissButton = {
                TextButton(onClick = { showClearDialog = false }) {
                    Text(stringResource(R.string.common_cancel), color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f))
                }
            },
            containerColor = MaterialTheme.colorScheme.surface,
            shape = RoundedCornerShape(24.dp)
        )
    }

    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.common_history),
                onBack = onBack,
                actions = {
                    if (viewModel.historyRecords.isNotEmpty()) {
                        IconButton(onClick = { showClearDialog = true }) {
                            Icon(Icons.Filled.DeleteSweep, stringResource(R.string.history_clear_all_desc), tint = MaterialTheme.colorScheme.onSurface)
                        }
                    }
                }
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        ) {
            // Filters & Controls
            Column(
                modifier = Modifier
                    .padding(horizontal = 24.dp)
                    .padding(top = 16.dp, bottom = 24.dp)
            ) {
                // Filters
                LazyRow(
                    horizontalArrangement = Arrangement.spacedBy(10.dp),
                    contentPadding = PaddingValues(end = 24.dp)
                ) {
                    item {
                        PremiumFilterChip(
                            selected = viewModel.selectedFilter == null,
                            label = "전체",
                            onClick = { viewModel.setFilter(null) }
                        )
                    }
                    items(HistoryType.entries.toTypedArray()) { type ->
                        val label = when(type) {
                            HistoryType.SAJU_FORTUNE -> "사주"
                            HistoryType.MANSE_DAEUN -> "만세력"
                            HistoryType.MANSE_SEUN -> null
                            HistoryType.MANSE_WOLUN -> null
                            HistoryType.COMPATIBILITY -> "궁합"
                            HistoryType.TAROT -> "타로"
                            HistoryType.FACE -> "관상"
                            HistoryType.DREAM -> "꿈해몽"
                        }
                        
                        if (label != null) {
                            PremiumFilterChip(
                                selected = viewModel.selectedFilter == type,
                                label = label,
                                onClick = { viewModel.setFilter(type) }
                            )
                        }
                    }
                }
                
                Spacer(modifier = Modifier.height(24.dp))
                
                // Premium Toggle
                OracleCard(
                    backgroundColor = MaterialTheme.colorScheme.secondary.copy(alpha = 0.05f)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Column {
                            Text(
                                text = "프리미엄 모드",
                                style = MaterialTheme.typography.titleSmall,
                                color = MaterialTheme.colorScheme.secondary
                            )
                            Text(
                                text = if (viewModel.isPremium) "자동 삭제 비활성화됨" else "기록이 자동으로 정리됩니다",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                            )
                        }
                        Switch(
                            checked = viewModel.isPremium,
                            onCheckedChange = { viewModel.togglePremium() },
                            colors = SwitchDefaults.colors(
                                checkedTrackColor = MaterialTheme.colorScheme.secondary
                            )
                        )
                    }
                }
            }

            // List
            if (viewModel.isLoading) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator(color = MaterialTheme.colorScheme.primary)
                }
            } else if (viewModel.historyRecords.isEmpty()) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Icon(Icons.Default.History, null, modifier = Modifier.size(64.dp), tint = MaterialTheme.colorScheme.outline)
                        Spacer(modifier = Modifier.height(16.dp))
                        Text(
                            stringResource(R.string.history_empty_state),
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.outline
                        )
                    }
                }
            } else {
                LazyColumn(
                    modifier = Modifier.weight(1f),
                    contentPadding = PaddingValues(horizontal = 24.dp, vertical = 8.dp),
                    verticalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    items(viewModel.historyRecords) { record ->
                        HistoryRecordItem(
                            record = record,
                            onDelete = { viewModel.deleteRecord(record.id) },
                            onClick = { viewModel.selectRecord(record) }
                        )
                    }
                    item { Spacer(modifier = Modifier.height(32.dp)) }
                }
            }
        }
    }
}

@Composable
private fun PremiumFilterChip(
    selected: Boolean,
    label: String,
    onClick: () -> Unit
) {
    Surface(
        onClick = onClick,
        shape = RoundedCornerShape(12.dp),
        color = if (selected) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.surface,
        border = if (selected) null else BorderStroke(1.dp, MaterialTheme.colorScheme.outline.copy(alpha = 0.3f)),
        modifier = Modifier.height(40.dp)
    ) {
        Box(
            modifier = Modifier.padding(horizontal = 16.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = label,
                style = MaterialTheme.typography.labelLarge,
                color = if (selected) MaterialTheme.colorScheme.onPrimary else MaterialTheme.colorScheme.onSurface,
                fontWeight = if (selected) FontWeight.Bold else FontWeight.Normal
            )
        }
    }
}

@Composable
private fun HistoryRecordItem(
    record: HistoryRecord,
    onDelete: () -> Unit,
    onClick: () -> Unit
) {
    val icon = when (record.type) {
        HistoryType.SAJU_FORTUNE -> Icons.Filled.AutoAwesome
        HistoryType.TAROT -> Icons.Filled.Style
        HistoryType.FACE -> Icons.Filled.Face
        HistoryType.COMPATIBILITY -> Icons.Filled.Favorite
        HistoryType.MANSE_DAEUN, HistoryType.MANSE_SEUN, HistoryType.MANSE_WOLUN -> Icons.Filled.DateRange
        HistoryType.DREAM -> Icons.Filled.Cloud
    }

    OracleCard(onClick = onClick) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.fillMaxWidth()
        ) {
            Surface(
                shape = RoundedCornerShape(12.dp),
                color = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f),
                modifier = Modifier.size(48.dp)
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Icon(icon, null, tint = MaterialTheme.colorScheme.primary, modifier = Modifier.size(24.dp))
                }
            }
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = record.title,
                    fontWeight = FontWeight.Bold,
                    style = MaterialTheme.typography.titleMedium,
                    color = MaterialTheme.colorScheme.onSurface
                )
                Text(
                    text = record.summary,
                    style = MaterialTheme.typography.bodySmall,
                    maxLines = 1,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                )
                Spacer(modifier = Modifier.height(6.dp))
                Text(
                    text = DateTimeUtil.formatMillisToDateTime(record.createdAt),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.4f)
                )
            }
            IconButton(onClick = onDelete) {
                Icon(Icons.Filled.Close, stringResource(R.string.common_delete), modifier = Modifier.size(18.dp), tint = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.3f))
            }
        }
    }
}