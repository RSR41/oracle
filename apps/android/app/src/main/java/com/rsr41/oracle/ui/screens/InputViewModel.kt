package com.rsr41.oracle.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.core.util.ValidationUtil
import com.rsr41.oracle.domain.model.BirthInfo
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.Gender
import com.rsr41.oracle.domain.model.HistoryItem
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
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
    var date by mutableStateOf("1990-01-01")
        private set
    var time by mutableStateOf("")
        private set
    var gender by mutableStateOf(Gender.MALE)
        private set
    var calendarType by mutableStateOf(CalendarType.SOLAR)
        private set

    // 에러 상태
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

    fun validateAndGenerateResult(): Boolean {
        val (dateValid, dateMsg) = ValidationUtil.validateDate(date)
        if (!dateValid) {
            dateError = dateMsg
            return false
        }

        val (timeValid, timeMsg) = ValidationUtil.validateTime(time)
        if (!timeValid) {
            timeError = timeMsg
            return false
        }

        val birthInfo = BirthInfo(
            date = date,
            time = time,
            gender = gender,
            calendarType = calendarType
        )

        val result = repository.getMockSaju(birthInfo)
        val historyItem = HistoryItem(
            id = System.currentTimeMillis().toString(),
            birthInfo = birthInfo,
            result = result
        )

        repository.saveLastResult(historyItem)
        repository.appendHistory(historyItem)

        shouldNavigateToResult = true
        return true
    }

    fun onNavigatedToResult() {
        shouldNavigateToResult = false
    }

    fun resetToDefaults() {
        calendarType = repository.loadDefaultCalendarType()
    }
}
