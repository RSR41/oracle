package com.rsr41.oracle.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Pending
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.rsr41.oracle.R
import com.rsr41.oracle.domain.model.AppLanguage
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.ThemeMode
import com.rsr41.oracle.ui.components.*

/**
 * 설정 화면
 * - 기본 달력 타입(양력/음력) 설정
 * - 언어 설정 (한국어/English/시스템)
 * - 테마 설정 (라이트/다크/시스템)
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(
    viewModel: SettingsViewModel,
    onBack: () -> Unit
) {
    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.common_settings),
                onBack = onBack
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            Spacer(modifier = Modifier.height(8.dp))

            // 언어 설정 (NEW)
            OracleCard {
                OracleSectionTitle(stringResource(R.string.settings_language_title))
                Text(
                    stringResource(R.string.settings_language_desc),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                )
                Spacer(modifier = Modifier.height(16.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    AppLanguage.entries.forEach { language ->
                        FilterChip(
                            selected = viewModel.appLanguage == language,
                            onClick = { viewModel.updateAppLanguage(language) },
                            label = {
                                Text(
                                    when (language) {
                                        AppLanguage.KOREAN -> stringResource(R.string.settings_language_korean)
                                        AppLanguage.ENGLISH -> stringResource(R.string.settings_language_english)
                                        AppLanguage.SYSTEM -> stringResource(R.string.settings_language_system)
                                    }
                                )
                            }
                        )
                    }
                }
            }

            // 테마 설정 (NEW)
            OracleCard {
                OracleSectionTitle(stringResource(R.string.settings_theme_title))
                Text(
                    stringResource(R.string.settings_theme_desc),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                )
                Spacer(modifier = Modifier.height(16.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    ThemeMode.entries.forEach { theme ->
                        FilterChip(
                            selected = viewModel.themeMode == theme,
                            onClick = { viewModel.updateThemeMode(theme) },
                            label = {
                                Text(
                                    when (theme) {
                                        ThemeMode.LIGHT -> stringResource(R.string.settings_theme_light)
                                        ThemeMode.DARK -> stringResource(R.string.settings_theme_dark)
                                        ThemeMode.SYSTEM -> stringResource(R.string.settings_theme_system)
                                    }
                                )
                            }
                        )
                    }
                }
            }

            // 기본 달력 설정
            OracleCard {
                OracleSectionTitle(stringResource(R.string.settings_default_calendar_title))
                Text(
                    stringResource(R.string.settings_default_calendar_desc),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                )
                Spacer(modifier = Modifier.height(16.dp))
                SelectableChipRow(
                    options = CalendarType.entries.toList(),
                    selectedOption = viewModel.calendarType,
                    onOptionSelected = { viewModel.updateCalendarType(it) },
                    labelProvider = { if (it == CalendarType.SOLAR) stringResource(R.string.settings_calendar_solar) else stringResource(R.string.settings_calendar_lunar) }
                )
            }

            // 개인정보 및 유의사항
            OracleCard(
                backgroundColor = MaterialTheme.colorScheme.secondary.copy(alpha = 0.05f)
            ) {
                OracleSectionTitle(
                    text = stringResource(R.string.face_privacy_title),
                    color = MaterialTheme.colorScheme.secondary
                )
                Text(
                    text = stringResource(R.string.face_privacy_desc),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.8f)
                )
                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    text = "• 관상 서비스는 오락 목적으로만 제공됩니다.\n• 민감한 개인 속성(인종, 건강 등) 추정은 수행하지 않습니다.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f),
                    lineHeight = 20.sp
                )
            }

            // 추가 설정 (예정) - 성별/시간만 남김
            OracleCard {
                OracleSectionTitle(stringResource(R.string.settings_upcoming_title))
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    SettingUpcomingItem(stringResource(R.string.settings_upcoming_gender))
                    SettingUpcomingItem(stringResource(R.string.settings_upcoming_time))
                }
            }

            // 앱 정보
            OracleCard {
                OracleSectionTitle(stringResource(R.string.settings_info_title))
                Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text(stringResource(R.string.settings_info_version), style = MaterialTheme.typography.bodyMedium)
                        Text("v1.0.0", style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.Bold)
                    }
                    Text(
                        stringResource(R.string.settings_info_package),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.4f)
                    )
                }
            }
            
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
private fun SettingUpcomingItem(text: String) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(Icons.Default.Pending, null, tint = MaterialTheme.colorScheme.outline, modifier = Modifier.size(16.dp))
        Spacer(modifier = Modifier.width(12.dp))
        Text(
            text = text.removePrefix("• "),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5f)
        )
    }
}
