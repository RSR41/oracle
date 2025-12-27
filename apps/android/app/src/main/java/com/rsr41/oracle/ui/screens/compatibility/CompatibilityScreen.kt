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
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

/**
 * 궁합 화면 - 두 프로필 선택 후 궁합 분석
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CompatibilityScreen(onBack: () -> Unit) {
    var selectedType by remember { mutableIntStateOf(0) }
    val types = listOf("연애", "결혼", "비즈니스")

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("궁합") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "뒤로")
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
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // 궁합 유형 선택
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text("궁합 유형 선택", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                    Spacer(modifier = Modifier.height(8.dp))
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        types.forEachIndexed { index, type ->
                            FilterChip(
                                selected = selectedType == index,
                                onClick = { selectedType = index },
                                label = { Text(type) }
                            )
                        }
                    }
                }
            }

            // 나의 프로필
            ProfileSelectCard(title = "나의 프로필", subtitle = "사주 정보를 선택하세요")

            // 상대방 프로필
            ProfileSelectCard(title = "상대방 프로필", subtitle = "상대방의 사주 정보를 입력하세요")

            Spacer(modifier = Modifier.height(8.dp))

            // 궁합 보기 버튼
            Button(
                onClick = { /* TODO */ },
                modifier = Modifier.fillMaxWidth().height(56.dp)
            ) {
                Icon(Icons.Default.Favorite, null)
                Spacer(modifier = Modifier.width(8.dp))
                Text("궁합 분석하기")
            }
        }
    }
}

@Composable
private fun ProfileSelectCard(title: String, subtitle: String) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(4.dp))
            Text(subtitle, style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.outline)
            Spacer(modifier = Modifier.height(12.dp))
            OutlinedButton(onClick = { /* TODO */ }) {
                Text("프로필 선택")
            }
        }
    }
}
