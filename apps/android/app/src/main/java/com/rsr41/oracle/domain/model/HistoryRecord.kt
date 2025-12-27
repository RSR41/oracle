package com.rsr41.oracle.domain.model

/**
 * 히스토리 기록 모델
 * - payload에 JSON 형태로 상세 데이터를 저장하여 나중에 복원 가능하게 함
 */
data class HistoryRecord(
    val id: String,
    val type: HistoryType,
    val title: String,
    val summary: String,
    val payload: String, // JSON string
    val profileId: String?,
    val partnerProfileId: String? = null,
    val createdAt: Long = System.currentTimeMillis()
)
