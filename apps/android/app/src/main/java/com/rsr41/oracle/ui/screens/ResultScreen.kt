package com.rsr41.oracle.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Info
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.rsr41.oracle.R
import com.rsr41.oracle.core.util.DateTimeUtil
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.Gender
import com.rsr41.oracle.ui.components.*

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

    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.result_title),
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
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            Spacer(modifier = Modifier.height(8.dp))

            if (viewModel.isLoading) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator(color = MaterialTheme.colorScheme.primary)
                }
            } else if (historyItem != null) {
                val item = historyItem
                val birthInfo = item.birthInfo
                val result = item.result

                // 오늘의 총운 (Hero)
                OracleCard(
                    backgroundColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f)
                ) {
                   OracleSectionTitle(
                       text = stringResource(R.string.result_summary_title),
                       color = MaterialTheme.colorScheme.primary
                   )
                   Text(
                       text = result.summaryToday,
                       style = MaterialTheme.typography.bodyLarge,
                       lineHeight = 26.sp
                    )
                }

                // 사주 기둥 (Pillars)
                OracleCard {
                   OracleSectionTitle(stringResource(R.string.result_pillars_title))
                   Box(
                       modifier = Modifier
                           .fillMaxWidth()
                           .padding(vertical = 8.dp)
                           .background(MaterialTheme.colorScheme.secondary.copy(alpha = 0.05f), RoundedCornerShape(12.dp))
                           .padding(16.dp),
                       contentAlignment = Alignment.Center
                   ) {
                       Text(
                           text = result.pillars,
                           style = MaterialTheme.typography.headlineSmall,
                           fontWeight = FontWeight.Bold,
                           color = MaterialTheme.colorScheme.secondary,
                           textAlign = TextAlign.Center
                       )
                   }
                }

                // 행운 아이템 (Lucky)
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    val luckyColor = try {
                        androidx.compose.ui.graphics.Color(android.graphics.Color.parseColor(result.luckyColor))
                    } catch (e: Exception) {
                        MaterialTheme.colorScheme.primary
                    }
                    
                    OracleCard(modifier = Modifier.weight(1f)) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                             Text(stringResource(R.string.result_lucky_color), style = MaterialTheme.typography.labelMedium)
                             Spacer(modifier = Modifier.height(8.dp))
                             Box(
                                 modifier = Modifier
                                     .size(40.dp)
                                     .background(luckyColor, androidx.compose.foundation.shape.CircleShape)
                             )
                        }
                    }
                    
                    OracleCard(modifier = Modifier.weight(1f)) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                             Text(stringResource(R.string.result_lucky_number), style = MaterialTheme.typography.labelMedium)
                             Spacer(modifier = Modifier.height(8.dp))
                             Text(
                                 text = "${result.luckyNumber}",
                                 style = MaterialTheme.typography.headlineMedium,
                                 fontWeight = FontWeight.Bold,
                                 color = MaterialTheme.colorScheme.primary
                             )
                        }
                    }
                }

                // 입력 정보 요약
                OracleCard {
                    OracleSectionTitle(stringResource(R.string.result_input_summary))
                    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                        ResultDetailRow(stringResource(R.string.profile_birth_date), birthInfo.date)
                        ResultDetailRow(stringResource(R.string.profile_birth_time), birthInfo.time.ifBlank { stringResource(R.string.common_not_entered) })
                        ResultDetailRow(stringResource(R.string.profile_gender), if (birthInfo.gender == Gender.MALE) stringResource(R.string.common_male) else stringResource(R.string.common_female))
                        ResultDetailRow(stringResource(R.string.profile_calendar_type), if (birthInfo.calendarType == CalendarType.SOLAR) stringResource(R.string.common_solar) else stringResource(R.string.common_lunar))
                        
                        Divider(modifier = Modifier.padding(vertical = 12.dp), color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f))
                        
                        Text(
                            stringResource(R.string.result_generated_at, DateTimeUtil.formatMillisToDateTime(result.generatedAtMillis)),
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5f)
                        )
                    }
                }

                // 하단 버튼들
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    OracleSecondaryButton(
                        text = stringResource(R.string.result_retry_btn),
                        onClick = onBack,
                        modifier = Modifier.weight(1f)
                    )
                    OracleButton(
                        text = stringResource(R.string.common_history),
                        onClick = { onNavigate("HISTORY") },
                        modifier = Modifier.weight(1f)
                    )
                }
            } else {
                // 결과 없음
                OracleCard {
                    Column(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(Icons.Default.Info, null, tint = MaterialTheme.colorScheme.error, modifier = Modifier.size(48.dp))
                        Spacer(modifier = Modifier.height(16.dp))
                        Text(
                            stringResource(R.string.result_not_found),
                            style = MaterialTheme.typography.titleLarge,
                            color = MaterialTheme.colorScheme.error
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            stringResource(R.string.result_not_found_desc),
                            style = MaterialTheme.typography.bodyMedium,
                            textAlign = TextAlign.Center
                        )
                    }
                }

                OracleButton(
                     text = stringResource(R.string.result_go_to_input),
                     onClick = onBack,
                     modifier = Modifier.fillMaxWidth()
                )
            }
            
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
private fun ResultDetailRow(label: String, value: String) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(label, style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f))
        Text(value, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
    }
}
