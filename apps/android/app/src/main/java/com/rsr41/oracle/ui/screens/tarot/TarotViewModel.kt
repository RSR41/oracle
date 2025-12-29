package com.rsr41.oracle.ui.screens.tarot

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.repository.SajuRepository
import com.rsr41.oracle.domain.model.*
import dagger.hilt.android.lifecycle.HiltViewModel
import java.util.*
import javax.inject.Inject

data class TarotCardState(
    val card: TarotCard,
    val isReversed: Boolean // Fixed per session
)

@HiltViewModel
class TarotViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {

    // 36장 덱 초기화 (세션 고정 역방향 여부)
    val deck: List<TarotCardState> = TarotData.cards.map { card ->
        TarotCardState(card, Random().nextBoolean())
    }

    // 선택된 카드들 (순서 보장)
    var selectedCards by mutableStateOf<List<TarotCardState>>(emptyList())
        private set

    var currentPage by mutableIntStateOf(0)
    
    var showResult by mutableStateOf(false)
        private set

    var resultInterpretation by mutableStateOf<TarotResult?>(null)
        private set

    fun toggleCard(cardState: TarotCardState) {
        if (selectedCards.contains(cardState)) {
            selectedCards = selectedCards - cardState
        } else if (selectedCards.size < 3) {
            selectedCards = selectedCards + cardState
        }
    }
    
    fun isSelected(cardState: TarotCardState): Boolean = selectedCards.contains(cardState)

    fun generateResult() {
        if (selectedCards.size != 3) return

        val c1 = selectedCards[0]
        val c2 = selectedCards[1]
        val c3 = selectedCards[2]
        
        // 카드 1: 과거
        val pastMeaning = if (c1.isReversed) c1.card.meaningReversed else c1.card.meaningUpright
        val pastKeyword = if (c1.isReversed) "${c1.card.keywordEn} (Reversed)" else c1.card.keywordEn
        
        // 카드 2: 현재
        val presentMeaning = if (c2.isReversed) c2.card.meaningReversed else c2.card.meaningUpright
        val presentKeyword = if (c2.isReversed) "${c2.card.keywordEn} (Reversed)" else c2.card.keywordEn
        
        // 카드 3: 미래/조언
        val futureMeaning = if (c3.isReversed) c3.card.meaningReversed else c3.card.meaningUpright
        val futureKeyword = if (c3.isReversed) "${c3.card.keywordEn} (Reversed)" else c3.card.keywordEn
        
        val summary = "${c1.card.nameKo}, ${c2.card.nameKo}, ${c3.card.nameKo} 카드가 선택되었습니다."
        
        val detail = """
            [과거/원인] ${c1.card.nameKo} (${if(c1.isReversed) "역방향" else "정방향"})
            $pastMeaning
            
            [현재/상황] ${c2.card.nameKo} (${if(c2.isReversed) "역방향" else "정방향"})
            $presentMeaning
            
            [미래/조언] ${c3.card.nameKo} (${if(c3.isReversed) "역방향" else "정방향"})
            $futureMeaning
        """.trimIndent()

        resultInterpretation = TarotResult(
            selectedCards = selectedCards,
            summary = summary,
            detail = detail
        )
        showResult = true
    }

    fun saveToHistory() {
        val interpretation = resultInterpretation ?: return
        
        // JSON 페이로드 생성
        val selectedIds = selectedCards.map { mapOf("id" to it.card.id, "reversed" to it.isReversed) }
        
        val payload = """
            {
                "selectedCards": $selectedIds,
                "summary": "${interpretation.summary}",
                "detail": "${interpretation.detail.replace("\n", "\\n")}"
            }
        """.trimIndent()

        val record = HistoryRecord(
            id = UUID.randomUUID().toString(),
            type = HistoryType.TAROT,
            title = "타로 상담 (${selectedCards.map { it.card.nameKo }.joinToString()})",
            summary = interpretation.summary.take(40) + "...",
            payload = payload,
            profileId = null
        )
        
        repository.appendHistoryRecord(record)
    }

    fun reset() {
        selectedCards = emptyList()
        showResult = false
        resultInterpretation = null
        currentPage = 0
    }
}

data class TarotResult(
    val selectedCards: List<TarotCardState>,
    val summary: String,
    val detail: String
)
