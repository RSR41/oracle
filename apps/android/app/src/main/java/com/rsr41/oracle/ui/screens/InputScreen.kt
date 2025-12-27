package com.rsr41.oracle.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.rsr41.oracle.R
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.Gender
import com.rsr41.oracle.ui.components.SelectableChipRow

/**
 * 사주 정보 입력 화면
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InputScreen(
    viewModel: InputViewModel,
    onNavigate: (String) -> Unit
) {
    LaunchedEffect(viewModel.shouldNavigateToResult) {
        if (viewModel.shouldNavigateToResult) {
            onNavigate("RESULT")
            viewModel.onNavigatedToResult()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.profile_setup_title)) },
                navigationIcon = {
                    IconButton(onClick = { onNavigate("HOME") }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, stringResource(R.string.common_back))
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer
                )
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            // 닉네임
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(stringResource(R.string.profile_nickname), style = MaterialTheme.typography.titleSmall)
                    Spacer(modifier = Modifier.height(8.dp))
                    OutlinedTextField(
                        value = viewModel.nickname,
                        onValueChange = { viewModel.updateNickname(it) },
                        modifier = Modifier.fillMaxWidth(),
                        isError = viewModel.nicknameError != null,
                        supportingText = viewModel.nicknameError?.let { { Text(it) } }
                    )
                }
            }

            // 생년월일
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(stringResource(R.string.profile_birth_date), style = MaterialTheme.typography.titleSmall)
                    Spacer(modifier = Modifier.height(8.dp))
                    OutlinedTextField(
                        value = viewModel.date,
                        onValueChange = { viewModel.updateDate(it) },
                        modifier = Modifier.fillMaxWidth(),
                        placeholder = { Text("1990-01-01") },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        isError = viewModel.dateError != null,
                        supportingText = viewModel.dateError?.let { { Text(it) } }
                    )
                }
            }

            // 태어난 시간
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(stringResource(R.string.profile_birth_time), style = MaterialTheme.typography.titleSmall)
                    Spacer(modifier = Modifier.height(8.dp))
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        OutlinedTextField(
                            value = viewModel.time,
                            onValueChange = { viewModel.updateTime(it) },
                            modifier = Modifier.weight(1f),
                            enabled = !viewModel.timeUnknown,
                            placeholder = { Text("14:30") },
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                            isError = viewModel.timeError != null,
                            supportingText = viewModel.timeError?.let { { Text(it) } }
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Checkbox(
                                checked = viewModel.timeUnknown,
                                onCheckedChange = { viewModel.toggleTimeUnknown(it) }
                            )
                            Text(stringResource(R.string.profile_birth_time_unknown), style = MaterialTheme.typography.bodySmall)
                        }
                    }
                }
            }

            // 성별 & 매력 타입
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(stringResource(R.string.profile_gender), style = MaterialTheme.typography.titleSmall)
                    SelectableChipRow(
                        options = Gender.entries.toList(),
                        selectedOption = viewModel.gender,
                        onOptionSelected = { viewModel.updateGender(it) },
                        labelProvider = { it.displayName }
                    )

                    Spacer(modifier = Modifier.height(16.dp))

                    Text(stringResource(R.string.profile_calendar_type), style = MaterialTheme.typography.titleSmall)
                    SelectableChipRow(
                        options = CalendarType.entries.toList(),
                        selectedOption = viewModel.calendarType,
                        onOptionSelected = { viewModel.updateCalendarType(it) },
                        labelProvider = { it.displayName }
                    )
                }
            }

            // 프로필 저장 체크
            Row(verticalAlignment = Alignment.CenterVertically) {
                Checkbox(
                    checked = viewModel.isSaveProfileChecked,
                    onCheckedChange = { viewModel.toggleSaveProfile(it) }
                )
                Text(stringResource(R.string.profile_save_for_later), style = MaterialTheme.typography.bodyMedium)
            }

            Button(
                onClick = { viewModel.validateAndGenerateResult() },
                modifier = Modifier.fillMaxWidth().height(56.dp)
            ) {
                Text(stringResource(R.string.input_view_result_btn))
            }
        }
    }
}
