package com.rsr41.oracle.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.rsr41.oracle.R
import com.rsr41.oracle.core.util.DateTimeUtil
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.Gender
import com.rsr41.oracle.ui.components.SectionCard
import androidx.compose.ui.res.stringResource

/**
 * 결과 화면
 * - 마지막 사주 결과 표시
 * - 다시 입력하기, 히스토리 보기 네비게이션
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ResultScreen(
    viewModel: ResultViewModel,
    onNavigate: (String) -> Unit,
    onBack: () -> Unit
) {
    val historyItem = viewModel.historyItem

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.result_title)) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = stringResource(R.string.common_back)
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer
                )
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .padding(16.dp)
                .fillMaxSize()
                .verticalScroll(rememberScrollState()),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            if (viewModel.isLoading) {
                CircularProgressIndicator()
            } else if (historyItem != null) {
                val item = historyItem
                val birthInfo = item.birthInfo
                val result = item.result

                // 입력 정보 요약
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.secondaryContainer
                    )
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text(
                            stringResource(R.string.result_input_summary),
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(stringResource(R.string.result_birth_date, birthInfo.date))
                        Text(stringResource(R.string.result_birth_time, birthInfo.time.ifBlank { stringResource(R.string.common_not_entered) }))
                        Text(stringResource(R.string.result_gender, if (birthInfo.gender == Gender.MALE) stringResource(R.string.common_male) else stringResource(R.string.common_female)))
                        Text(stringResource(R.string.result_calendar, if (birthInfo.calendarType == CalendarType.SOLAR) stringResource(R.string.common_solar) else stringResource(R.string.common_lunar)))
                        Text(
                            stringResource(R.string.result_generated_at, DateTimeUtil.formatMillisToDateTime(result.generatedAtMillis)),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.outline
                        )
                    }
                }

                // 사주 기둥
                SectionCard(
                    title = stringResource(R.string.result_pillars_title),
                    content = result.pillars
                )

                // 오늘의 총운
                SectionCard(
                    title = stringResource(R.string.result_summary_title),
                    content = result.summaryToday
                )

                Spacer(modifier = Modifier.height(16.dp))

                // 하단 버튼들
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    OutlinedButton(
                        onClick = onBack,
                        modifier = Modifier.weight(1f)
                    ) {
                        Text(stringResource(R.string.result_retry_btn))
                    }
                    Button(
                        onClick = { onNavigate("HISTORY") },
                        modifier = Modifier.weight(1f)
                    ) {
                        Text(stringResource(R.string.common_history))
                    }
                }
            } else {
                // 결과 없음
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.errorContainer
                    )
                ) {
                    Column(
                        modifier = Modifier.padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            stringResource(R.string.result_not_found),
                            style = MaterialTheme.typography.titleMedium
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(stringResource(R.string.result_not_found_desc))
                    }
                }

                Button(onClick = onBack) {
                    Text(stringResource(R.string.result_go_to_input))
                }
            }
        }
    }
}
