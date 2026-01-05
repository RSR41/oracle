package com.rsr41.oracle.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.domain.model.CalendarType
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

    var calendarType by mutableStateOf(CalendarType.SOLAR)
        private set



    fun updateCalendarType(newType: CalendarType) {
        calendarType = newType
        repository.saveDefaultCalendarType(newType)
        Log.d(TAG, "Saved calendarType: $newType")
    }

    // Face Consent
    var faceConsent by mutableStateOf(false)
        private set

    fun updateFaceConsent(consented: Boolean) {
        faceConsent = consented
        repository.setFaceConsent(consented)
    }
    
    // Override loadSettings to include face consent
    fun loadSettings() {
        calendarType = repository.loadDefaultCalendarType()
        faceConsent = repository.getFaceConsent()
        Log.d(TAG, "Loaded settings: calendarType=$calendarType, faceConsent=$faceConsent")
    }

    init {
        loadSettings()
    }
}
