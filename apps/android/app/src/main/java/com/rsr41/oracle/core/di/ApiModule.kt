package com.rsr41.oracle.core.di

import com.rsr41.oracle.data.api.OracleApiService
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import retrofit2.Retrofit
import javax.inject.Singleton

/**
 * Hilt DI Module for API Service
 */
@Module
@InstallIn(SingletonComponent::class)
object ApiModule {

    @Provides
    @Singleton
    fun provideOracleApiService(retrofit: Retrofit): OracleApiService {
        return retrofit.create(OracleApiService::class.java)
    }
}
