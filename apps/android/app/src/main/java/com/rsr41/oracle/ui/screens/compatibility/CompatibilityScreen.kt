package com.rsr41.oracle.ui.screens.compatibility

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Warning
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
import com.rsr41.oracle.domain.model.Profile
import com.rsr41.oracle.ui.components.*
import com.rsr41.oracle.repository.CompatibilityResult

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CompatibilityScreen(
    viewModel: CompatibilityViewModel,
    onBack: () -> Unit
) {
    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.home_menu_compatibility),
                onBack = onBack
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

            // 1. 궁합 유형 선택
            OracleCard {
                OracleSectionTitle(stringResource(R.string.compatibility_type_select))
                SelectableChipRow(
                    options = CompatibilityType.entries.toList(),
                    selectedOption = viewModel.selectedType,
                    onOptionSelected = { viewModel.updateType(it) },
                    labelProvider = { it.displayName }
                )
            }

            // 2. 프로필 선택 영역
            OracleCard {
                OracleSectionTitle("분석 대상 선택")
                
                ProfileSelectField(
                    label = stringResource(R.string.compatibility_my_profile),
                    profiles = viewModel.profiles,
                    selectedProfile = viewModel.myProfile,
                    onSelect = { viewModel.updateMyProfile(it) }
                )
                
                Spacer(modifier = Modifier.height(20.dp))
                
                ProfileSelectField(
                    label = stringResource(R.string.compatibility_partner_profile),
                    profiles = viewModel.profiles,
                    selectedProfile = viewModel.partnerProfile,
                    onSelect = { viewModel.updatePartnerProfile(it) }
                )
                
                if (viewModel.myProfile != null && viewModel.myProfile?.id == viewModel.partnerProfile?.id) {
                     Spacer(modifier = Modifier.height(8.dp))
                     Text(
                         text = "본인과 분석할 수 없습니다.", 
                         color = MaterialTheme.colorScheme.error, 
                         style = MaterialTheme.typography.bodySmall,
                         modifier = Modifier.padding(start = 4.dp)
                     )
                }
            }

            // 분석 버튼
            OracleButton(
                text = stringResource(R.string.compatibility_analyze_btn),
                onClick = { viewModel.analyze() },
                enabled = viewModel.canAnalyze(),
                modifier = Modifier.fillMaxWidth()
            )

            // 4. 분석 결과 (있을 경우 표시)
            viewModel.result?.let { res ->
                CompatibilityResultView(res)
            }
            
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ProfileSelectField(
    label: String,
    profiles: List<Profile>,
    selectedProfile: Profile?,
    onSelect: (Profile) -> Unit
) {
    var expanded by remember { mutableStateOf(false) }

    Column {
        Text(
            text = label, 
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f),
            modifier = Modifier.padding(start = 4.dp, bottom = 4.dp)
        )
        ExposedDropdownMenuBox(
            expanded = expanded,
            onExpandedChange = { expanded = !expanded }
        ) {
            OutlinedTextField(
                value = selectedProfile?.let { "${it.nickname} (${it.birthDate})" } ?: "선택해주세요",
                onValueChange = {},
                readOnly = true,
                modifier = Modifier.fillMaxWidth().menuAnchor(),
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                shape = RoundedCornerShape(12.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = MaterialTheme.colorScheme.primary,
                    unfocusedBorderColor = MaterialTheme.colorScheme.outline
                )
            )
            ExposedDropdownMenu(
                expanded = expanded,
                onDismissRequest = { expanded = false },
                modifier = Modifier.background(MaterialTheme.colorScheme.surface)
            ) {
                 if (profiles.isEmpty()) {
                    DropdownMenuItem(
                        text = { Text("저장된 프로필이 없습니다.") },
                        onClick = { expanded = false }
                    )
                } else {
                    profiles.forEach { profile ->
                        DropdownMenuItem(
                            text = { Text("${profile.nickname} (${profile.birthDate})") },
                            onClick = {
                                onSelect(profile)
                                expanded = false
                            }
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun CompatibilityResultView(result: CompatibilityResult) {
    Column(verticalArrangement = Arrangement.spacedBy(24.dp)) {
        
        // 점수 카드 (Premium Hero)
        OracleCard(
            backgroundColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        "궁합 점수", 
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.primary
                    )
                    Spacer(modifier = Modifier.height(12.dp))
                    Surface(
                        shape = CircleShape,
                        color = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.size(120.dp)
                    ) {
                        Box(contentAlignment = Alignment.Center) {
                            Text(
                                "${result.score}", 
                                style = MaterialTheme.typography.headlineLarge, 
                                fontWeight = FontWeight.Bold,
                                color = MaterialTheme.colorScheme.onPrimary
                            )
                        }
                    }
                }
            }
            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = result.summary, 
                style = MaterialTheme.typography.bodyLarge,
                lineHeight = 26.sp,
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth()
            )
        }
        
        // 상세 분석
        OracleCard {
            OracleSectionTitle("심층 분석")
            
            Text("좋은 점 ✨", style = MaterialTheme.typography.titleSmall, color = MaterialTheme.colorScheme.primary)
            Spacer(modifier = Modifier.height(8.dp))
            result.pros.forEach { item ->
                Row(modifier = Modifier.padding(vertical = 6.dp)) {
                    Icon(Icons.Default.Check, null, modifier = Modifier.size(16.dp), tint = MaterialTheme.colorScheme.primary)
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(item, style = MaterialTheme.typography.bodyMedium)
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            Divider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.1f))
            Spacer(modifier = Modifier.height(16.dp))
            
            Text("주의할 점 ⚠️", style = MaterialTheme.typography.titleSmall, color = MaterialTheme.colorScheme.error)
            Spacer(modifier = Modifier.height(8.dp))
            result.cons.forEach { item ->
                Row(modifier = Modifier.padding(vertical = 6.dp)) {
                    Icon(Icons.Default.Warning, null, modifier = Modifier.size(16.dp), tint = MaterialTheme.colorScheme.error)
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(item, style = MaterialTheme.typography.bodyMedium)
                }
            }
        }
        
        // 조언 (Premium Quote style)
        OracleCard(
            backgroundColor = MaterialTheme.colorScheme.secondary.copy(alpha = 0.05f)
        ) {
            OracleSectionTitle("Oracle의 조언 💌", color = MaterialTheme.colorScheme.secondary)
            Text(
                text = result.advice, 
                style = MaterialTheme.typography.bodyLarge,
                fontStyle = androidx.compose.ui.text.font.FontStyle.Italic,
                lineHeight = 26.sp,
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.8f)
            )
        }
    }
}
