package com.rsr41.oracle.domain.engine

import android.net.Uri
import com.rsr41.oracle.domain.model.BirthInfo

/**
 * 사주/만세력 계산 엔진 인터페이스
 * 플러그인 방식으로 구현체 교체 가능
 */
interface FortuneEngine {
    /**
     * 사주 계산
     * @param birthInfo 생년월일시 정보
     * @return 천간지지, 오행, 십신, 대운, 세운, 해석
     */
    suspend fun calculate(birthInfo: BirthInfo): Result<FortuneResult>
    
    /**
     * 엔진 정보 (디버깅/로깅용)
     */
    fun getEngineInfo(): EngineInfo
}

/**
 * 얼굴 분석 엔진 인터페이스
 * MVP: ML Kit, 향후: Cloud AI
 */
interface FaceAnalysisEngine {
    suspend fun analyze(imageUri: Uri): Result<FaceAnalysisResult>
    fun getCapabilities(): EngineCapabilities
}

/**
 * 엔진 메타정보
 */
data class EngineInfo(
    val name: String,
    val version: String,
    val accuracy: AccuracyLevel
)

enum class AccuracyLevel { LOW, MEDIUM, HIGH }

/**
 * 엔진 기능 정보
 */
data class EngineCapabilities(
    val canDetectExpression: Boolean,
    val canDetectQuality: Boolean,
    val canDetectSymmetry: Boolean,
    val requiresInternet: Boolean
)

/**
 * 사주 계산 결과
 */
data class FortuneResult(
    val birthDate: String,         // yyyy-MM-dd
    val birthTime: String,         // HH:mm or ""
    val pillars: FourPillars,
    val elements: Map<String, Int>,
    val tenGods: Map<String, Int>,
    val interpretation: String,
    val luckyColors: List<String> = emptyList(),
    val luckyNumbers: List<Int> = emptyList(),
    val engineInfo: EngineInfo
)

/**
 * 사주 기둥 (년/월/일/시)
 */
data class FourPillars(
    val year: Pillar,
    val month: Pillar,
    val day: Pillar,
    val hour: Pillar?
)

data class Pillar(
    val heavenlyStem: String,  // 천간
    val earthlyBranch: String  // 지지
) {
    val ganji: String get() = "$heavenlyStem$earthlyBranch"
}

/**
 * 얼굴 분석 결과
 */
data class FaceAnalysisResult(
    val sessionId: String,
    val timestamp: Long,
    val features: FaceFeatures,
    val interpretation: String,
    val privacyLevel: PrivacyLevel
)

data class FaceFeatures(
    val faceShape: FaceShape,
    val eyeDistance: Float,
    val jawlineAngle: Float,
    val symmetryScore: Float,
    val skinTone: SkinToneCategory,
    val expressionType: ExpressionType,
    val imageQuality: ImageQuality
)

enum class FaceShape { OVAL, ROUND, SQUARE, HEART, LONG }
enum class SkinToneCategory { FAIR, MEDIUM, OLIVE, DARK }
enum class ExpressionType(val description: String) {
    NEUTRAL("편안"),
    HAPPY("밝고 긍정적"),
    SERIOUS("진지하고 차분")
}
enum class ImageQuality { HIGH, MEDIUM, LOW, BLURRY }
enum class PrivacyLevel {
    NO_COLLECTION,      // 데이터 수집 안 함
    ANONYMOUS_STATS,    // 익명 통계만
    FULL_CONSENT        // 전체 동의
}
