package com.rsr41.oracle.repository

import com.rsr41.oracle.domain.model.Profile

/**
 * 만세력 계산 엔진 인터페이스
 * 향후 실제 온디바이스 라이브러리 교체 용이
 */
interface ManseEngine {
    fun getDaewun(profile: Profile): ManseDaewunResult
    fun getSaeun(profile: Profile, year: Int): ManseSaeunResult
    fun getWolun(profile: Profile, year: Int, month: Int): ManseWolunResult
}

// === 결과 모델 ===

data class ManseDaewunResult(
    val profileId: String,
    val currentDaewun: DaewunItem,
    val daewunList: List<DaewunItem>
)

data class DaewunItem(
    val startAge: Int,
    val startYear: Int,
    val endYear: Int,
    val ganji: String, // 간지 (예: 甲子)
    val keyword: String,
    val description: String,
    val isCurrent: Boolean
)

data class ManseSaeunResult(
    val profileId: String,
    val year: Int,
    val ganji: String, // 예: 甲辰
    val keyword: String,
    val summary: String,
    val quarterlyPoints: List<QuarterlyPoint>
)

data class QuarterlyPoint(
    val quarterName: String, // 1분기, 2분기...
    val title: String,
    val content: String
)

data class ManseWolunResult(
    val profileId: String,
    val year: Int,
    val month: Int,
    val ganji: String, // 예: 丙寅
    val score: Int, // 0~100
    val summary: String,
    val advice: String
)
