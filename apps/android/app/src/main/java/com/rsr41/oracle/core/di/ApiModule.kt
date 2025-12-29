package com.rsr41.oracle.core.di

import com.rsr41.oracle.BuildConfig
import com.rsr41.oracle.data.api.MockOracleApiService
import com.rsr41.oracle.data.api.OracleApiService
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import retrofit2.Retrofit
import javax.inject.Singleton

/**
 * Hilt DI Module for API Service
 * - USE_MOCK_API = true: MockOracleApiService (로컬 개발용)
 * - USE_MOCK_API = false: Retrofit 기반 실제 API
 */
@Module
@InstallIn(SingletonComponent::class)
object ApiModule {

    @Provides
    @Singleton
    fun provideOracleApiService(retrofit: Retrofit): OracleApiService {
        // USE_MOCK_API가 true이면 Mock 사용, 아니면 실제 Retrofit 사용
        return if (BuildConfig.USE_MOCK_API) {
            MockOracleApiService()
        } else {
            retrofit.create(OracleApiService::class.java)
        }
    }
}
