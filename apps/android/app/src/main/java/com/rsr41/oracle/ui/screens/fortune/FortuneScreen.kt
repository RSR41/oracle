package com.rsr41.oracle.ui.screens.fortune

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
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
import com.rsr41.oracle.domain.model.Profile

/**
 * 만세력/대운 화면
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FortuneScreen(
    viewModel: FortuneViewModel,
    onBack: () -> Unit
) {
    val tabs = listOf(
        stringResource(R.string.fortune_tab_daeun),
        stringResource(R.string.fortune_tab_saeun),
        stringResource(R.string.fortune_tab_wolun)
    )

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.home_menu_fortune)) },
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
        ) {
            // 프로필 선택 영역
            ProfileSelector(
                profiles = viewModel.profiles,
                selectedProfile = viewModel.selectedProfile,
                onProfileSelected = { viewModel.updateSelectedProfile(it) }
            )

            TabRow(selectedTabIndex = viewModel.selectedTabIndex) {
                tabs.forEachIndexed { index, title ->
                    Tab(
                        selected = viewModel.selectedTabIndex == index,
                        onClick = { viewModel.updateTabIndex(index) },
                        text = { Text(title) }
                    )
                }
            }

            if (viewModel.selectedProfile == null) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(stringResource(R.string.fortune_select_profile_hint))
                }
            } else {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .verticalScroll(rememberScrollState())
                        .padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    when (viewModel.selectedTabIndex) {
                        0 -> DaeunContent(viewModel.selectedProfile!!)
                        1 -> SaeunContent(viewModel.selectedProfile!!)
                        2 -> WolunContent(viewModel.selectedProfile!!)
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ProfileSelector(
    profiles: List<Profile>,
    selectedProfile: Profile?,
    onProfileSelected: (Profile) -> Unit
) {
    var expanded by remember { mutableStateOf(false) }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Text(stringResource(R.string.fortune_profile_to_analyze), style = MaterialTheme.typography.labelMedium)
            Spacer(modifier = Modifier.height(8.dp))
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
                    if (profiles.isEmpty()) {
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.profile_none_saved)) },
                            onClick = { expanded = false }
                        )
                    } else {
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
}

@Composable
private fun DaeunContent(profile: Profile) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("${profile.nickname} 님의 ${stringResource(R.string.fortune_tab_daeun)} (10년 주기)", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(8.dp))
            Text("대운은 10년마다 변하는 큰 흐름을 나타냅니다. 현재 ${profile.nickname} 님은 성실하게 내실을 다져야 하는 시기입니다.")
            Spacer(modifier = Modifier.height(16.dp))
            
            val startYear = 2020
            repeat(5) { i ->
                val yearRange = "${startYear + (i * 10)} - ${startYear + (i * 10) + 9}"
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 4.dp),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)
                ) {
                    Row(modifier = Modifier.padding(12.dp), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text(yearRange, fontWeight = FontWeight.Medium)
                        Text(if (i == 0) "현재 ${stringResource(R.string.fortune_tab_daeun)}" else "이후 ${stringResource(R.string.fortune_tab_daeun)}", style = MaterialTheme.typography.labelSmall)
                    }
                }
            }
        }
    }
}

@Composable
private fun SaeunContent(profile: Profile) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("${profile.nickname} 님의 ${stringResource(R.string.fortune_tab_saeun)} (연간 운세)", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(12.dp))
            Text("2024년 갑진년(甲辰年): 새로운 일을 시작하기에 좋은 시기입니다.")
            HorizontalDivider(modifier = Modifier.padding(vertical = 12.dp))
            Text("2025년 을사년(乙巳년): 주변과의 화합이 중요한 일년이 될 것입니다.")
        }
    }
}

@Composable
private fun WolunContent(profile: Profile) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("${profile.nickname} 님의 ${stringResource(R.string.fortune_tab_wolun)} (월간 운세)", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(12.dp))
            Text("이번 달은 금전운이 상승하는 시기이므로 계획적인 지출이 필요합니다.")
        }
    }
}
