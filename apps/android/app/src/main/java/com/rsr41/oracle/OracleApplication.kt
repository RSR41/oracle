package com.rsr41.oracle

import android.app.Application
import androidx.hilt.work.HiltWorkerFactory
import androidx.work.Configuration
import com.rsr41.oracle.core.worker.HistoryCleanupWorker
import dagger.hilt.android.HiltAndroidApp
import timber.log.Timber
import javax.inject.Inject

/**
 * Application 클래스
 * - Hilt DI 초기화
 * - Timber 로깅 초기화
 * - WorkManager 초기화
 */
@HiltAndroidApp
class OracleApplication : Application(), Configuration.Provider {
    
    @Inject
    lateinit var workerFactory: HiltWorkerFactory
    
    override fun onCreate() {
        super.onCreate()
        
        // Debug 빌드에서만 Timber 로깅 활성화
        if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
        }
        
        // 히스토리 자동 정리 스케줄링 (비프리미엄: 14일)
        HistoryCleanupWorker.schedule(this, retentionDays = 14)
        
        Timber.d("OracleApplication initialized")
    }
    
    override val workManagerConfiguration: Configuration
        get() = Configuration.Builder()
            .setWorkerFactory(workerFactory)
            .setMinimumLoggingLevel(if (BuildConfig.DEBUG) android.util.Log.DEBUG else android.util.Log.ERROR)
            .build()
}
