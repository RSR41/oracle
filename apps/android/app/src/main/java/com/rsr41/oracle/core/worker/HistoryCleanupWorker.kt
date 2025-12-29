package com.rsr41.oracle.core.worker

import android.content.Context
import androidx.hilt.work.HiltWorker
import androidx.work.*
import com.rsr41.oracle.data.repository.HistoryRepository
import dagger.assisted.Assisted
import dagger.assisted.AssistedInject
import timber.log.Timber
import java.util.concurrent.TimeUnit

/**
 * 히스토리 자동 정리 Worker
 * 비프리미엄 사용자의 오래된 기록을 주기적으로 삭제
 */
@HiltWorker
class HistoryCleanupWorker @AssistedInject constructor(
    @Assisted context: Context,
    @Assisted params: WorkerParameters,
    private val historyRepository: HistoryRepository
) : CoroutineWorker(context, params) {
    
    override suspend fun doWork(): Result {
        return try {
            val retentionDays = inputData.getInt(KEY_RETENTION_DAYS, DEFAULT_RETENTION_DAYS)
            val deletedCount = historyRepository.cleanupOldHistory(retentionDays)
            
            Timber.d("HistoryCleanupWorker: Deleted $deletedCount old history records")
            
            Result.success(
                workDataOf(KEY_DELETED_COUNT to deletedCount)
            )
        } catch (e: Exception) {
            Timber.e(e, "HistoryCleanupWorker failed")
            Result.retry()
        }
    }
    
    companion object {
        const val WORK_NAME = "history_cleanup_work"
        const val KEY_RETENTION_DAYS = "retention_days"
        const val KEY_DELETED_COUNT = "deleted_count"
        const val DEFAULT_RETENTION_DAYS = 14
        
        /**
         * 주기적 정리 작업 스케줄링
         */
        fun schedule(context: Context, retentionDays: Int = DEFAULT_RETENTION_DAYS) {
            val inputData = workDataOf(KEY_RETENTION_DAYS to retentionDays)
            
            val constraints = Constraints.Builder()
                .setRequiresBatteryNotLow(true)
                .build()
            
            val request = PeriodicWorkRequestBuilder<HistoryCleanupWorker>(
                repeatInterval = 1,
                repeatIntervalTimeUnit = TimeUnit.DAYS
            )
                .setInputData(inputData)
                .setConstraints(constraints)
                .setBackoffCriteria(
                    BackoffPolicy.EXPONENTIAL,
                    WorkRequest.MIN_BACKOFF_MILLIS,
                    TimeUnit.MILLISECONDS
                )
                .build()
            
            WorkManager.getInstance(context)
                .enqueueUniquePeriodicWork(
                    WORK_NAME,
                    ExistingPeriodicWorkPolicy.KEEP,
                    request
                )
            
            Timber.d("HistoryCleanupWorker scheduled with $retentionDays days retention")
        }
        
        /**
         * 즉시 실행 (디버그/테스트용)
         */
        fun runNow(context: Context, retentionDays: Int = DEFAULT_RETENTION_DAYS) {
            val inputData = workDataOf(KEY_RETENTION_DAYS to retentionDays)
            
            val request = OneTimeWorkRequestBuilder<HistoryCleanupWorker>()
                .setInputData(inputData)
                .build()
            
            WorkManager.getInstance(context).enqueue(request)
        }
    }
}
