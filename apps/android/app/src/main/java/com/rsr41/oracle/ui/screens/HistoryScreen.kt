package com.rsr41.oracle.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.rsr41.oracle.R
import com.rsr41.oracle.domain.model.HistoryRecord
import com.rsr41.oracle.domain.model.HistoryType
import java.text.SimpleDateFormat
import java.util.*

/**
 * 히스토리 화면
 * - 최근 조회 목록 표시 (최대 10개)
 * - 항목 클릭 시 결과 화면으로 이동
 * - 단건 삭제 및 전체 삭제 기능
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HistoryScreen(
    viewModel: HistoryViewModel,
    onNavigate: (String) -> Unit,
    onBack: () -> Unit
) {
    // 네비게이션 이벤트 처리
    LaunchedEffect(viewModel.shouldNavigateToResult) {
        if (viewModel.shouldNavigateToResult) {
            onNavigate("RESULT")
            viewModel.onNavigatedToResult()
        }
    }

    // 전체 삭제 확인 다이얼로그 상태
    var showClearDialog by remember { mutableStateOf(false) }

    if (showClearDialog) {
        AlertDialog(
            onDismissRequest = { showClearDialog = false },
            title = { Text(stringResource(R.string.history_clear_title)) },
            text = { Text(stringResource(R.string.history_clear_confirm)) },
            confirmButton = {
                TextButton(
                    onClick = {
                        viewModel.clearAll()
                        showClearDialog = false
                    }
                ) {
                    Text(stringResource(R.string.common_delete), color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { showClearDialog = false }) {
                    Text(stringResource(R.string.common_cancel))
                }
            }
        )
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.common_history)) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, stringResource(R.string.common_back))
                    }
                },
                actions = {
                    if (viewModel.historyRecords.isNotEmpty() || viewModel.historyList.isNotEmpty()) {
                        IconButton(onClick = { showClearDialog = true }) {
                            Icon(Icons.Filled.DeleteSweep, stringResource(R.string.history_clear_all_desc))
                        }
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer
                )
            )
        }
    ) { innerPadding ->
        if (viewModel.isLoading) {
            Box(Modifier.fillMaxSize().padding(innerPadding), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        } else if (viewModel.historyRecords.isEmpty() && viewModel.historyList.isEmpty()) {
            Box(Modifier.fillMaxSize().padding(innerPadding), contentAlignment = Alignment.Center) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        stringResource(R.string.history_empty_state),
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.outline
                    )
                }
            }
        } else {
            LazyColumn(
                modifier = Modifier.fillMaxSize().padding(innerPadding),
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                // 신규 히스토리 레코드
                items(viewModel.historyRecords) { record ->
                    HistoryRecordItem(
                        record = record,
                        onDelete = { viewModel.deleteRecord(record.id) },
                        onClick = { viewModel.selectRecord(record) }
                    )
                }

                // 레거시 히스토리 (호환)
                if (viewModel.historyList.isNotEmpty()) {
                    item {
                        Text(stringResource(R.string.history_legacy_title), style = MaterialTheme.typography.titleSmall, modifier = Modifier.padding(top = 8.dp))
                    }
                    items(viewModel.historyList) { item ->
                        LegacyHistoryItemView(
                            item = item,
                            onDelete = { viewModel.deleteItem(item.id) },
                            onClick = { viewModel.selectLegacyItem(item) }
                        )
                    }
                }
            }
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
        else -> Icons.Filled.History
    }

    Card(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(icon, null, tint = MaterialTheme.colorScheme.primary, modifier = Modifier.size(32.dp))
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(record.title, fontWeight = FontWeight.Bold)
                Text(record.summary, style = MaterialTheme.typography.bodySmall, maxLines = 1)
                Text(
                    formatDate(record.createdAt),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.outline
                )
            }
            IconButton(onClick = onDelete) {
                Icon(Icons.Filled.Close, stringResource(R.string.common_delete), modifier = Modifier.size(20.dp))
            }
        }
    }
}

@Composable
private fun LegacyHistoryItemView(
    item: com.rsr41.oracle.domain.model.HistoryItem,
    onDelete: () -> Unit,
    onClick: () -> Unit
) {
    Card(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(Icons.Filled.History, null, tint = MaterialTheme.colorScheme.outline)
            Spacer(modifier = Modifier.width(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(stringResource(R.string.history_legacy_item_title), style = MaterialTheme.typography.labelMedium)
                Text("${item.birthInfo.date} (${if (item.birthInfo.gender == com.rsr41.oracle.domain.model.Gender.MALE) stringResource(R.string.common_male_short) else stringResource(R.string.common_female_short)})", 
                    style = MaterialTheme.typography.bodySmall)
            }
            IconButton(onClick = onDelete) {
                Icon(Icons.Filled.Delete, stringResource(R.string.common_delete), modifier = Modifier.size(18.dp))
            }
        }
    }
}

private fun formatDate(millis: Long): String {
    val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
    return sdf.format(Date(millis))
}
