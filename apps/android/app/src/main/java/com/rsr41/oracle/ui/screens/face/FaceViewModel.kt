package com.rsr41.oracle.ui.screens.face

import android.content.Context
import android.net.Uri
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rsr41.oracle.data.local.OracleDatabase
import com.rsr41.oracle.data.local.entity.FaceAnalysisResultEntity
import com.rsr41.oracle.domain.engine.FaceAnalyzer
import com.rsr41.oracle.domain.model.HistoryRecord
import com.rsr41.oracle.domain.model.HistoryType
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.UUID
import javax.inject.Inject

@HiltViewModel
class FaceViewModel @Inject constructor(
    private val repository: SajuRepository,
    @ApplicationContext private val context: Context
) : ViewModel() {

    private val faceAnalyzer = FaceAnalyzer(context)
    private val faceAnalysisDao = OracleDatabase.getInstance(context).faceAnalysisDao()

    var hasConsented by mutableStateOf(false)
        private set

    var selectedImageUri by mutableStateOf<Uri?>(null)
        private set

    var isAnalyzing by mutableStateOf(false)
        private set

    var isAnalyzed by mutableStateOf(false)
        private set

    var analysisResult by mutableStateOf("")
        private set
    
    var analysisResultEntity by mutableStateOf<FaceAnalysisResultEntity?>(null)
        private set
    
    var errorMessage by mutableStateOf<String?>(null)
        private set

    init {
        checkConsent()
    }

    fun checkConsent() {
        hasConsented = repository.getFaceConsent()
    }

    fun agreeConsent() {
        repository.setFaceConsent(true)
        hasConsented = true
    }

    fun onImageSelected(uri: Uri?) {
        selectedImageUri = uri
        isAnalyzed = false
        errorMessage = null
    }

    fun analyze() {
        val uri = selectedImageUri ?: return
        
        viewModelScope.launch(Dispatchers.IO) {
            isAnalyzing = true
            errorMessage = null
            
            try {
                // ML Kit을 사용한 실제 얼굴 분석
                val result = faceAnalyzer.analyzeFromUri(uri)
                
                if (result != null) {
                    analysisResultEntity = result
                    analysisResult = result.overallInterpretationKo
                    
                    // DB에 결과 저장
                    faceAnalysisDao.insert(result)
                    
                    // 히스토리에 추가
                    saveHistory(result)
                    
                    isAnalyzed = true
                } else {
                    errorMessage = "얼굴을 감지할 수 없습니다. 정면 사진을 사용해 주세요."
                }
            } catch (e: Exception) {
                errorMessage = "분석 중 오류가 발생했습니다: ${e.message}"
            } finally {
                // 개인정보 보호: UI에서 URI 참조 제거
                selectedImageUri = null
                isAnalyzing = false
            }
        }
    }

    private fun saveHistory(result: FaceAnalysisResultEntity) {
        // 이미지 경로는 절대 저장하지 않음. 텍스트 결과만 저장.
        repository.appendHistoryRecord(
            HistoryRecord(
                id = UUID.randomUUID().toString(),
                type = HistoryType.FACE,
                title = "관상 분석 (${result.faceShape})",
                summary = "얼굴형: ${result.faceShape}",
                payload = result.overallInterpretationKo,
                profileId = null, // 익명 분석
                expiresAt = System.currentTimeMillis() + 7 * 24 * 60 * 60 * 1000
            )
        )
    }

    fun reset() {
        selectedImageUri = null
        isAnalyzed = false
        isAnalyzing = false
        analysisResult = ""
        analysisResultEntity = null
        errorMessage = null
    }
}
