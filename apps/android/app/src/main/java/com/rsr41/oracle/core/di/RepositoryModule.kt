package com.rsr41.oracle.core.di

import android.content.Context
import com.rsr41.oracle.data.local.PreferencesManager
import com.rsr41.oracle.domain.usecase.BuildMockSajuUseCase
import com.rsr41.oracle.repository.SajuRepository
import com.rsr41.oracle.repository.SajuRepositoryImpl
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton
import com.rsr41.oracle.repository.SettingsRepository
import com.rsr41.oracle.data.repository.SettingsRepositoryImpl

/**
 * Hilt DI Module for Repository dependencies
 */
@Module
@InstallIn(SingletonComponent::class)
object RepositoryModule {

    @Provides
    @Singleton
    fun providePreferencesManager(@ApplicationContext context: Context): PreferencesManager {
        return PreferencesManager(context)
    }

    @Provides
    @Singleton
    fun provideBuildMockSajuUseCase(): BuildMockSajuUseCase {
        return BuildMockSajuUseCase()
    }

    @Provides
    @Singleton
    fun provideSajuRepository(
        preferencesManager: PreferencesManager,
        buildMockSajuUseCase: BuildMockSajuUseCase
    ): SajuRepository {
        return SajuRepositoryImpl(preferencesManager, buildMockSajuUseCase)
    }

    @Provides
    @Singleton
    fun provideSettingsRepository(
        dataStore: androidx.datastore.core.DataStore<androidx.datastore.preferences.core.Preferences>
    ): SettingsRepository {
        return SettingsRepositoryImpl(dataStore)
    }

    @Provides
    @Singleton
    fun provideHistoryRepository(
        historyDao: com.rsr41.oracle.data.local.HistoryDao
    ): com.rsr41.oracle.data.repository.HistoryRepository {
        return com.rsr41.oracle.data.repository.HistoryRepositoryImpl(historyDao)
    }
}
