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
import com.rsr41.oracle.core.util.DateTimeUtil
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.Gender
import com.rsr41.oracle.ui.components.SectionCard

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
                title = { Text("사주 결과") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "뒤로"
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
                            "입력 정보",
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("생년월일: ${birthInfo.date}")
                        Text("시간: ${birthInfo.time.ifBlank { "미입력" }}")
                        Text("성별: ${if (birthInfo.gender == Gender.MALE) "남성" else "여성"}")
                        Text("달력: ${if (birthInfo.calendarType == CalendarType.SOLAR) "양력" else "음력"}")
                        Text(
                            "조회시간: ${DateTimeUtil.formatMillisToDateTime(result.generatedAtMillis)}",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.outline
                        )
                    }
                }

                // 사주 기둥
                SectionCard(
                    title = "📊 사주 기둥 (四柱)",
                    content = result.pillars
                )

                // 오늘의 총운
                SectionCard(
                    title = "🔮 오늘의 총운",
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
                        Text("다시 입력")
                    }
                    Button(
                        onClick = { onNavigate("HISTORY") },
                        modifier = Modifier.weight(1f)
                    ) {
                        Text("히스토리")
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
                            "결과를 찾을 수 없습니다",
                            style = MaterialTheme.typography.titleMedium
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("입력 화면에서 정보를 입력해주세요")
                    }
                }

                Button(onClick = onBack) {
                    Text("입력 화면으로")
                }
            }
        }
    }
}
