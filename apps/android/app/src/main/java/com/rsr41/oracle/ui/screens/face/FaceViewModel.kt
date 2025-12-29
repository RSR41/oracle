package com.rsr41.oracle.ui.screens.face

import android.net.Uri
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rsr41.oracle.domain.model.HistoryRecord
import com.rsr41.oracle.domain.model.HistoryType
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.UUID
import javax.inject.Inject

@HiltViewModel
class FaceViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {

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
    }

    fun analyze() {
        if (selectedImageUri == null) return
        
        viewModelScope.launch {
            isAnalyzing = true
            delay(2000) // Simulate processing time
            
            // Mock Analysis (Neutral, Non-sensitive)
            // In real app, this would process the file at 'selectedImageUri'
            // and THEN DELETE IT immediately.
            
            analysisResult = """
                [관상 분석 결과]
                
                품질: 양호 (OK)
                분위기: 차분함 (Calm), 신뢰감 (Trustworthy)
                
                [대화/첫인상 팁]
                눈매가 부드러워 상대방에게 편안한 인상을 줍니다.
                대화 시 미소를 유지하면 더욱 좋은 관계를 형성할 수 있습니다.
                이마가 단정하여 논리적인 이미지를 풍깁니다.
                
                *본 결과는 오락 목적으로 제공되며 과학적 근거가 없습니다.
                *사진은 분석 후 즉시 삭제되었습니다.
            """.trimIndent()
            
            // Delete simulated temp file (Conceptual)
            selectedImageUri = null // Remove reference from UI immediately
            
            isAnalyzing = false
            isAnalyzed = true
            
            saveHistory()
        }
    }

    private fun saveHistory() {
        // 이미지 경로는 절대 저장하지 않음. 텍스트 결과만 저장.
        repository.appendHistoryRecord(
            HistoryRecord(
                id = UUID.randomUUID().toString(),
                type = HistoryType.FACE,
                title = "관상 분석 (이미지 삭제됨)",
                summary = "차분하고 신뢰감을 주는 인상",
                payload = analysisResult,
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
    }
}
