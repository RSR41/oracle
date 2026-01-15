package com.rsr41.oracle.repository

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.rsr41.oracle.domain.model.AppLanguage
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.ThemeMode
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class SettingsRepositoryImpl @Inject constructor(
    private val dataStore: DataStore<Preferences>
) : SettingsRepository {

    private object Keys {
        val THEME_MODE = stringPreferencesKey("theme_mode")
        val APP_LANGUAGE = stringPreferencesKey("app_language")
        val CALENDAR_TYPE = stringPreferencesKey("calendar_type")
        val LUNAR_LEAP_MONTH_ENABLED = booleanPreferencesKey("lunar_leap_month_enabled")
    }

    override val themeMode: Flow<ThemeMode> = dataStore.data.map { prefs ->
        try {
            ThemeMode.valueOf(prefs[Keys.THEME_MODE] ?: ThemeMode.SYSTEM.name)
        } catch (e: Exception) {
            ThemeMode.SYSTEM
        }
    }

    override val appLanguage: Flow<AppLanguage> = dataStore.data.map { prefs ->
        try {
            AppLanguage.valueOf(prefs[Keys.APP_LANGUAGE] ?: AppLanguage.SYSTEM.name)
        } catch (e: Exception) {
            AppLanguage.SYSTEM
        }
    }

    override val defaultCalendarType: Flow<CalendarType> = dataStore.data.map { prefs ->
        try {
            CalendarType.valueOf(prefs[Keys.CALENDAR_TYPE] ?: CalendarType.SOLAR.name)
        } catch (e: Exception) {
            CalendarType.SOLAR
        }
    }
    
    override val isLunarLeapMonthEnabled: Flow<Boolean> = dataStore.data.map { prefs ->
        prefs[Keys.LUNAR_LEAP_MONTH_ENABLED] ?: false
    }

    override suspend fun setThemeMode(mode: ThemeMode) {
        dataStore.edit { prefs ->
            prefs[Keys.THEME_MODE] = mode.name
        }
    }

    override suspend fun setAppLanguage(language: AppLanguage) {
        dataStore.edit { prefs ->
            prefs[Keys.APP_LANGUAGE] = language.name
        }
    }

    override suspend fun setDefaultCalendarType(type: CalendarType) {
        dataStore.edit { prefs ->
            prefs[Keys.CALENDAR_TYPE] = type.name
        }
    }

    override suspend fun setLunarLeapMonthEnabled(enabled: Boolean) {
        dataStore.edit { prefs ->
            prefs[Keys.LUNAR_LEAP_MONTH_ENABLED] = enabled
        }
    }
}
