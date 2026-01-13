package com.rsr41.oracle.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * 사주 콘텐츠 Entity
 * - 오행, 십신, 천간, 지지 등 사주 기본 요소 설명
 */
@Entity(tableName = "saju_content")
data class SajuContentEntity(
    @PrimaryKey
    val id: String,
    val type: String, // "오행", "십신", "천간", "지지", "십이운성"
    val code: String, // e.g., "목", "화", "갑", "자" etc.
    val nameKo: String,
    val nameEn: String,
    val descriptionKo: String,
    val descriptionEn: String,
    val attributeKo: String = "", // 속성/성격 키워드
    val attributeEn: String = "",
    val imagePath: String = ""
)
