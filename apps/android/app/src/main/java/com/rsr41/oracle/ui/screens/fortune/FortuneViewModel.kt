package com.rsr41.oracle.ui.screens.fortune

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.domain.model.HistoryRecord
import com.rsr41.oracle.domain.model.HistoryType
import com.rsr41.oracle.domain.model.Profile
import com.rsr41.oracle.repository.ManseSaeunResult
import com.rsr41.oracle.repository.ManseDaewunResult
import com.rsr41.oracle.repository.ManseWolunResult
import com.rsr41.oracle.repository.MockManseEngine
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import java.util.Calendar
import javax.inject.Inject

@HiltViewModel
class FortuneViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {

    private val engine = MockManseEngine() // DI injection waiting for next refactor

    var profiles by mutableStateOf<List<Profile>>(emptyList())
        private set

    var selectedProfile by mutableStateOf<Profile?>(null)
        private set

    var selectedTabIndex by mutableStateOf(0)
        private set

    var selectedYear by mutableStateOf(Calendar.getInstance().get(Calendar.YEAR))
        private set

    var daewunResult by mutableStateOf<ManseDaewunResult?>(null)
        private set
    var saeunResult by mutableStateOf<ManseSaeunResult?>(null)
        private set
    var wolunList by mutableStateOf<List<ManseWolunResult>>(emptyList())
        private set

    init {
        loadProfiles()
    }

    fun loadProfiles() {
        profiles = repository.loadProfiles()
        if (profiles.isNotEmpty() && selectedProfile == null) {
            updateSelectedProfile(profiles.first())
        }
    }

    fun updateSelectedProfile(profile: Profile?) {
        selectedProfile = profile
        refreshData()
    }

    fun updateTabIndex(index: Int) {
        selectedTabIndex = index
        refreshData()
    }
    
    fun updateYear(year: Int) {
        selectedYear = year
        if (selectedTabIndex > 0) refreshData()
    }

    private fun refreshData() {
        val profile = selectedProfile ?: return
        
        when (selectedTabIndex) {
            0 -> { // Daewun
                daewunResult = engine.getDaewun(profile)
            }
            1 -> { // Saeun
                saeunResult = engine.getSaeun(profile, selectedYear)
            }
            2 -> { // Wolun
                val list = mutableListOf<ManseWolunResult>()
                for (m in 1..12) {
                    list.add(engine.getWolun(profile, selectedYear, m))
                }
                wolunList = list
            }
        }
    }

    // 히스토리 저장
    fun saveHistory() {
        val profile = selectedProfile ?: return
        
        // MVP: 현재 탭의 내용을 저장
        val (subtype, summary) = when (selectedTabIndex) {
            0 -> "DAEUN" to "${profile.nickname}님의 대운 분석"
            1 -> "SAEUN" to "${profile.nickname}님의 $selectedYear 세운"
            2 -> "WOLUN" to "${profile.nickname}님의 $selectedYear 월운 흐름"
            else -> return
        }
        
        val detail = "Saved from tab $subtype"

        val record = HistoryRecord(
            id = System.currentTimeMillis().toString(),
            type = HistoryType.MANSE_DAEUN,
            title = summary,
            summary = "저장된 만세력 기록입니다.",
            payload = detail,
            inputSnapshot = "{\"subtype\": \"$subtype\", \"year\": $selectedYear}",
            profileId = profile.id,
            expiresAt = System.currentTimeMillis() + 7 * 24 * 60 * 60 * 1000
        )
        repository.appendHistoryRecord(record)
    }
}
