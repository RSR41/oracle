package com.rsr41.oracle.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.domain.model.AppLanguage
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.ThemeMode
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {
    
    companion object {
        private const val TAG = "SettingsViewModel"
    }

    // 달력 타입
    var calendarType by mutableStateOf(CalendarType.SOLAR)
        private set

    // 앱 언어
    var appLanguage by mutableStateOf(AppLanguage.SYSTEM)
        private set

    // 테마 모드
    var themeMode by mutableStateOf(ThemeMode.SYSTEM)
        private set

    // Face Consent
    var faceConsent by mutableStateOf(false)
        private set

    fun updateCalendarType(newType: CalendarType) {
        calendarType = newType
        repository.saveDefaultCalendarType(newType)
        Log.d(TAG, "Saved calendarType: $newType")
    }

    fun updateAppLanguage(language: AppLanguage) {
        appLanguage = language
        repository.saveAppLanguage(language)
        Log.d(TAG, "Saved appLanguage: $language")
    }

    fun updateThemeMode(theme: ThemeMode) {
        themeMode = theme
        repository.saveThemeMode(theme)
        Log.d(TAG, "Saved themeMode: $theme")
    }

    fun updateFaceConsent(consented: Boolean) {
        faceConsent = consented
        repository.setFaceConsent(consented)
    }
    
    fun loadSettings() {
        calendarType = repository.loadDefaultCalendarType()
        appLanguage = repository.loadAppLanguage()
        themeMode = repository.loadThemeMode()
        faceConsent = repository.getFaceConsent()
        Log.d(TAG, "Loaded settings: calendarType=$calendarType, appLanguage=$appLanguage, themeMode=$themeMode, faceConsent=$faceConsent")
    }

    init {
        loadSettings()
    }
}
