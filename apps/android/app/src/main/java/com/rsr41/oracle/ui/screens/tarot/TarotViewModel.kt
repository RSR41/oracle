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

@HiltViewModel
class TarotViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {

    var selectedIds by mutableStateOf<List<Int>>(emptyList())
        private set

    var currentPage by mutableIntStateOf(0)
    
    var showResult by mutableStateOf(false)
        private set

    var resultInterpretation by mutableStateOf<TarotResult?>(null)
        private set

    fun toggleCard(id: Int) {
        if (selectedIds.contains(id)) {
            selectedIds = selectedIds - id
        } else if (selectedIds.size < 3) {
            selectedIds = selectedIds + id
        }
    }

    fun generateResult() {
        if (selectedIds.size == 3) {
            val selectedCards = selectedIds.map { id -> TarotData.cards.find { it.id == id }!! }
            
            // 결정적(Deterministic) 결과 생성을 위해 ID와 오늘 날짜를 조합한 시드 사용 가능
            // 여기서는 간단히 카드 정보들을 조합하여 요약 생성
            val summary = "선택하신 카드는 ${selectedCards[0].name}, ${selectedCards[1].name}, ${selectedCards[2].name}입니다."
            val detail = "당신의 현재 상황은 '${selectedCards[0].keyword}' 기운이 강하며, " +
                    "앞으로 '${selectedCards[1].keyword}' 과정을 거쳐, " +
                    "결과적으로 '${selectedCards[2].keyword}' 상태에 이르게 될 것입니다."

            resultInterpretation = TarotResult(
                selectedCards = selectedCards,
                summary = summary,
                detail = detail
            )
            showResult = true
        }
    }

    fun saveToHistory() {
        val interpretation = resultInterpretation ?: return
        
        // JSON 페이로드 생성 (간단히)
        val payload = """
            {
                "selectedCardIds": ${selectedIds},
                "summary": "${interpretation.summary}",
                "detail": "${interpretation.detail}"
            }
        """.trimIndent()

        val record = HistoryRecord(
            id = UUID.randomUUID().toString(),
            type = HistoryType.TAROT,
            title = "타로 상담 결과",
            summary = interpretation.summary.take(30) + "...",
            payload = payload,
            profileId = null // 타로는 프로필 없이도 가능하게 설정
        )
        
        repository.appendHistoryRecord(record)
    }

    fun reset() {
        selectedIds = emptyList()
        showResult = false
        resultInterpretation = null
        currentPage = 0
    }
}

data class TarotResult(
    val selectedCards: List<TarotCard>,
    val summary: String,
    val detail: String
)
