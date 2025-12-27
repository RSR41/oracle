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

    init {
        loadSettings()
    }

    fun loadSettings() {
        calendarType = repository.loadDefaultCalendarType()
        Log.d(TAG, "Loaded settings: calendarType=$calendarType")
    }

    fun updateCalendarType(newType: CalendarType) {
        calendarType = newType
        repository.saveDefaultCalendarType(newType)
        Log.d(TAG, "Saved calendarType: $newType")
    }
}
