package com.rsr41.oracle.ui.screens.compatibility

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.domain.model.HistoryRecord
import com.rsr41.oracle.domain.model.HistoryType
import com.rsr41.oracle.domain.model.Profile
import com.rsr41.oracle.repository.CompatibilityResult
import com.rsr41.oracle.repository.MockCompatibilityEngine
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import java.util.UUID
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

    private val engine = MockCompatibilityEngine()

    var selectedType by mutableStateOf(CompatibilityType.LOVE)
        private set

    var profiles by mutableStateOf<List<Profile>>(emptyList())
        private set

    var myProfile by mutableStateOf<Profile?>(null)
        private set

    var partnerProfile by mutableStateOf<Profile?>(null)
        private set

    var result by mutableStateOf<CompatibilityResult?>(null)
        private set

    init {
        loadProfiles()
    }

    fun loadProfiles() {
        profiles = repository.loadProfiles()
        if (profiles.isNotEmpty()) {
             // 편의상 첫 번째 프로필 자동 선택
             if (myProfile == null) myProfile = profiles.first()
        }
    }

    fun updateType(type: CompatibilityType) {
        selectedType = type
        result = null // 타입 변경 시 결과 초기화 (재분석 유도)
    }

    fun updateMyProfile(profile: Profile?) {
        myProfile = profile
        result = null
    }

    fun updatePartnerProfile(profile: Profile?) {
        partnerProfile = profile
        result = null
    }

    fun canAnalyze(): Boolean {
        return myProfile != null && partnerProfile != null && myProfile!!.id != partnerProfile!!.id
    }

    fun analyze() {
        if (!canAnalyze()) return
        
        val newResult = engine.analyze(myProfile!!, partnerProfile!!, selectedType)
        result = newResult
        
        saveHistory(newResult)
    }
    
    fun reset() {
        // 프로필은 유지하고 결과만 리셋하거나, 전체 리셋. 여기선 결과만 리셋
        result = null
    }

    private fun saveHistory(res: CompatibilityResult) {
        val my = myProfile!!
        val partner = partnerProfile!!
        
        val inputJson = """
            {
                "myProfileId": "${my.id}",
                "partnerProfileId": "${partner.id}",
                "type": "${selectedType.name}"
            }
        """.trimIndent()
        
        val detailJson = """
            {
                "score": ${res.score},
                "summary": "${res.summary}",
                "advice": "${res.advice}",
                "pros": ${res.pros.joinToString(prefix="[", postfix="]") { "\"$it\"" }},
                "cons": ${res.cons.joinToString(prefix="[", postfix="]") { "\"$it\"" }}
            }
        """.trimIndent()

        val record = HistoryRecord(
            id = UUID.randomUUID().toString(),
            type = HistoryType.COMPATIBILITY,
            title = "${my.nickname} & ${partner.nickname} (${selectedType.displayName})",
            summary = "궁합 점수: ${res.score}점 - ${res.summary.take(20)}...",
            payload = detailJson,
            inputSnapshot = inputJson,
            profileId = my.id,
            partnerProfileId = partner.id,
            expiresAt = System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000 // 30 days
        )
        repository.appendHistoryRecord(record)
    }
}
