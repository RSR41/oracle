package com.rsr41.oracle.repository

import com.rsr41.oracle.domain.model.AppLanguage
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.ThemeMode
import kotlinx.coroutines.flow.Flow

interface SettingsRepository {
    val themeMode: Flow<ThemeMode>
    val appLanguage: Flow<AppLanguage>
    val defaultCalendarType: Flow<CalendarType>
    val isLunarLeapMonthEnabled: Flow<Boolean>

    suspend fun setThemeMode(mode: ThemeMode)
    suspend fun setAppLanguage(language: AppLanguage)
    suspend fun setDefaultCalendarType(type: CalendarType)
    suspend fun setLunarLeapMonthEnabled(enabled: Boolean)
}
