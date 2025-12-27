package com.rsr41.oracle.ui.screens.compatibility

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.domain.model.Profile
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

enum class CompatibilityType(val displayName: String) {
    LOVE("연애"),
    MARRIAGE("결혼"),
    BUSINESS("비즈니스")
}

@HiltViewModel
class CompatibilityViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {

    var selectedType by mutableStateOf(CompatibilityType.LOVE)
        private set

    var profiles by mutableStateOf<List<Profile>>(emptyList())
        private set

    var myProfile by mutableStateOf<Profile?>(null)
        private set

    var partnerProfile by mutableStateOf<Profile?>(null)
        private set

    var isAnalyzed by mutableStateOf(false)
        private set

    var analysisResult by mutableStateOf("")
        private set

    init {
        loadProfiles()
    }

    fun loadProfiles() {
        profiles = repository.loadProfiles()
    }

    fun updateType(type: CompatibilityType) {
        selectedType = type
        isAnalyzed = false
    }

    fun updateMyProfile(profile: Profile?) {
        myProfile = profile
        isAnalyzed = false
    }

    fun updatePartnerProfile(profile: Profile?) {
        partnerProfile = profile
        isAnalyzed = false
    }

    fun canAnalyze(): Boolean {
        return myProfile != null && partnerProfile != null
    }

    fun analyze() {
        if (!canAnalyze()) return
        
        val my = myProfile!!
        val partner = partnerProfile!!
        
        // 결정론적인 더미 결과 생성 (이름 기반)
        val score = ((my.nickname.hashCode() + partner.nickname.hashCode()).toLong() % 41) + 60 // 60~100점
        
        analysisResult = """
            [${selectedType.displayName} 궁합 결과]
            
            두 분의 궁합 점수는 ${score}점입니다.
            
            ${my.nickname}님(나)과 ${partner.nickname}님(상대)은 서로의 부족한 기운을 채워주는 좋은 관계입니다. 
            특히 ${selectedType.displayName} 면에서 서로에 대한 이해도가 높아 갈등이 생겨도 지혜롭게 해결할 수 있는 운을 가지고 있습니다.
            
            앞으로 서로의 다름을 인정하고 존중한다면 더욱 깊은 신뢰를 쌓아갈 수 있을 것입니다.
        """.trimIndent()
        
        isAnalyzed = true
        
        // 히스토리 저장
        repository.appendHistoryRecord(
            com.rsr41.oracle.domain.model.HistoryRecord(
                id = java.util.UUID.randomUUID().toString(),
                type = com.rsr41.oracle.domain.model.HistoryType.COMPATIBILITY,
                title = "${my.nickname} ❤️ ${partner.nickname}",
                summary = "${selectedType.displayName} 궁합 점수: ${score}점",
                payload = analysisResult,
                profileId = my.id,
                partnerProfileId = partner.id
            )
        )
    }

    fun reset() {
        myProfile = null
        partnerProfile = null
        isAnalyzed = false
        analysisResult = ""
    }
}
