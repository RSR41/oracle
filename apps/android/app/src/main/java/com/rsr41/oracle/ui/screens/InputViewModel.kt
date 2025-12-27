package com.rsr41.oracle.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.core.util.ValidationUtil
import com.rsr41.oracle.domain.model.*
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import java.util.UUID
import javax.inject.Inject

/**
 * InputScreen의 ViewModel
 * 입력 상태 관리, 유효성 검증, 결과 생성 로직 담당
 */
@HiltViewModel
class InputViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {
    
    companion object {
        private const val TAG = "InputViewModel"
    }

    // 입력 상태
    var nickname by mutableStateOf("")
        private set
    var date by mutableStateOf("1990-01-01")
        private set
    var time by mutableStateOf("")
        private set
    var gender by mutableStateOf(Gender.MALE)
        private set
    var calendarType by mutableStateOf(CalendarType.SOLAR)
        private set
    var timeUnknown by mutableStateOf(false)
        private set
    var isSaveProfileChecked by mutableStateOf(true)
        private set

    // 에러 상태
    var nicknameError by mutableStateOf<String?>(null)
        private set
    var dateError by mutableStateOf<String?>(null)
        private set
    var timeError by mutableStateOf<String?>(null)
        private set

    // 네비게이션 이벤트
    var shouldNavigateToResult by mutableStateOf(false)
        private set

    init {
        // 설정에서 기본 달력 타입 로드
        calendarType = repository.loadDefaultCalendarType()
        Log.d(TAG, "Initialized with calendarType: $calendarType")
    }

    fun updateNickname(newNickname: String) {
        nickname = newNickname
        nicknameError = null
    }

    fun updateDate(newDate: String) {
        date = newDate
        dateError = null
    }

    fun updateTime(newTime: String) {
        time = newTime
        timeError = null
    }

    fun updateGender(newGender: Gender) {
        gender = newGender
    }

    fun updateCalendarType(newType: CalendarType) {
        calendarType = newType
    }

    fun toggleTimeUnknown(unknown: Boolean) {
        timeUnknown = unknown
        if (unknown) time = ""
    }

    fun toggleSaveProfile(checked: Boolean) {
        isSaveProfileChecked = checked
    }

    fun validateAndGenerateResult(): Boolean {
        if (nickname.isBlank() && isSaveProfileChecked) {
            nicknameError = "닉네임을 입력해주세요"
            return false
        }

        val (dateValid, dateMsg) = ValidationUtil.validateDate(date)
        if (!dateValid) {
            dateError = dateMsg
            return false
        }

        if (!timeUnknown) {
            val (timeValid, timeMsg) = ValidationUtil.validateTime(time)
            if (!timeValid) {
                timeError = timeMsg
                return false
            }
        }

        val birthInfo = BirthInfo(
            date = date,
            time = if (timeUnknown) "" else time,
            gender = gender,
            calendarType = calendarType
        )

        // 1. 결과 생성
        val result = repository.getMockSaju(birthInfo)
        
        // 2. 프로필 저장 (체크 시)
        var savedProfileId: String? = null
        if (isSaveProfileChecked) {
            val profile = Profile(
                id = UUID.randomUUID().toString(),
                nickname = nickname,
                birthDate = date,
                birthTime = if (timeUnknown) null else time,
                timeUnknown = timeUnknown,
                calendarType = calendarType,
                gender = gender
            )
            repository.saveProfile(profile)
            savedProfileId = profile.id
        }

        // 3. 히스토리 저장 (Enhanced)
        val payload = """
            {
                "date": "$date",
                "time": "$time",
                "gender": "${gender.name}",
                "calendarType": "${calendarType.name}",
                "summary": "${result.summaryToday}",
                "pillars": "${result.pillars}"
            }
        """.trimIndent()

        val record = HistoryRecord(
            id = System.currentTimeMillis().toString(),
            type = HistoryType.SAJU_FORTUNE,
            title = if (nickname.isNotBlank()) "$nickname 님의 사주" else "나의 사주 운세",
            summary = result.summaryToday.take(40) + "...",
            payload = payload,
            profileId = savedProfileId
        )
        repository.appendHistoryRecord(record)

        // 4. 레거시 호환 저장
        val legacyItem = HistoryItem(record.id, birthInfo, result)
        repository.saveLastResult(legacyItem)
        repository.appendHistory(legacyItem)

        shouldNavigateToResult = true
        return true
    }

    fun onNavigatedToResult() {
        shouldNavigateToResult = false
    }

    fun resetToDefaults() {
        calendarType = repository.loadDefaultCalendarType()
        nickname = ""
        date = "1990-01-01"
        time = ""
        timeUnknown = false
        nicknameError = null
        dateError = null
        timeError = null
    }
}
