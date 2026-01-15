package com.rsr41.oracle.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rsr41.oracle.domain.model.AppLanguage
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.ThemeMode
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val settingsRepository: com.rsr41.oracle.repository.SettingsRepository,
    private val sajuRepository: SajuRepository // Keep for face consent if needed, or migrate later
) : ViewModel() {
    
    companion object {
        private const val TAG = "SettingsViewModel"
    }

    val themeMode = settingsRepository.themeMode.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = ThemeMode.SYSTEM
    )

    val appLanguage = settingsRepository.appLanguage.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = AppLanguage.SYSTEM
    )

    val calendarType = settingsRepository.defaultCalendarType.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = CalendarType.SOLAR
    )
    
    val isLunarLeapMonthEnabled = settingsRepository.isLunarLeapMonthEnabled.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = false
    )

    // Face Consent is still in legacy prefs for now
    var faceConsent by mutableStateOf(false)
        private set

    init {
        // Load legacy prefs
        faceConsent = sajuRepository.getFaceConsent()
    }

    fun updateCalendarType(newType: CalendarType) {
        viewModelScope.launch {
            settingsRepository.setDefaultCalendarType(newType)
            Log.d(TAG, "Saved calendarType: $newType")
        }
    }
    
    fun updateLunarLeapMonthEnabled(enabled: Boolean) {
        viewModelScope.launch {
            settingsRepository.setLunarLeapMonthEnabled(enabled)
        }
    }

    fun updateAppLanguage(language: AppLanguage) {
        viewModelScope.launch {
            settingsRepository.setAppLanguage(language)
            Log.d(TAG, "Saved appLanguage: $language")
        }
    }

    fun updateThemeMode(theme: ThemeMode) {
        viewModelScope.launch {
            settingsRepository.setThemeMode(theme)
            Log.d(TAG, "Saved themeMode: $theme")
        }
    }

    fun updateFaceConsent(consented: Boolean) {
        faceConsent = consented
        sajuRepository.setFaceConsent(consented)
    }
}
