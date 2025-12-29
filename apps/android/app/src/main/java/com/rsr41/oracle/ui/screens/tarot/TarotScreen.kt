package com.rsr41.oracle.ui.screens.tarot

import android.widget.Toast
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.rsr41.oracle.R
import com.rsr41.oracle.ui.components.*

/**
 * 타로 화면 - 카드 선택 및 결과 표시 (36장 Deck, 12장/Page)
 */
@Composable
fun TarotScreen(
    onBack: () -> Unit,
    viewModel: TarotViewModel = hiltViewModel()
) {
    val context = LocalContext.current
    val selectedCards = viewModel.selectedCards
    val maxCards = 3

    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.tarot_title),
                onBack = if (viewModel.showResult) viewModel::reset else onBack
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
                    .padding(horizontal = 24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Spacer(modifier = Modifier.height(16.dp))

                // 상단 선택 상태 (Premium Card Header)
                Surface(
                    color = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Column(
                        modifier = Modifier.padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            stringResource(R.string.tarot_instruction),
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f),
                            textAlign = TextAlign.Center
                        )
                        Spacer(modifier = Modifier.height(12.dp))
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            (0 until maxCards).forEach { i ->
                                Surface(
                                    shape = CircleShape,
                                    color = if (i < selectedCards.size) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.outline.copy(alpha = 0.2f),
                                    modifier = Modifier.size(10.dp)
                                ) {}
                                if (i < maxCards - 1) Spacer(modifier = Modifier.width(12.dp))
                            }
                        }
                    }
                }
                
                Spacer(modifier = Modifier.height(24.dp))

                // 페이지 선택 (Premium Style)
                Row(
                   modifier = Modifier
                       .background(MaterialTheme.colorScheme.surface, RoundedCornerShape(12.dp))
                       .padding(4.dp),
                   horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    (0..2).forEach { page ->
                        Surface(
                            onClick = { viewModel.currentPage = page },
                            shape = RoundedCornerShape(8.dp),
                            color = if (viewModel.currentPage == page) MaterialTheme.colorScheme.primary else Color.Transparent,
                            modifier = Modifier.size(48.dp, 36.dp)
                        ) {
                            Box(contentAlignment = Alignment.Center) {
                                Text(
                                    "${page + 1}", 
                                    style = MaterialTheme.typography.labelLarge,
                                    fontWeight = FontWeight.Bold,
                                    color = if (viewModel.currentPage == page) MaterialTheme.colorScheme.onPrimary else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.4f)
                                )
                            }
                        }
                    }
                }

                Spacer(modifier = Modifier.height(24.dp))

                // 카드 그리드
                val startIndex = viewModel.currentPage * 12
                val endIndex = minOf(startIndex + 12, viewModel.deck.size)
                val cardsOnPage = try {
                    viewModel.deck.subList(startIndex, endIndex)
                } catch (e: Exception) {
                    emptyList()
                }
                
                LazyVerticalGrid(
                    columns = GridCells.Fixed(4),
                    modifier = Modifier.weight(1f),
                    horizontalArrangement = Arrangement.spacedBy(10.dp),
                    verticalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    items(cardsOnPage.size) { index ->
                        val cardState = cardsOnPage[index]
                        val isSelected = viewModel.isSelected(cardState)
                        
                        TarotCardItem(
                            cardState = cardState,
                            isSelected = isSelected,
                            onSelect = { viewModel.toggleCard(cardState) }
                        )
                    }
                }

                // 결과 보기 버튼
                Spacer(modifier = Modifier.height(16.dp))
                OracleButton(
                    text = stringResource(R.string.tarot_view_result),
                    onClick = { viewModel.generateResult() },
                    modifier = Modifier.fillMaxWidth().height(56.dp),
                    enabled = selectedCards.size == maxCards
                )
                Spacer(modifier = Modifier.height(32.dp))
            }
        }
    }
}

@Composable
private fun TarotCardItem(
    cardState: TarotCardState,
    isSelected: Boolean,
    onSelect: () -> Unit
) {
    val cardColor = if (isSelected) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.surface
    val contentColor = if (isSelected) MaterialTheme.colorScheme.onPrimary else MaterialTheme.colorScheme.onSurface

    Surface(
        onClick = onSelect,
        modifier = Modifier.aspectRatio(0.62f), 
        shape = RoundedCornerShape(8.dp),
        color = cardColor,
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)),
        shadowElevation = if (isSelected) 8.dp else 2.dp
    ) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            if (isSelected) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("✨", style = MaterialTheme.typography.titleLarge)
                    if (cardState.isReversed) {
                        Text(
                            text = stringResource(R.string.tarot_reversed), 
                            style = MaterialTheme.typography.labelSmall, 
                            color = contentColor.copy(alpha = 0.7f)
                        )
                    }
                }
            } else {
                Text("🔮", style = MaterialTheme.typography.headlineSmall, color = MaterialTheme.colorScheme.outline.copy(alpha = 0.5f))
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
            .padding(horizontal = 24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        Spacer(modifier = Modifier.height(16.dp))
        
        // 선택된 카드들 상세 표시
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            interpretation.selectedCards.forEach { cardState ->
                Surface(
                    modifier = Modifier.weight(1f).height(180.dp),
                    shape = RoundedCornerShape(12.dp),
                    color = MaterialTheme.colorScheme.surface,
                    border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)),
                    shadowElevation = 2.dp
                ) {
                    Column(
                        modifier = Modifier.fillMaxSize().padding(8.dp),
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                         Surface(
                             shape = CircleShape,
                             color = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f),
                             modifier = Modifier.size(56.dp)
                         ) {
                             Box(contentAlignment = Alignment.Center) {
                                 Text(
                                    "🎴", 
                                    style = MaterialTheme.typography.headlineLarge,
                                    modifier = Modifier.graphicsLayer {
                                        rotationZ = if (cardState.isReversed) 180f else 0f
                                    }
                                )
                             }
                         }
                        Spacer(modifier = Modifier.height(12.dp))
                        Text(
                            text = cardState.card.nameKo, 
                            style = MaterialTheme.typography.labelMedium, 
                            textAlign = TextAlign.Center, 
                            maxLines = 1, 
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = if (cardState.isReversed) stringResource(R.string.tarot_reversed) else stringResource(R.string.tarot_upright), 
                            style = MaterialTheme.typography.labelSmall, 
                            color = if (cardState.isReversed) MaterialTheme.colorScheme.error else MaterialTheme.colorScheme.primary
                        )
                    }
                }
            }
        }

        // 해석 요약 (Hero Card)
        OracleCard(
            backgroundColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f)
        ) {
            OracleSectionTitle(stringResource(R.string.tarot_summary_label), color = MaterialTheme.colorScheme.primary)
            Text(
                text = interpretation.summary, 
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.Bold,
                lineHeight = 26.sp
            )
        }

        // 상세 해석
        OracleCard {
            OracleSectionTitle(stringResource(R.string.tarot_detail_label))
            
            Text(stringResource(R.string.tarot_pros), style = MaterialTheme.typography.titleSmall, color = MaterialTheme.colorScheme.primary)
            Spacer(modifier = Modifier.height(8.dp))
            // Assuming we use interpretation.pros/cons if available, but for now just text
            Text(
                text = interpretation.detail, 
                style = MaterialTheme.typography.bodyMedium,
                lineHeight = 24.sp
            )
        }

        OracleButton(
            text = if (isSaved) stringResource(R.string.common_already_saved) else stringResource(R.string.common_save_history),
            onClick = { 
                onSave()
                isSaved = true
            },
            enabled = !isSaved,
            modifier = Modifier.fillMaxWidth()
        )
        
        Spacer(modifier = Modifier.height(32.dp))
    }
}
