package com.rsr41.oracle.domain.model

data class HistoryItem(
    val id: String,
    val birthInfo: BirthInfo,
    val result: SajuResult
)
