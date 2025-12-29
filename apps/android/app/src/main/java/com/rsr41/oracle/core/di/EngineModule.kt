package com.rsr41.oracle.core.di

import android.content.Context
import com.rsr41.oracle.data.engine.BasicFortuneEngine
import com.rsr41.oracle.domain.engine.FortuneEngine
import com.rsr41.oracle.domain.engine.TarotEngine
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/**
 * 엔진 Hilt 모듈
 * 플러그인 구조로 구현체 교체 가능
 */
@Module
@InstallIn(SingletonComponent::class)
object EngineModule {
    
    @Provides
    @Singleton
    fun provideFortuneEngine(
        @ApplicationContext context: Context
    ): FortuneEngine {
        // MVP: 기본 엔진 사용
        // 향후: 설정에 따라 AdvancedFortuneEngine 교체 가능
        return BasicFortuneEngine()
    }
    
    @Provides
    @Singleton
    fun provideTarotEngine(): TarotEngine {
        return TarotEngine()
    }
    
    // TODO: FaceAnalysisEngine 추가 (ML Kit 기반)
    // @Provides
    // @Singleton
    // fun provideFaceAnalysisEngine(
    //     @ApplicationContext context: Context
    // ): FaceAnalysisEngine {
    //     return MLKitFaceEngine(context)
    // }
}
