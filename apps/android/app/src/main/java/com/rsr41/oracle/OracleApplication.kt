package com.rsr41.oracle

import android.app.Application
import androidx.hilt.work.HiltWorkerFactory
import androidx.work.Configuration
import com.rsr41.oracle.core.worker.HistoryCleanupWorker
import com.rsr41.oracle.data.local.DatabaseSeeder
import com.rsr41.oracle.data.local.OracleDatabase
import dagger.hilt.android.HiltAndroidApp
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import timber.log.Timber
import javax.inject.Inject

/**
 * Application 클래스
 * - Hilt DI 초기화
 * - Timber 로깅 초기화
 * - WorkManager 초기화
 * - Database Seeding
 */
@HiltAndroidApp
class OracleApplication : Application(), Configuration.Provider {
    
    @Inject
    lateinit var workerFactory: HiltWorkerFactory
    
    private val applicationScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    
    override fun onCreate() {
        super.onCreate()
        
        // Debug 빌드에서만 Timber 로깅 활성화
        if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
        }
        
        // 히스토리 자동 정리 스케줄링 (비프리미엄: 14일)
        HistoryCleanupWorker.schedule(this, retentionDays = 14)
        
        // Database Seeding (첫 실행 시 seed 데이터 import)
        applicationScope.launch(Dispatchers.IO) {
            try {
                val database = OracleDatabase.getInstance(this@OracleApplication)
                val seeder = DatabaseSeeder(this@OracleApplication, database)
                seeder.seedIfNeeded()
            } catch (e: Exception) {
                Timber.e(e, "Error seeding database")
            }
        }
        
        Timber.d("OracleApplication initialized")
    }
    
    override val workManagerConfiguration: Configuration
        get() = Configuration.Builder()
            .setWorkerFactory(workerFactory)
            .setMinimumLoggingLevel(if (BuildConfig.DEBUG) android.util.Log.DEBUG else android.util.Log.ERROR)
            .build()
}
