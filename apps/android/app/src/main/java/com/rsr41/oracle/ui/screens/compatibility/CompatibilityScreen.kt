package com.rsr41.oracle.ui.screens.compatibility

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.rsr41.oracle.R
import com.rsr41.oracle.domain.model.Profile
import com.rsr41.oracle.ui.components.SelectableChipRow

/**
 * 궁합 화면 - 두 프로필 간의 궁합 분석
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CompatibilityScreen(
    viewModel: CompatibilityViewModel,
    onBack: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.home_menu_compatibility)) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, stringResource(R.string.common_back))
                    }
                }
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
            if (viewModel.isAnalyzed) {
                // 분석 결과 표시
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.Favorite, null, tint = MaterialTheme.colorScheme.primary)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(stringResource(R.string.common_result), style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                        }
                        Spacer(modifier = Modifier.height(12.dp))
                        Text(viewModel.analysisResult, style = MaterialTheme.typography.bodyMedium)
                        Spacer(modifier = Modifier.height(16.dp))
                        OutlinedButton(
                            onClick = { viewModel.reset() },
                            modifier = Modifier.align(Alignment.End)
                        ) {
                            Text(stringResource(R.string.common_retry))
                        }
                    }
                }
            }

            // 궁합 유형 선택
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(stringResource(R.string.compatibility_type_select), style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
                    Spacer(modifier = Modifier.height(12.dp))
                    SelectableChipRow(
                        options = CompatibilityType.entries.toList(),
                        selectedOption = viewModel.selectedType,
                        onOptionSelected = { viewModel.updateType(it) },
                        labelProvider = { it.displayName }
                    )
                }
            }

            // 내 프로필 선택
            ProfileSelectionSection(
                title = stringResource(R.string.compatibility_my_profile),
                profiles = viewModel.profiles,
                selectedProfile = viewModel.myProfile,
                onProfileSelected = { viewModel.updateMyProfile(it) }
            )

            // 상대방 프로필 선택
            ProfileSelectionSection(
                title = stringResource(R.string.compatibility_partner_profile),
                profiles = viewModel.profiles,
                selectedProfile = viewModel.partnerProfile,
                onProfileSelected = { viewModel.updatePartnerProfile(it) }
            )

            if (viewModel.profiles.isEmpty()) {
                Text(
                    stringResource(R.string.common_profile_empty_error),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.error,
                    modifier = Modifier.padding(horizontal = 8.dp)
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            Button(
                onClick = { viewModel.analyze() },
                modifier = Modifier.fillMaxWidth().height(56.dp),
                enabled = viewModel.canAnalyze() && !viewModel.isAnalyzed
            ) {
                Icon(Icons.Default.Favorite, null)
                Spacer(modifier = Modifier.width(8.dp))
                Text(stringResource(R.string.compatibility_analyze_btn))
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ProfileSelectionSection(
    title: String,
    profiles: List<Profile>,
    selectedProfile: Profile?,
    onProfileSelected: (Profile) -> Unit
) {
    var expanded by remember { mutableStateOf(false) }

    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(title, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(12.dp))
            
            ExposedDropdownMenuBox(
                expanded = expanded,
                onExpandedChange = { expanded = !expanded }
            ) {
                OutlinedTextField(
                    value = selectedProfile?.nickname ?: stringResource(R.string.common_profile_none),
                    onValueChange = {},
                    readOnly = true,
                    modifier = Modifier.fillMaxWidth().menuAnchor(),
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                    colors = ExposedDropdownMenuDefaults.outlinedTextFieldColors()
                )
                
                ExposedDropdownMenu(
                    expanded = expanded,
                    onDismissRequest = { expanded = false }
                ) {
                    profiles.forEach { profile ->
                        DropdownMenuItem(
                            text = { Text("${profile.nickname} (${profile.birthDate})") },
                            onClick = {
                                onProfileSelected(profile)
                                expanded = false
                            }
                        )
                    }
                }
            }
        }
    }
}
