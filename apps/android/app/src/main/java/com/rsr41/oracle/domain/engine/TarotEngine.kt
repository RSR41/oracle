package com.rsr41.oracle.domain.engine

import com.rsr41.oracle.domain.model.TarotCard
import com.rsr41.oracle.domain.model.TarotData
import kotlin.random.Random

/**
 * 타로 엔진
 * 역방향(리버스) 50% 확률 지원
 */
class TarotEngine {
    private val random = Random(System.currentTimeMillis())
    
    /**
     * 덱 셔플 (Major Arcana 12장 또는 전체)
     * @param useMajorOnly Major Arcana(0-21)만 사용할지 여부
     */
    fun shuffleDeck(useMajorOnly: Boolean = true): List<TarotCard> {
        val deck = if (useMajorOnly) {
            TarotData.cards.filter { it.id <= 11 } // MVP: 12장만
        } else {
            TarotData.cards
        }
        return deck.shuffled(random)
    }
    
    /**
     * 카드 뽑기 (과거/현재/미래)
     * @param count 뽑을 카드 수 (기본 3장)
     */
    fun drawCards(count: Int = 3): List<DrawnCard> {
        val shuffled = shuffleDeck(useMajorOnly = true)
        return shuffled.take(count).mapIndexed { index, card ->
            DrawnCard(
                card = card,
                isReversed = random.nextBoolean(), // 50% 확률
                position = when (index) {
                    0 -> CardPosition.PAST
                    1 -> CardPosition.PRESENT
                    2 -> CardPosition.FUTURE
                    else -> CardPosition.PRESENT
                }
            )
        }
    }
    
    /**
     * 특정 카드 ID로 카드 찾기
     */
    fun getCardById(id: Int): TarotCard? {
        return TarotData.cards.find { it.id == id }
    }
}

/**
 * 뽑은 카드
 */
data class DrawnCard(
    val card: TarotCard,
    val isReversed: Boolean,
    val position: CardPosition
) {
    val interpretation: String
        get() = if (isReversed) card.meaningReversed else card.meaningUpright
        
    val displayName: String
        get() = "${card.nameKo}${if (isReversed) " (역방향)" else ""}"
}

enum class CardPosition(val displayName: String) {
    PAST("과거"),
    PRESENT("현재"),
    FUTURE("미래")
}

