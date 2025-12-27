package com.rsr41.oracle.ui.screens.face

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class FaceViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {

    var isImageSelected by mutableStateOf(false)
        private set

    var isAnalyzing by mutableStateOf(false)
        private set

    var isAnalyzed by mutableStateOf(false)
        private set

    var analysisResult by mutableStateOf("")
        private set

    fun selectImage() {
        // 실제로는 런처를 통해 이미지를 받지만, 여기서는 선택된 것으로 시뮬레이션
        isImageSelected = true
        isAnalyzed = false
    }

    fun analyze() {
        if (!isImageSelected) return
        
        isAnalyzing = true
        // 2초 후 분석 완료 시뮬레이션
        // 실제 앱에서는 repository를 통해 서버와 통신하거나 로컬 모델 실행
        
        isAnalyzing = false
        analysisResult = """
            [관상 분석 결과]
            
            전체적으로 명궁(이마 사이)이 밝고 깨끗하여 초년운이 좋고 학문적 성취가 높을 상입니다.
            눈매가 깊고 수려하여 통찰력이 뛰어나며, 주변 사람들에게 신뢰를 주는 인상입니다.
            
            재백궁(코)의 모양이 견실하여 중년 이후 재무적인 흐름이 안정적일 것으로 보입니다.
            입매가 분명하여 자기 주관이 뚜렷하고 말에 힘이 실려 리더로서의 자질이 충분합니다.
            
            주의할 점은 눈썹 끝이 약간 흐린 편이니 결단력이 필요한 순간에 주저하지 않도록 마음을 다스리는 것이 좋습니다.
        """.trimIndent()
        
        isAnalyzed = true
        
        // 히스토리 저장
        repository.appendHistoryRecord(
            com.rsr41.oracle.domain.model.HistoryRecord(
                id = java.util.UUID.randomUUID().toString(),
                type = com.rsr41.oracle.domain.model.HistoryType.FACE,
                title = "관상 분석 결과",
                summary = "명궁이 밝고 중년운이 길한 상",
                payload = analysisResult,
                profileId = null
            )
        )
    }

    fun reset() {
        isImageSelected = false
        isAnalyzed = false
        isAnalyzing = false
        analysisResult = ""
    }
}
