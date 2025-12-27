package com.rsr41.oracle

import android.app.Application
import dagger.hilt.android.HiltAndroidApp
import timber.log.Timber

/**
 * Application 클래스
 * - Hilt DI 초기화
 * - Timber 로깅 초기화
 */
@HiltAndroidApp
class OracleApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Debug 빌드에서만 Timber 로깅 활성화
        if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
        }
        
        Timber.d("OracleApplication initialized")
    }
}
