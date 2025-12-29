package com.rsr41.oracle.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
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
import com.rsr41.oracle.ui.components.*

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

    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.profile_setup_title),
                onBack = { onNavigate("HOME") }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            Spacer(modifier = Modifier.height(8.dp))

            // 닉네임
            OracleCard {
                OracleSectionTitle(stringResource(R.string.profile_nickname))
                OutlinedTextField(
                    value = viewModel.nickname,
                    onValueChange = { viewModel.updateNickname(it) },
                    modifier = Modifier.fillMaxWidth(),
                    isError = viewModel.nicknameError != null,
                    supportingText = viewModel.nicknameError?.let { { Text(it) } },
                    shape = RoundedCornerShape(12.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = MaterialTheme.colorScheme.primary,
                        unfocusedBorderColor = MaterialTheme.colorScheme.outline
                    )
                )
            }

            // 생년월일
            OracleCard {
                OracleSectionTitle(stringResource(R.string.profile_birth_date))
                OutlinedTextField(
                    value = viewModel.date,
                    onValueChange = { viewModel.updateDate(it) },
                    modifier = Modifier.fillMaxWidth(),
                    placeholder = { Text("1990-01-01", color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.3f)) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    isError = viewModel.dateError != null,
                    supportingText = viewModel.dateError?.let { { Text(it) } },
                    shape = RoundedCornerShape(12.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = MaterialTheme.colorScheme.primary,
                        unfocusedBorderColor = MaterialTheme.colorScheme.outline
                    )
                )
            }

            // 태어난 시간
            OracleCard {
                OracleSectionTitle(stringResource(R.string.profile_birth_time))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    OutlinedTextField(
                        value = viewModel.time,
                        onValueChange = { viewModel.updateTime(it) },
                        modifier = Modifier.weight(1f),
                        enabled = !viewModel.timeUnknown,
                        placeholder = { Text("14:30", color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.3f)) },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        isError = viewModel.timeError != null,
                        supportingText = viewModel.timeError?.let { { Text(it) } },
                        shape = RoundedCornerShape(12.dp),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = MaterialTheme.colorScheme.primary,
                            unfocusedBorderColor = MaterialTheme.colorScheme.outline
                        )
                    )
                    Spacer(modifier = Modifier.width(16.dp))
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Checkbox(
                            checked = viewModel.timeUnknown,
                            onCheckedChange = { viewModel.toggleTimeUnknown(it) },
                            colors = CheckboxDefaults.colors(checkedColor = MaterialTheme.colorScheme.primary)
                        )
                        Text(
                            stringResource(R.string.profile_birth_time_unknown),
                            style = MaterialTheme.typography.bodyMedium
                        )
                    }
                }
            }

            // 성별 & 매력 타입
            OracleCard {
                OracleSectionTitle(stringResource(R.string.profile_gender))
                SelectableChipRow(
                    options = Gender.entries.toList(),
                    selectedOption = viewModel.gender,
                    onOptionSelected = { viewModel.updateGender(it) },
                    labelProvider = { it.displayName }
                )

                Spacer(modifier = Modifier.height(24.dp))

                OracleSectionTitle(stringResource(R.string.profile_calendar_type))
                SelectableChipRow(
                    options = CalendarType.entries.toList(),
                    selectedOption = viewModel.calendarType,
                    onOptionSelected = { viewModel.updateCalendarType(it) },
                    labelProvider = { it.displayName }
                )
                
                // 윤달 토글 (음력일 때만 표시)
                if (viewModel.calendarType == CalendarType.LUNAR) {
                     Spacer(modifier = Modifier.height(16.dp))
                     Row(verticalAlignment = Alignment.CenterVertically) {
                        Switch(
                            checked = viewModel.isLeapMonth,
                            onCheckedChange = { viewModel.toggleLeapMonth(it) },
                             colors = SwitchDefaults.colors(checkedTrackColor = MaterialTheme.colorScheme.primary)
                        )
                        Spacer(modifier = Modifier.width(12.dp))
                        Text("윤달 여부", style = MaterialTheme.typography.bodyMedium)
                     }
                }
            }

            // 프로필 저장 체크
            Row(
                modifier = Modifier.padding(horizontal = 8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Checkbox(
                    checked = viewModel.isSaveProfileChecked,
                    onCheckedChange = { viewModel.toggleSaveProfile(it) },
                    colors = CheckboxDefaults.colors(checkedColor = MaterialTheme.colorScheme.primary)
                )
                Text(
                    stringResource(R.string.profile_save_for_later),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.8f)
                )
            }

            OracleButton(
                text = stringResource(R.string.input_view_result_btn),
                onClick = { viewModel.validateAndGenerateResult() },
                modifier = Modifier.fillMaxWidth()
            )
            
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}
