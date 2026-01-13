package com.rsr41.oracle.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * 꿈해몽 Entity
 * - 키워드 기반 꿈 해석 데이터
 * - FTS(Full-Text Search) 검색 지원용
 */
@Entity(tableName = "dream_interpretations")
data class DreamInterpretationEntity(
    @PrimaryKey
    val id: String,
    val keywordKo: String,   // 주요 키워드 (한글)
    val keywordEn: String,   // 주요 키워드 (영어)
    val category: String,    // "동물", "사물", "인물", "장소", "상황", "자연", "색깔"
    val synonymsKo: String,  // 동의어 (comma-separated)
    val synonymsEn: String,
    val interpretationKo: String,
    val interpretationEn: String,
    val isGoodDream: Boolean? = null, // true=길몽, false=흉몽, null=중립
    val relatedKeywordsKo: String = "", // 관련 키워드
    val relatedKeywordsEn: String = ""
)
