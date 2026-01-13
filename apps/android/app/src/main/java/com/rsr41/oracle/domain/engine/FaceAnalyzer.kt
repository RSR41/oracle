package com.rsr41.oracle.domain.engine

import android.content.Context
import android.graphics.Bitmap
import android.net.Uri
import android.util.Log
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.face.Face
import com.google.mlkit.vision.face.FaceContour
import com.google.mlkit.vision.face.FaceDetection
import com.google.mlkit.vision.face.FaceDetectorOptions
import com.google.mlkit.vision.face.FaceLandmark
import com.rsr41.oracle.data.local.entity.FaceAnalysisResultEntity
import kotlinx.coroutines.suspendCancellableCoroutine
import java.util.UUID
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

/**
 * ML Kit을 사용한 관상 분석 엔진
 */
class FaceAnalyzer(private val context: Context) {
    
    companion object {
        private const val TAG = "FaceAnalyzer"
    }
    
    private val faceDetectorOptions = FaceDetectorOptions.Builder()
        .setPerformanceMode(FaceDetectorOptions.PERFORMANCE_MODE_ACCURATE)
        .setLandmarkMode(FaceDetectorOptions.LANDMARK_MODE_ALL)
        .setContourMode(FaceDetectorOptions.CONTOUR_MODE_ALL)
        .setClassificationMode(FaceDetectorOptions.CLASSIFICATION_MODE_ALL)
        .build()
    
    private val faceDetector = FaceDetection.getClient(faceDetectorOptions)
    
    /**
     * URI로부터 얼굴을 분석하여 관상 결과를 반환
     */
    suspend fun analyzeFromUri(uri: Uri): FaceAnalysisResultEntity? {
        return try {
            val image = InputImage.fromFilePath(context, uri)
            val faces = detectFaces(image)
            
            if (faces.isEmpty()) {
                Log.w(TAG, "No face detected in image")
                return null
            }
            
            // 가장 큰 얼굴 사용
            val mainFace = faces.maxByOrNull { it.boundingBox.width() * it.boundingBox.height() }
                ?: return null
            
            analyzeFace(mainFace, uri.toString())
        } catch (e: Exception) {
            Log.e(TAG, "Error analyzing face from URI", e)
            null
        }
    }
    
    /**
     * Bitmap으로부터 얼굴을 분석
     */
    suspend fun analyzeFromBitmap(bitmap: Bitmap): FaceAnalysisResultEntity? {
        return try {
            val image = InputImage.fromBitmap(bitmap, 0)
            val faces = detectFaces(image)
            
            if (faces.isEmpty()) {
                Log.w(TAG, "No face detected in bitmap")
                return null
            }
            
            val mainFace = faces.maxByOrNull { it.boundingBox.width() * it.boundingBox.height() }
                ?: return null
            
            analyzeFace(mainFace, null)
        } catch (e: Exception) {
            Log.e(TAG, "Error analyzing face from bitmap", e)
            null
        }
    }
    
    private suspend fun detectFaces(image: InputImage): List<Face> {
        return suspendCancellableCoroutine { continuation ->
            faceDetector.process(image)
                .addOnSuccessListener { faces ->
                    Log.d(TAG, "Detected ${faces.size} face(s)")
                    continuation.resume(faces)
                }
                .addOnFailureListener { e ->
                    Log.e(TAG, "Face detection failed", e)
                    continuation.resumeWithException(e)
                }
        }
    }
    
    private fun analyzeFace(face: Face, photoUri: String?): FaceAnalysisResultEntity {
        // 얼굴형 분석
        val faceShape = analyzeFaceShape(face)
        
        // 각 부위별 분석
        val foreheadAnalysis = analyzeForeheadArea(face)
        val eyeAnalysis = analyzeEyes(face)
        val noseAnalysis = analyzeNose(face)
        val mouthAnalysis = analyzeMouth(face)
        val chinAnalysis = analyzeChin(face)
        
        // 종합 해석 생성
        val (interpretationKo, interpretationEn) = generateInterpretation(
            faceShape, foreheadAnalysis, eyeAnalysis, noseAnalysis, mouthAnalysis, chinAnalysis
        )
        
        return FaceAnalysisResultEntity(
            id = UUID.randomUUID().toString(),
            timestamp = System.currentTimeMillis(),
            faceShape = faceShape,
            foreheadAnalysis = foreheadAnalysis,
            eyeAnalysis = eyeAnalysis,
            noseAnalysis = noseAnalysis,
            mouthAnalysis = mouthAnalysis,
            chinAnalysis = chinAnalysis,
            overallInterpretationKo = interpretationKo,
            overallInterpretationEn = interpretationEn,
            photoUri = photoUri
        )
    }
    
    private fun analyzeFaceShape(face: Face): String {
        val boundingBox = face.boundingBox
        val width = boundingBox.width().toFloat()
        val height = boundingBox.height().toFloat()
        val ratio = height / width
        
        return when {
            ratio > 1.4 -> "긴형"      // Long face
            ratio < 1.1 -> "둥근형"    // Round face
            else -> "타원형"           // Oval face
        }
    }
    
    private fun analyzeForeheadArea(face: Face): String {
        // 이마 영역 분석 (윤곽 기반)
        val faceContour = face.getContour(FaceContour.FACE)
        if (faceContour != null) {
            val points = faceContour.points
            if (points.size > 10) {
                val topY = points.minOfOrNull { it.y } ?: 0f
                val cheekY = face.boundingBox.centerY().toFloat()
                val foreheadRatio = (cheekY - topY) / face.boundingBox.height()
                
                return when {
                    foreheadRatio > 0.35 -> "넓은 이마 - 지적이고 학구적인 성향"
                    foreheadRatio < 0.25 -> "좁은 이마 - 실용적이고 현실적인 성향"
                    else -> "균형 잡힌 이마 - 안정적인 사고력"
                }
            }
        }
        return "분석 중"
    }
    
    private fun analyzeEyes(face: Face): String {
        val leftEye = face.getLandmark(FaceLandmark.LEFT_EYE)
        val rightEye = face.getLandmark(FaceLandmark.RIGHT_EYE)
        
        val smilingProb = face.smilingProbability ?: 0f
        val leftEyeOpenProb = face.leftEyeOpenProbability ?: 0f
        val rightEyeOpenProb = face.rightEyeOpenProbability ?: 0f
        val avgEyeOpen = (leftEyeOpenProb + rightEyeOpenProb) / 2
        
        val eyeAnalysis = StringBuilder()
        
        if (leftEye != null && rightEye != null) {
            val eyeDistance = kotlin.math.abs(leftEye.position.x - rightEye.position.x)
            val faceWidth = face.boundingBox.width()
            val eyeSpacingRatio = eyeDistance / faceWidth
            
            eyeAnalysis.append(when {
                eyeSpacingRatio > 0.35 -> "눈 간격이 넓음 - 넓은 시야와 관대한 성격"
                eyeSpacingRatio < 0.25 -> "눈 간격이 좁음 - 집중력이 뛰어남"
                else -> "균형 잡힌 눈 간격 - 조화로운 성격"
            })
        }
        
        if (avgEyeOpen > 0.7) {
            eyeAnalysis.append(", 또렷한 눈 - 명석하고 총명함")
        }
        
        return eyeAnalysis.toString().ifEmpty { "눈 분석 진행됨" }
    }
    
    private fun analyzeNose(face: Face): String {
        val noseBase = face.getLandmark(FaceLandmark.NOSE_BASE)
        
        return if (noseBase != null) {
            val noseCenterX = noseBase.position.x
            val faceCenterX = face.boundingBox.centerX()
            val isSymmetric = kotlin.math.abs(noseCenterX - faceCenterX) < face.boundingBox.width() * 0.05
            
            if (isSymmetric) {
                "균형 잡힌 코 - 정직하고 성실한 성품"
            } else {
                "개성 있는 코 - 독창적인 사고방식"
            }
        } else {
            "코 분석 진행됨"
        }
    }
    
    private fun analyzeMouth(face: Face): String {
        val leftMouth = face.getLandmark(FaceLandmark.MOUTH_LEFT)
        val rightMouth = face.getLandmark(FaceLandmark.MOUTH_RIGHT)
        val smilingProb = face.smilingProbability ?: 0f
        
        val mouthAnalysis = StringBuilder()
        
        if (leftMouth != null && rightMouth != null) {
            val mouthWidth = kotlin.math.abs(leftMouth.position.x - rightMouth.position.x)
            val faceWidth = face.boundingBox.width()
            val mouthRatio = mouthWidth / faceWidth
            
            mouthAnalysis.append(when {
                mouthRatio > 0.4 -> "넓은 입 - 표현력이 풍부하고 사교적"
                mouthRatio < 0.3 -> "작은 입 - 신중하고 섬세한 성격"
                else -> "균형 잡힌 입 - 조화로운 대인관계"
            })
        }
        
        if (smilingProb > 0.5) {
            mouthAnalysis.append(", 밝은 미소 - 긍정적이고 매력적인 인상")
        }
        
        return mouthAnalysis.toString().ifEmpty { "입 분석 진행됨" }
    }
    
    private fun analyzeChin(face: Face): String {
        val boundingBox = face.boundingBox
        val faceHeight = boundingBox.height()
        val faceWidth = boundingBox.width()
        
        // 하관 비율 추정
        return when {
            faceWidth.toFloat() / faceHeight > 0.8 -> "강인한 턱선 - 의지가 강하고 결단력 있음"
            faceWidth.toFloat() / faceHeight < 0.6 -> "날렵한 턱선 - 예술적 감각과 섬세함"
            else -> "조화로운 턱선 - 안정적이고 믿음직한 인상"
        }
    }
    
    private fun generateInterpretation(
        faceShape: String,
        forehead: String,
        eyes: String,
        nose: String,
        mouth: String,
        chin: String
    ): Pair<String, String> {
        val koBuilder = StringBuilder()
        val enBuilder = StringBuilder()
        
        koBuilder.append("📊 관상 분석 결과\n\n")
        koBuilder.append("얼굴형: $faceShape\n\n")
        koBuilder.append("🌟 종합 해석\n")
        koBuilder.append("당신의 얼굴에는 독특한 개성과 매력이 담겨 있습니다. ")
        koBuilder.append("${forehead.split(" - ").lastOrNull() ?: ""} ")
        koBuilder.append("${eyes.split(",").firstOrNull()?.split(" - ")?.lastOrNull() ?: ""} ")
        koBuilder.append("${mouth.split(",").firstOrNull()?.split(" - ")?.lastOrNull() ?: ""} ")
        koBuilder.append("전반적으로 조화롭고 균형 잡힌 인상을 가지고 있습니다.\n\n")
        koBuilder.append("💡 운세 조언\n")
        koBuilder.append("당신의 관상은 좋은 기운을 담고 있습니다. 자신감을 가지고 새로운 도전에 나서세요. ")
        koBuilder.append("대인관계에서 진실됨을 유지하면 좋은 결과가 있을 것입니다.")
        
        enBuilder.append("📊 Face Reading Analysis\n\n")
        enBuilder.append("Face Shape: ${translateFaceShape(faceShape)}\n\n")
        enBuilder.append("🌟 Overall Interpretation\n")
        enBuilder.append("Your face reveals unique personality and charm. ")
        enBuilder.append("You show signs of intelligence, balance, and harmony. ")
        enBuilder.append("Overall, you have a well-balanced and harmonious appearance.\n\n")
        enBuilder.append("💡 Fortune Advice\n")
        enBuilder.append("Your facial features carry positive energy. ")
        enBuilder.append("Move forward with confidence in new challenges. ")
        enBuilder.append("Maintaining sincerity in relationships will bring good results.")
        
        return Pair(koBuilder.toString(), enBuilder.toString())
    }
    
    private fun translateFaceShape(shape: String): String {
        return when (shape) {
            "긴형" -> "Long"
            "둥근형" -> "Round"
            "타원형" -> "Oval"
            else -> shape
        }
    }
}
