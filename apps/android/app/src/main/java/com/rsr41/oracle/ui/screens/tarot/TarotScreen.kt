package com.rsr41.oracle.ui.screens.tarot

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp

/**
 * 타로 화면 - 카드 선택 및 결과 표시
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TarotScreen(onBack: () -> Unit) {
    var selectedCards by remember { mutableStateOf<List<Int>>(emptyList()) }
    val maxCards = 3

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("타로") },
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
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                "카드 ${selectedCards.size}/$maxCards 장 선택됨",
                style = MaterialTheme.typography.titleMedium
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            Text(
                "마음을 가다듬고 3장의 카드를 선택하세요",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.outline
            )

            Spacer(modifier = Modifier.height(24.dp))

            // 카드 덱
            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                contentPadding = PaddingValues(horizontal = 16.dp)
            ) {
                items((1..22).toList()) { cardNum ->
                    TarotCard(
                        cardNumber = cardNum,
                        isSelected = selectedCards.contains(cardNum),
                        onSelect = {
                            selectedCards = if (selectedCards.contains(cardNum)) {
                                selectedCards - cardNum
                            } else if (selectedCards.size < maxCards) {
                                selectedCards + cardNum
                            } else {
                                selectedCards
                            }
                        }
                    )
                }
            }

            Spacer(modifier = Modifier.weight(1f))

            // 결과 보기 버튼
            Button(
                onClick = { /* TODO */ },
                modifier = Modifier.fillMaxWidth().height(56.dp),
                enabled = selectedCards.size == maxCards
            ) {
                Text("타로 결과 보기")
            }
        }
    }
}

@Composable
private fun TarotCard(
    cardNumber: Int,
    isSelected: Boolean,
    onSelect: () -> Unit
) {
    Card(
        onClick = onSelect,
        modifier = Modifier.size(80.dp, 120.dp),
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected) {
                MaterialTheme.colorScheme.primaryContainer
            } else {
                MaterialTheme.colorScheme.surfaceVariant
            }
        ),
        border = if (isSelected) {
            CardDefaults.outlinedCardBorder()
        } else null
    ) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            if (isSelected) {
                Text(
                    "🃏\n$cardNumber",
                    textAlign = TextAlign.Center,
                    fontWeight = FontWeight.Bold
                )
            } else {
                Text("🂠", style = MaterialTheme.typography.headlineLarge)
            }
        }
    }
}
