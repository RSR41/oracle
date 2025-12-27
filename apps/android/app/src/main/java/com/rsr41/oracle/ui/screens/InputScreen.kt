package com.rsr41.oracle.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.Gender
import com.rsr41.oracle.ui.components.SelectableChipRow

/**
 * 입력 화면
 * - 생년월일, 시간, 성별, 달력 타입 입력
 * - 유효성 검증 후 결과 화면으로 이동
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InputScreen(
    viewModel: InputViewModel,
    onNavigate: (String) -> Unit
) {
    // 네비게이션 이벤트 처리
    LaunchedEffect(viewModel.shouldNavigateToResult) {
        if (viewModel.shouldNavigateToResult) {
            viewModel.onNavigatedToResult()
            onNavigate("RESULT")
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("사주 입력") },
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
            // 날짜 입력
            OutlinedTextField(
                value = viewModel.date,
                onValueChange = { viewModel.updateDate(it) },
                label = { Text("생년월일 (yyyy-MM-dd)") },
                placeholder = { Text("1990-01-01") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                isError = viewModel.dateError != null,
                supportingText = {
                    viewModel.dateError?.let {
                        Text(it, color = MaterialTheme.colorScheme.error)
                    }
                },
                singleLine = true
            )

            // 시간 입력
            OutlinedTextField(
                value = viewModel.time,
                onValueChange = { viewModel.updateTime(it) },
                label = { Text("태어난 시간 (HH:mm) - 선택사항") },
                placeholder = { Text("12:00 또는 비워두기") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                isError = viewModel.timeError != null,
                supportingText = {
                    viewModel.timeError?.let {
                        Text(it, color = MaterialTheme.colorScheme.error)
                    }
                },
                singleLine = true
            )

            // 성별 선택
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceVariant
                )
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        "성별",
                        style = MaterialTheme.typography.titleSmall,
                        color = MaterialTheme.colorScheme.primary
                    )
                    SelectableChipRow(
                        options = Gender.entries.toList(),
                        selectedOption = viewModel.gender,
                        onOptionSelected = { viewModel.updateGender(it) },
                        labelProvider = { if (it == Gender.MALE) "남성 (男)" else "여성 (女)" }
                    )
                }
            }

            // 달력 타입 선택
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceVariant
                )
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        "달력 유형 (설정 기본값: ${if (viewModel.calendarType == CalendarType.SOLAR) "양력" else "음력"})",
                        style = MaterialTheme.typography.titleSmall,
                        color = MaterialTheme.colorScheme.primary
                    )
                    SelectableChipRow(
                        options = CalendarType.entries.toList(),
                        selectedOption = viewModel.calendarType,
                        onOptionSelected = { viewModel.updateCalendarType(it) },
                        labelProvider = { if (it == CalendarType.SOLAR) "양력 (陽)" else "음력 (陰)" }
                    )
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // 결과 보기 버튼
            Button(
                onClick = { viewModel.validateAndGenerateResult() },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primary
                )
            ) {
                Text("운세 보기", style = MaterialTheme.typography.titleMedium)
            }

            Spacer(modifier = Modifier.height(16.dp))

            // 하단 네비게이션 버튼들
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                OutlinedButton(
                    onClick = { onNavigate("HISTORY") },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("히스토리")
                }
                OutlinedButton(
                    onClick = { onNavigate("SETTINGS") },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("설정")
                }
            }
        }
    }
}
