package com.rsr41.oracle.data.repository

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.*
import com.rsr41.oracle.domain.model.AppLanguage
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.ThemeMode
import com.rsr41.oracle.repository.SettingsRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class SettingsRepositoryImpl @Inject constructor(
    private val dataStore: DataStore<Preferences>
) : SettingsRepository {

    private object PreferencesKeys {
        val THEME_MODE = stringPreferencesKey("theme_mode")
        val APP_LANGUAGE = stringPreferencesKey("app_language")
        val DEFAULT_CALENDAR_TYPE = stringPreferencesKey("default_calendar_type")
        val LUNAR_LEAP_MONTH_ENABLED = booleanPreferencesKey("lunar_leap_month_enabled")
    }

    override val themeMode: Flow<ThemeMode> = dataStore.data
        .map { preferences ->
            val modeName = preferences[PreferencesKeys.THEME_MODE] ?: ThemeMode.SYSTEM.name
            try {
                ThemeMode.valueOf(modeName)
            } catch (e: Exception) {
                ThemeMode.SYSTEM
            }
        }

    override val appLanguage: Flow<AppLanguage> = dataStore.data
        .map { preferences ->
            val langName = preferences[PreferencesKeys.APP_LANGUAGE] ?: AppLanguage.SYSTEM.name
            try {
                AppLanguage.valueOf(langName)
            } catch (e: Exception) {
                AppLanguage.SYSTEM
            }
        }

    override val defaultCalendarType: Flow<CalendarType> = dataStore.data
        .map { preferences ->
            val typeName = preferences[PreferencesKeys.DEFAULT_CALENDAR_TYPE] ?: CalendarType.SOLAR.name
            try {
                CalendarType.valueOf(typeName)
            } catch (e: Exception) {
                CalendarType.SOLAR
            }
        }

    override val isLunarLeapMonthEnabled: Flow<Boolean> = dataStore.data
        .map { preferences ->
            preferences[PreferencesKeys.LUNAR_LEAP_MONTH_ENABLED] ?: false
        }

    override suspend fun setThemeMode(mode: ThemeMode) {
        dataStore.edit { preferences ->
            preferences[PreferencesKeys.THEME_MODE] = mode.name
        }
    }

    override suspend fun setAppLanguage(language: AppLanguage) {
        dataStore.edit { preferences ->
            preferences[PreferencesKeys.APP_LANGUAGE] = language.name
        }
    }

    override suspend fun setDefaultCalendarType(type: CalendarType) {
        dataStore.edit { preferences ->
            preferences[PreferencesKeys.DEFAULT_CALENDAR_TYPE] = type.name
        }
    }

    override suspend fun setLunarLeapMonthEnabled(enabled: Boolean) {
        dataStore.edit { preferences ->
            preferences[PreferencesKeys.LUNAR_LEAP_MONTH_ENABLED] = enabled
        }
    }
}
