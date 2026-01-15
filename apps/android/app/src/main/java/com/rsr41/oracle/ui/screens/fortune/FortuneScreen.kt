package com.rsr41.oracle.ui.screens.fortune

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material3.*
import androidx.compose.material3.TabRowDefaults.tabIndicatorOffset
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
import com.rsr41.oracle.repository.ManseDaewunResult
import com.rsr41.oracle.repository.ManseSaeunResult
import com.rsr41.oracle.repository.ManseWolunResult
import com.rsr41.oracle.ui.components.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FortuneScreen(
    viewModel: FortuneViewModel,
    onBack: () -> Unit,
    onNavigateToInput: () -> Unit
) {
    val tabs = listOf(
        stringResource(R.string.fortune_tab_daeun),
        stringResource(R.string.fortune_tab_saeun),
        stringResource(R.string.fortune_tab_wolun)
    )

    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.home_menu_fortune),
                onBack = onBack
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
                onProfileSelected = { viewModel.updateSelectedProfile(it) },
                onAddProfile = onNavigateToInput
            )

            // 탭 영역 (Premium Style)
            Surface(
                color = MaterialTheme.colorScheme.surface,
                shadowElevation = 0.dp
            ) {
                TabRow(
                    selectedTabIndex = viewModel.selectedTabIndex,
                    containerColor = MaterialTheme.colorScheme.surface,
                    contentColor = MaterialTheme.colorScheme.primary,
                    indicator = { tabPositions ->
                        TabRowDefaults.SecondaryIndicator(
                            Modifier.tabIndicatorOffset(tabPositions[viewModel.selectedTabIndex]),
                            color = MaterialTheme.colorScheme.primary,
                            height = 3.dp
                        )
                    },
                    divider = { HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.1f)) }
                ) {
                    tabs.forEachIndexed { index, title ->
                        Tab(
                            selected = viewModel.selectedTabIndex == index,
                            onClick = { viewModel.updateTabIndex(index) },
                            text = { 
                                Text(
                                    text = title, 
                                    style = MaterialTheme.typography.bodyLarge,
                                    fontWeight = if(viewModel.selectedTabIndex == index) FontWeight.Bold else FontWeight.Normal,
                                    color = if(viewModel.selectedTabIndex == index) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                                ) 
                            }
                        )
                    }
                }
            }

            // 컨텐츠 영역
            if (viewModel.selectedProfile == null) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Surface(
                            shape = CircleShape,
                            color = MaterialTheme.colorScheme.secondary.copy(alpha = 0.05f),
                            modifier = Modifier.size(80.dp)
                        ) {
                            Box(contentAlignment = Alignment.Center) {
                                Icon(Icons.Default.AccountCircle, null, modifier = Modifier.size(40.dp), tint = MaterialTheme.colorScheme.secondary)
                            }
                        }
                        Spacer(modifier = Modifier.height(24.dp))
                        Text(
                            stringResource(R.string.fortune_select_profile_hint),
                            style = MaterialTheme.typography.titleMedium,
                            textAlign = TextAlign.Center,
                            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                        )
                        Spacer(modifier = Modifier.height(24.dp))
                            OracleButton(
                            onClick = onNavigateToInput, 
                            text = stringResource(R.string.fortune_add_profile),
                            modifier = Modifier.width(200.dp)
                        )
                    }
                }
            } else {
                Box(modifier = Modifier.fillMaxSize().weight(1f)) {
                    when (viewModel.selectedTabIndex) {
                        0 -> DaeunView(viewModel.daewunResult, onClickSave = { viewModel.saveHistory() })
                        1 -> SaeunView(
                            result = viewModel.saeunResult, 
                            year = viewModel.selectedYear, 
                            onYearChange = { viewModel.updateYear(it) },
                            onClickSave = { viewModel.saveHistory() }
                        )
                        2 -> WolunView(
                            list = viewModel.wolunList, 
                            year = viewModel.selectedYear, 
                            onYearChange = { viewModel.updateYear(it) },
                             onClickSave = { viewModel.saveHistory() }
                        )
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
    onProfileSelected: (Profile) -> Unit,
    onAddProfile: () -> Unit
) {
    var expanded by remember { mutableStateOf(false) }

    Column(modifier = Modifier.padding(horizontal = 24.dp, vertical = 20.dp)) {
        Text(
            stringResource(R.string.fortune_profile_to_analyze), 
            style = MaterialTheme.typography.labelMedium,
            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
        )
        Spacer(modifier = Modifier.height(8.dp))
        ExposedDropdownMenuBox(
            expanded = expanded,
            onExpandedChange = { expanded = !expanded }
        ) {
            OutlinedTextField(
                value = selectedProfile?.let { "${it.nickname} (${it.birthDate})" } ?: stringResource(R.string.common_profile_none),
                onValueChange = {},
                readOnly = true,
                modifier = Modifier.fillMaxWidth().menuAnchor(MenuAnchorType.PrimaryNotEditable, true),
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
                        text = { Text(stringResource(R.string.profile_none_saved)) },
                        onClick = { 
                            expanded = false 
                            onAddProfile()
                        }
                    )
                } else {
                    profiles.forEach { profile ->
                        DropdownMenuItem(
                            text = { 
                                Column {
                                    Text(profile.nickname, style = MaterialTheme.typography.bodyLarge)
                                    Text(profile.birthDate, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.outline)
                                }
                            },
                            onClick = {
                                onProfileSelected(profile)
                                expanded = false
                            }
                        )
                    }
                    HorizontalDivider(modifier = Modifier.padding(vertical = 4.dp))
                    DropdownMenuItem(
                        text = { Text("+ " + stringResource(R.string.fortune_add_profile), color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold) },
                        onClick = {
                             expanded = false
                             onAddProfile()
                        }
                    )
                }
            }
        }
    }
}

@Composable
fun DaeunView(result: ManseDaewunResult?, onClickSave: () -> Unit) {
    if (result == null) return

    Column(modifier = Modifier.fillMaxSize()) {
        LazyColumn(
            modifier = Modifier.weight(1f),
            contentPadding = PaddingValues(horizontal = 24.dp, vertical = 24.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            item {
                OracleCard(
                    backgroundColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f)
                ) {
                    OracleSectionTitle(stringResource(R.string.fortune_daewun_title), color = MaterialTheme.colorScheme.primary)
                    Text(
                        text = result.currentDaewun.ganji,
                        style = MaterialTheme.typography.headlineMedium,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.primary
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        result.currentDaewun.description,
                        style = MaterialTheme.typography.bodyLarge,
                        lineHeight = 24.sp
                    )
                }
            }
            
            item {
                OracleSectionTitle(stringResource(R.string.fortune_daewun_flow), modifier = Modifier.padding(top = 8.dp))
            }

            items(result.daewunList) { item ->
                val isCurrent = item.isCurrent
                OracleCard(
                    backgroundColor = if (isCurrent) MaterialTheme.colorScheme.secondary.copy(alpha = 0.05f) else MaterialTheme.colorScheme.surface
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Text(
                                    text = "${item.ganji} 대운", 
                                    style = MaterialTheme.typography.titleMedium,
                                    fontWeight = FontWeight.Bold,
                                    color = if(isCurrent) MaterialTheme.colorScheme.secondary else MaterialTheme.colorScheme.onSurface
                                )
                                if (isCurrent) {
                                    Spacer(modifier = Modifier.width(8.dp))
                                    Surface(
                                        color = MaterialTheme.colorScheme.secondary,
                                        shape = RoundedCornerShape(4.dp)
                                    ) {
                                        Text(
                                            stringResource(R.string.fortune_current), 
                                            modifier = Modifier.padding(horizontal = 4.dp, vertical = 2.dp),
                                            style = MaterialTheme.typography.labelSmall,
                                            color = MaterialTheme.colorScheme.onSecondary
                                        )
                                    }
                                }
                            }
                            Text(
                                text = "${item.startAge}세 ~ ${item.startAge+9}세 (${item.startYear}~${item.endYear})", 
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.outline
                            )
                        }
                        Text(
                            text = item.keyword, 
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.SemiBold,
                            color = if(isCurrent) MaterialTheme.colorScheme.secondary else MaterialTheme.colorScheme.primary
                        )
                    }
                }
            }
            
            item {
                Spacer(modifier = Modifier.height(16.dp))
                OracleButton(
                    text = stringResource(R.string.common_save_history), 
                    onClick = onClickSave,
                    modifier = Modifier.fillMaxWidth()
                )
                Spacer(modifier = Modifier.height(32.dp))
            }
        }
    }
}

@Composable
fun SaeunView(
    result: ManseSaeunResult?, 
    year: Int, 
    onYearChange: (Int) -> Unit,
    onClickSave: () -> Unit
) {
    Column(modifier = Modifier.fillMaxSize()) {
        // Year Selector (Premium Style)
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp, vertical = 20.dp)
                .background(MaterialTheme.colorScheme.surface, RoundedCornerShape(12.dp))
                .padding(4.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = { onYearChange(year - 1) }) { 
                Icon(Icons.AutoMirrored.Filled.ArrowBack, null, tint = MaterialTheme.colorScheme.primary) 
            }
            Text(
                text = stringResource(R.string.fortune_saeun_fmt, year), 
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            )
            IconButton(onClick = { onYearChange(year + 1) }) { 
                Icon(Icons.AutoMirrored.Filled.ArrowForward, null, tint = MaterialTheme.colorScheme.primary) 
            }
        }

        if (result != null) {
            LazyColumn(
                modifier = Modifier.weight(1f),
                contentPadding = PaddingValues(horizontal = 24.dp, vertical = 8.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                 item {
                    OracleCard(
                        backgroundColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f)
                    ) {
                        OracleSectionTitle(stringResource(R.string.fortune_saeun_summary_fmt, result.ganji), color = MaterialTheme.colorScheme.primary)
                        Text(
                            result.summary,
                            style = MaterialTheme.typography.bodyLarge,
                            lineHeight = 26.sp
                        )
                    }
                }
                
                items(result.quarterlyPoints) { point ->
                    OracleCard {
                        Text(
                            text = point.quarterName, 
                            style = MaterialTheme.typography.labelMedium, 
                            color = MaterialTheme.colorScheme.secondary,
                            fontWeight = FontWeight.Bold
                        )
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = point.title, 
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = point.content,
                            style = MaterialTheme.typography.bodyMedium,
                            lineHeight = 22.sp
                        )
                    }
                }
                
                item {
                    Spacer(modifier = Modifier.height(16.dp))
                    OracleButton(
                        text = stringResource(R.string.common_save_history), 
                        onClick = onClickSave,
                        modifier = Modifier.fillMaxWidth()
                    )
                    Spacer(modifier = Modifier.height(32.dp))
                }
            }
        }
    }
}

@Composable
fun WolunView(
    list: List<ManseWolunResult>, 
    year: Int, 
    onYearChange: (Int) -> Unit,
    onClickSave: () -> Unit
) {
     Column(modifier = Modifier.fillMaxSize()) {
        // Year Selector
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp, vertical = 20.dp)
                .background(MaterialTheme.colorScheme.surface, RoundedCornerShape(12.dp))
                .padding(4.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = { onYearChange(year - 1) }) { 
                Icon(Icons.AutoMirrored.Filled.ArrowBack, null, tint = MaterialTheme.colorScheme.primary) 
            }
            Text(
                text = stringResource(R.string.fortune_wolun_fmt, year), 
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            )
            IconButton(onClick = { onYearChange(year + 1) }) { 
                Icon(Icons.AutoMirrored.Filled.ArrowForward, null, tint = MaterialTheme.colorScheme.primary) 
            }
        }
        
        LazyColumn(
            modifier = Modifier.weight(1f),
            contentPadding = PaddingValues(horizontal = 24.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            items(list) { item ->
                var expanded by remember { mutableStateOf(false) }
                
                OracleCard(
                    onClick = { expanded = !expanded },
                    backgroundColor = if(expanded) MaterialTheme.colorScheme.primary.copy(alpha = 0.02f) else MaterialTheme.colorScheme.surface
                ) {
                    Column {
                        Row(
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.fillMaxWidth()
                        ) {
                             Row(verticalAlignment = Alignment.CenterVertically) {
                                 Surface(
                                     shape = CircleShape,
                                     color = MaterialTheme.colorScheme.primary.copy(alpha = 0.1f),
                                     modifier = Modifier.size(40.dp)
                                 ) {
                                     Box(contentAlignment = Alignment.Center) {
                                         Text(
                                             "${item.month}", 
                                             style = MaterialTheme.typography.titleMedium, 
                                             fontWeight = FontWeight.Bold,
                                             color = MaterialTheme.colorScheme.primary
                                         )
                                     }
                                 }
                                 Spacer(modifier = Modifier.width(16.dp))
                                 Column {
                                     Text(
                                         text = stringResource(R.string.fortune_month_flow_fmt, item.month), 
                                         style = MaterialTheme.typography.titleMedium, 
                                         fontWeight = FontWeight.Bold
                                     )
                                     Text(
                                         text = item.ganji, 
                                         style = MaterialTheme.typography.bodySmall,
                                         color = MaterialTheme.colorScheme.outline
                                     )
                                 }
                             }
                             Text(
                                 text = stringResource(R.string.fortune_score_fmt, item.score), 
                                 style = MaterialTheme.typography.titleMedium,
                                 fontWeight = FontWeight.Bold,
                                 color = if(item.score > 80) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.outline
                             )
                        }
                        
                        if (expanded) {
                            Divider(modifier = Modifier.padding(vertical = 16.dp), color = MaterialTheme.colorScheme.outline.copy(alpha = 0.1f))
                            Text(
                                text = item.summary,
                                style = MaterialTheme.typography.bodyMedium,
                                lineHeight = 22.sp
                            )
                            Spacer(modifier = Modifier.height(12.dp))
                            Surface(
                                color = MaterialTheme.colorScheme.secondary.copy(alpha = 0.05f),
                                shape = RoundedCornerShape(8.dp)
                            ) {
                                Row(
                                    modifier = Modifier.padding(12.dp),
                                    verticalAlignment = Alignment.Top
                                ) {
                                    Text("💡 ", style = MaterialTheme.typography.bodyMedium)
                                    Text(
                                        text = item.advice, 
                                        style = MaterialTheme.typography.bodySmall, 
                                        color = MaterialTheme.colorScheme.secondary,
                                        lineHeight = 20.sp
                                    )
                                }
                            }
                        }
                    }
                }
            }
            
            item {
                Spacer(modifier = Modifier.height(16.dp))
                OracleButton(
                    text = stringResource(R.string.common_save_history), 
                    onClick = onClickSave,
                    modifier = Modifier.fillMaxWidth()
                )
                Spacer(modifier = Modifier.height(32.dp))
            }
        }
    }
}
