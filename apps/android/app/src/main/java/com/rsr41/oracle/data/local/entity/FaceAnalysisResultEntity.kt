package com.rsr41.oracle.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * 관상 분석 결과 Entity
 * - 얼굴 분석 결과 저장용
 */
@Entity(tableName = "face_analysis_results")
data class FaceAnalysisResultEntity(
    @PrimaryKey
    val id: String,
    val timestamp: Long,
    val faceShape: String,        // 얼굴형 (둥근형, 각진형, 긴형 등)
    val foreheadAnalysis: String, // 이마 분석
    val eyeAnalysis: String,      // 눈 분석
    val noseAnalysis: String,     // 코 분석
    val mouthAnalysis: String,    // 입 분석
    val chinAnalysis: String,     // 턱 분석
    val overallInterpretationKo: String,
    val overallInterpretationEn: String,
    val photoUri: String? = null  // optional saved photo URI
)
