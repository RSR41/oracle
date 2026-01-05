package com.rsr41.oracle.domain.model

data class SajuResult(
    val summaryToday: String,
    val pillars: String,
    val luckyColor: String = "#FFD700", // Default Gold
    val luckyNumber: Int = 7,
    val generatedAtMillis: Long
)
