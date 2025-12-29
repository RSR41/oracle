package com.rsr41.oracle.data.repository

import com.rsr41.oracle.data.local.HistoryDao
import com.rsr41.oracle.data.local.HistoryEntity
import com.rsr41.oracle.domain.model.HistoryType
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

/**
 * 히스토리 Repository
 * DAO와 도메인 레이어 사이 중개
 */
interface HistoryRepository {
    fun getAllHistoryFlow(): Flow<List<HistoryEntity>>
    fun getHistoryByTypeFlow(type: HistoryType): Flow<List<HistoryEntity>>
    suspend fun saveHistory(type: HistoryType, title: String, summary: String, detailJson: String, isPremium: Boolean = false): Long
    suspend fun getHistoryById(id: Long): HistoryEntity?
    suspend fun deleteHistory(id: Long)
    suspend fun deleteAll()
    suspend fun cleanupOldHistory(retentionDays: Int = 14): Int
}

/**
 * 히스토리 Repository 구현체
 */
@Singleton
class HistoryRepositoryImpl @Inject constructor(
    private val historyDao: HistoryDao
) : HistoryRepository {
    
    override fun getAllHistoryFlow(): Flow<List<HistoryEntity>> = historyDao.getAllHistoryFlow()
    
    override fun getHistoryByTypeFlow(type: HistoryType): Flow<List<HistoryEntity>> =
        historyDao.getHistoryByTypeFlow(type.name)
    
    override suspend fun saveHistory(
        type: HistoryType,
        title: String,
        summary: String,
        detailJson: String,
        isPremium: Boolean
    ): Long {
        val entity = HistoryEntity(
            type = type,
            title = title,
            summary = summary,
            detailJson = detailJson,
            isPremium = isPremium
        )
        return historyDao.insertHistory(entity)
    }
    
    override suspend fun getHistoryById(id: Long): HistoryEntity? = historyDao.getHistoryById(id)
    
    override suspend fun deleteHistory(id: Long) = historyDao.deleteHistoryById(id)
    
    override suspend fun deleteAll() = historyDao.deleteAll()
    
    override suspend fun cleanupOldHistory(retentionDays: Int): Int {
        val thresholdMillis = System.currentTimeMillis() - (retentionDays * 24 * 60 * 60 * 1000L)
        return historyDao.deleteOldNonPremiumHistory(thresholdMillis)
    }
}
