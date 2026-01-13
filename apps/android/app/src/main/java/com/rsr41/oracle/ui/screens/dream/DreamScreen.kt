package com.rsr41.oracle.ui.screens.dream

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.rsr41.oracle.R
import com.rsr41.oracle.data.local.entity.DreamInterpretationEntity
import com.rsr41.oracle.ui.components.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DreamScreen(
    viewModel: DreamViewModel = hiltViewModel(),
    onBack: () -> Unit
) {
    val searchResults by viewModel.searchResults.collectAsState()
    val categories by viewModel.categories.collectAsState()
    val popularKeywords by viewModel.popularKeywords.collectAsState()
    
    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.menu_dream),
                onBack = onBack
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
        ) {
            // 검색창
            OutlinedTextField(
                value = viewModel.searchQuery,
                onValueChange = { viewModel.onSearchQueryChange(it) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp),
                placeholder = { Text("꿈에서 본 것을 검색하세요...") },
                leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                singleLine = true,
                shape = RoundedCornerShape(24.dp)
            )
            
            // 상세 보기 다이얼로그
            viewModel.selectedDream?.let { dream ->
                DreamDetailDialog(
                    dream = dream,
                    onDismiss = { viewModel.clearSelection() }
                )
            }
            
            LazyColumn(
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                // 검색 결과가 있으면 표시
                if (viewModel.searchQuery.isNotBlank() && searchResults.isNotEmpty()) {
                    item {
                        OracleSectionTitle("검색 결과 (${searchResults.size})")
                    }
                    items(searchResults) { dream ->
                        DreamResultCard(
                            dream = dream,
                            onClick = { viewModel.onDreamSelected(dream) }
                        )
                    }
                } else if (viewModel.searchQuery.isNotBlank() && searchResults.isEmpty()) {
                    item {
                        EmptySearchResult()
                    }
                } else {
                    // 인기 키워드
                    if (popularKeywords.isNotEmpty()) {
                        item {
                            OracleSectionTitle("🔥 인기 꿈 키워드")
                        }
                        item {
                            LazyRow(
                                horizontalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                items(popularKeywords) { dream ->
                                    PopularKeywordChip(
                                        keyword = dream.keywordKo,
                                        isGood = dream.isGoodDream,
                                        onClick = { viewModel.onDreamSelected(dream) }
                                    )
                                }
                            }
                        }
                    }
                    
                    // 카테고리
                    if (categories.isNotEmpty()) {
                        item {
                            Spacer(modifier = Modifier.height(8.dp))
                            OracleSectionTitle("📂 카테고리별 탐색")
                        }
                        item {
                            CategoryGrid(
                                categories = categories,
                                selectedCategory = viewModel.selectedCategory,
                                onCategorySelected = { viewModel.onCategorySelected(it) }
                            )
                        }
                    }
                    
                    // 카테고리 선택 시 결과 표시
                    if (viewModel.selectedCategory != null && searchResults.isNotEmpty()) {
                        item {
                            Spacer(modifier = Modifier.height(8.dp))
                            OracleSectionTitle("${viewModel.selectedCategory} (${searchResults.size})")
                        }
                        items(searchResults) { dream ->
                            DreamResultCard(
                                dream = dream,
                                onClick = { viewModel.onDreamSelected(dream) }
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun PopularKeywordChip(
    keyword: String,
    isGood: Boolean?,
    onClick: () -> Unit
) {
    val backgroundColor = when (isGood) {
        true -> MaterialTheme.colorScheme.primary.copy(alpha = 0.1f)
        false -> MaterialTheme.colorScheme.error.copy(alpha = 0.1f)
        null -> MaterialTheme.colorScheme.surfaceVariant
    }
    val emoji = when (isGood) {
        true -> "🌟"
        false -> "⚠️"
        null -> "💭"
    }
    
    Surface(
        onClick = onClick,
        shape = RoundedCornerShape(16.dp),
        color = backgroundColor
    ) {
        Text(
            text = "$emoji $keyword",
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp),
            style = MaterialTheme.typography.bodyMedium
        )
    }
}

@Composable
private fun CategoryGrid(
    categories: List<String>,
    selectedCategory: String?,
    onCategorySelected: (String?) -> Unit
) {
    val categoryEmojis = mapOf(
        "동물" to "🐾",
        "사물" to "📦",
        "인물" to "👤",
        "장소" to "🏠",
        "상황" to "🎭",
        "자연" to "🌿",
        "색깔" to "🎨",
        "신체" to "🖐️"
    )
    
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        item {
            FilterChip(
                selected = selectedCategory == null,
                onClick = { onCategorySelected(null) },
                label = { Text("전체") }
            )
        }
        items(categories) { category ->
            val emoji = categoryEmojis[category] ?: "📁"
            FilterChip(
                selected = selectedCategory == category,
                onClick = { onCategorySelected(category) },
                label = { Text("$emoji $category") }
            )
        }
    }
}

@Composable
private fun DreamResultCard(
    dream: DreamInterpretationEntity,
    onClick: () -> Unit
) {
    val isGoodColor = when (dream.isGoodDream) {
        true -> MaterialTheme.colorScheme.primary
        false -> MaterialTheme.colorScheme.error
        null -> MaterialTheme.colorScheme.outline
    }
    val fortuneText = when (dream.isGoodDream) {
        true -> "길몽 🌟"
        false -> "흉몽 ⚠️"
        null -> "중립 💭"
    }
    
    OracleCard(
        modifier = Modifier.clickable { onClick() }
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.Top
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = dream.keywordKo,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = dream.category,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = dream.interpretationKo.take(80) + if (dream.interpretationKo.length > 80) "..." else "",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.8f)
                )
            }
            
            Surface(
                shape = RoundedCornerShape(8.dp),
                color = isGoodColor.copy(alpha = 0.1f)
            ) {
                Text(
                    text = fortuneText,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
                    style = MaterialTheme.typography.labelSmall,
                    color = isGoodColor
                )
            }
        }
    }
}

@Composable
private fun DreamDetailDialog(
    dream: DreamInterpretationEntity,
    onDismiss: () -> Unit
) {
    val fortuneText = when (dream.isGoodDream) {
        true -> "🌟 길몽입니다"
        false -> "⚠️ 흉몽입니다"
        null -> "💭 중립적인 꿈입니다"
    }
    
    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text(
                text = "🌙 ${dream.keywordKo}",
                style = MaterialTheme.typography.headlineSmall
            )
        },
        text = {
            Column(
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Surface(
                    shape = RoundedCornerShape(8.dp),
                    color = MaterialTheme.colorScheme.surfaceVariant
                ) {
                    Text(
                        text = fortuneText,
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(12.dp),
                        textAlign = TextAlign.Center,
                        fontWeight = FontWeight.Bold
                    )
                }
                
                Text(
                    text = dream.interpretationKo,
                    style = MaterialTheme.typography.bodyMedium
                )
                
                if (dream.relatedKeywordsKo.isNotBlank()) {
                    Text(
                        text = "관련 키워드: ${dream.relatedKeywordsKo}",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                    )
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) {
                Text("닫기")
            }
        }
    )
}

@Composable
private fun EmptySearchResult() {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(32.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "🔍",
            style = MaterialTheme.typography.displayMedium
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = "검색 결과가 없습니다",
            style = MaterialTheme.typography.titleMedium
        )
        Text(
            text = "다른 키워드로 검색해보세요",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
        )
    }
}
