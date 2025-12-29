package com.rsr41.oracle.repository

import com.rsr41.oracle.domain.model.Profile
import com.rsr41.oracle.ui.screens.compatibility.CompatibilityType

/**
 * 궁합 계산 엔진 인터페이스
 */
interface CompatibilityEngine {
    fun analyze(myProfile: Profile, partnerProfile: Profile, type: CompatibilityType): CompatibilityResult
}

data class CompatibilityResult(
    val myProfileId: String,
    val partnerProfileId: String,
    val type: CompatibilityType,
    val score: Int, // 0~100
    val summary: String,
    val pros: List<String>,
    val cons: List<String>,
    val advice: String,
    val generatedAt: Long = System.currentTimeMillis()
)
