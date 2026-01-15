package com.rsr41.oracle.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rsr41.oracle.core.util.ValidationUtil
import com.rsr41.oracle.domain.model.*
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import java.util.UUID
import javax.inject.Inject

/**
 * InputScreen의 ViewModel
 * 입력 상태 관리, 유효성 검증, 결과 생성 로직 담당
 */
@HiltViewModel
class InputViewModel @Inject constructor(
    private val sajuRepository: SajuRepository,
    private val settingsRepository: com.rsr41.oracle.repository.SettingsRepository
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
        
    var isLeapMonth by mutableStateOf(false)
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
        // 설정에서 기본 달력 타입 로드 (Reactive)
        viewModelScope.launch {
            settingsRepository.defaultCalendarType.collect {
                calendarType = it
            }
        }
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
    
    fun updateTimeUnknown(checked: Boolean) {
        timeUnknown = checked
        if (checked) {
            time = ""
            timeError = null
        }
    }
    
    fun updateSaveProfile(checked: Boolean) {
        isSaveProfileChecked = checked
    }
    
    fun updateIsLeapMonth(checked: Boolean) {
        isLeapMonth = checked
    }

    fun validateAndGenerateResult(): Boolean {
        if (nickname.isBlank() && isSaveProfileChecked) {
            nicknameError = "Please enter a nickname"
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
        
        // 날짜 변환 로직 (음력 -> 양력)
        // User Requirement: "Lunar 기준 입력 -> Solar 변환(또는 내부 표준화)까지 정상 동작"
        var analysisDate = date
        var analysisCalendarType = calendarType
        
        if (calendarType == CalendarType.LUNAR) {
            try {
                // 입력된 date "yyyy-MM-dd" 파싱
                val parts = date.split("-")
                if (parts.size == 3) {
                    val y = parts[0].toInt()
                    val m = parts[1].toInt()
                    val d = parts[2].toInt()
                    
                    // 변환: Lunar -> Solar
                    val solarDate = com.rsr41.oracle.util.LunarCalendarUtil.lunarToSolar(y, m, d, isLeapMonth)
                    
                    // 엔진 및 저장용 데이터 표준화 (Solar로 변환)
                    analysisDate = solarDate.toString()
                    analysisCalendarType = CalendarType.SOLAR // 엔진에는 양력으로 전달
                    
                    Log.d(TAG, "Converted Lunar $date (Leap: $isLeapMonth) -> Solar $analysisDate")
                }
            } catch (e: Exception) {
                Log.e(TAG, "Lunar conversion failed", e)
                // 변환 실패 시 원본 사용 (Fallback)
                // TODO: 에러 처리 강화 (사용자 알림 등)
            }
        }

        // 엔진 분석용 Info (Solar로 변환된 값 사용)
        val birthInfo = BirthInfo(
            date = analysisDate,
            time = if (timeUnknown) "" else time,
            gender = gender,
            calendarType = analysisCalendarType
        )

        // 1. 결과 생성
        val result = sajuRepository.getMockSaju(birthInfo)
        
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
            sajuRepository.saveProfile(profile)
            savedProfileId = profile.id
        }

        // 3. 히스토리 저장
        val inputJson = """
            {
                "date": "$date",
                "time": "$time",
                "gender": "${gender.name}",
                "calendarType": "${calendarType.name}",
                "isLeapMonth": $isLeapMonth,
                "timeUnknown": $timeUnknown
            }
        """.trimIndent()

        val detailJson = """
            {
                "summary": "${result.summaryToday}",
                "pillars": "${result.pillars}",
                "scores": { "love": 85, "money": 90, "health": 70, "work": 95 },
                "advice": ["주변을 돌아보세요.", "무리한 투자는 삼가세요.", "건강 검진을 받아보세요."]
            }
        """.trimIndent()

        val record = HistoryRecord(
            id = System.currentTimeMillis().toString(),
            type = HistoryType.SAJU_FORTUNE,
            title = if (nickname.isNotBlank()) "$nickname 님의 사주" else "나의 사주 운세",
            summary = result.summaryToday.take(40) + "...",
            payload = detailJson,
            inputSnapshot = inputJson,
            profileId = savedProfileId,
            expiresAt = System.currentTimeMillis() + 7 * 24 * 60 * 60 * 1000
        )
        sajuRepository.appendHistoryRecord(record)

        // 4. 레거시 호환
        val legacyItem = HistoryItem(record.id, birthInfo, result)
        sajuRepository.saveLastResult(legacyItem)
        sajuRepository.appendHistory(legacyItem)

        shouldNavigateToResult = true
        return true
    }

    fun onNavigatedToResult() {
        shouldNavigateToResult = false
    }

    fun resetToDefaults() {
        // 리셋 시에도 설정값 다시 불러오기
        viewModelScope.launch {
            settingsRepository.defaultCalendarType.collect {
                calendarType = it
            }
        }
        nickname = ""
        date = "1990-01-01"
        time = ""
        timeUnknown = false
        nicknameError = null
        dateError = null
        timeError = null
    }
}
