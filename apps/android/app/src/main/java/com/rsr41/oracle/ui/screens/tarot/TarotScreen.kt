package com.rsr41.oracle.ui.screens.tarot

import android.widget.Toast
import androidx.compose.animation.AnimatedContent
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.rsr41.oracle.R

/**
 * 타로 화면 - 카드 선택 및 결과 표시
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TarotScreen(
    onBack: () -> Unit,
    viewModel: TarotViewModel = hiltViewModel()
) {
    val context = LocalContext.current
    val selectedIds = viewModel.selectedIds
    val maxCards = 3

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.tarot_title)) },
                navigationIcon = {
                    IconButton(onClick = if (viewModel.showResult) viewModel::reset else onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, stringResource(R.string.common_back))
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer
                )
            )
        }
    ) { padding ->
        if (viewModel.showResult) {
            TarotResultView(
                modifier = Modifier.padding(padding),
                interpretation = viewModel.resultInterpretation!!,
                onSave = {
                    viewModel.saveToHistory()
                    Toast.makeText(context, R.string.common_saved, Toast.LENGTH_SHORT).show()
                }
            )
        } else {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    stringResource(R.string.tarot_selection_count, selectedIds.size, maxCards),
                    style = MaterialTheme.typography.titleMedium
                )
                
                Spacer(modifier = Modifier.height(8.dp))
                
                Text(
                    stringResource(R.string.tarot_instruction),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.outline
                )

                Spacer(modifier = Modifier.height(24.dp))

                // 페이지 선택 (1 2 3)
                Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                    (0..2).forEach { page ->
                        FilterChip(
                            selected = viewModel.currentPage == page,
                            onClick = { viewModel.currentPage = page },
                            label = { Text("${page + 1}") }
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // 카드 그리드 (4장씩)
                val cardsOnPage = (viewModel.currentPage * 4 until (viewModel.currentPage + 1) * 4)
                
                Box(modifier = Modifier.weight(1f), contentAlignment = Alignment.Center) {
                    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                            TarotCardItem(
                                cardNumber = cardsOnPage.elementAt(0),
                                isSelected = selectedIds.contains(cardsOnPage.elementAt(0)),
                                onSelect = { viewModel.toggleCard(cardsOnPage.elementAt(0)) }
                            )
                            TarotCardItem(
                                cardNumber = cardsOnPage.elementAt(1),
                                isSelected = selectedIds.contains(cardsOnPage.elementAt(1)),
                                onSelect = { viewModel.toggleCard(cardsOnPage.elementAt(1)) }
                            )
                        }
                        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                            TarotCardItem(
                                cardNumber = cardsOnPage.elementAt(2),
                                isSelected = selectedIds.contains(cardsOnPage.elementAt(2)),
                                onSelect = { viewModel.toggleCard(cardsOnPage.elementAt(2)) }
                            )
                            TarotCardItem(
                                cardNumber = cardsOnPage.elementAt(3),
                                isSelected = selectedIds.contains(cardsOnPage.elementAt(3)),
                                onSelect = { viewModel.toggleCard(cardsOnPage.elementAt(3)) }
                            )
                        }
                    }
                }

                // 결과 보기 버튼
                Button(
                    onClick = { viewModel.generateResult() },
                    modifier = Modifier.fillMaxWidth().height(56.dp),
                    enabled = selectedIds.size == maxCards
                ) {
                    Text(stringResource(R.string.tarot_view_result))
                }
            }
        }
    }
}

@Composable
private fun TarotCardItem(
    cardNumber: Int,
    isSelected: Boolean,
    onSelect: () -> Unit
) {
    Card(
        onClick = onSelect,
        modifier = Modifier.size(100.dp, 150.dp),
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected) {
                MaterialTheme.colorScheme.primaryContainer
            } else {
                MaterialTheme.colorScheme.surfaceVariant
            }
        ),
        border = if (isSelected) {
            BorderStroke(2.dp, MaterialTheme.colorScheme.primary)
        } else null
    ) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            if (isSelected) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("🔮", style = MaterialTheme.typography.headlineMedium)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(stringResource(R.string.common_selected), style = MaterialTheme.typography.labelMedium, fontWeight = FontWeight.Bold)
                }
            } else {
                Text("🂠", style = MaterialTheme.typography.displayMedium, color = MaterialTheme.colorScheme.outline)
            }
        }
    }
}

@Composable
private fun TarotResultView(
    modifier: Modifier,
    interpretation: TarotResult,
    onSave: () -> Unit
) {
    var isSaved by remember { mutableStateOf(false) }

    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(stringResource(R.string.tarot_result_title), style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold)
        
        // 선택된 카드들
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            interpretation.selectedCards.forEach { card ->
                Card(
                    modifier = Modifier.weight(1f).height(120.dp),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)
                ) {
                    Column(
                        modifier = Modifier.fillMaxSize().padding(8.dp),
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        Text("🃏", style = MaterialTheme.typography.titleLarge)
                        Text(card.name, style = MaterialTheme.typography.labelSmall, textAlign = TextAlign.Center, maxLines = 1)
                        Text(card.keyword, style = MaterialTheme.typography.labelMedium, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                    }
                }
            }
        }

        // 해석 요약
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(stringResource(R.string.tarot_summary_label), style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(8.dp))
                Text(interpretation.summary, style = MaterialTheme.typography.bodyLarge)
            }
        }

        // 상세 해석
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(stringResource(R.string.tarot_detail_label), style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(8.dp))
                Text(interpretation.detail, style = MaterialTheme.typography.bodyMedium)
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = { 
                onSave()
                isSaved = true
            },
            modifier = Modifier.fillMaxWidth().height(56.dp),
            enabled = !isSaved
        ) {
            Text(if (isSaved) stringResource(R.string.common_already_saved) else stringResource(R.string.common_save_history))
        }
    }
}
