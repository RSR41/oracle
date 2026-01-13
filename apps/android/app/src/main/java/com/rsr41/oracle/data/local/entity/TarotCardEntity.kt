package com.rsr41.oracle.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * 타로 카드 Entity
 * - 22장 메이저 아르카나 + 56장 마이너 아르카나
 * - 정방향/역방향 해석 포함
 */
@Entity(tableName = "tarot_cards")
data class TarotCardEntity(
    @PrimaryKey
    val id: String,
    val nameKo: String,
    val nameEn: String,
    val category: String, // "MAJOR" or "MINOR"
    val number: Int,
    val uprightMeaningKo: String,
    val uprightMeaningEn: String,
    val reversedMeaningKo: String,
    val reversedMeaningEn: String,
    val keywordsKo: String, // comma-separated
    val keywordsEn: String, // comma-separated
    val imagePath: String = "" // optional asset path
)
