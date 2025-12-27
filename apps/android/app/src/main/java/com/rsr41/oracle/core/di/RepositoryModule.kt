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
}
