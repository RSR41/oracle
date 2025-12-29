package com.rsr41.oracle.data.local

import androidx.room.*
import kotlinx.coroutines.flow.Flow

/**
 * 히스토리 DAO
 * CRUD 및 자동 정리 기능 지원
 */
@Dao
interface HistoryDao {
    
    @Query("SELECT * FROM history ORDER BY createdAt DESC")
    fun getAllHistoryFlow(): Flow<List<HistoryEntity>>
    
    @Query("SELECT * FROM history WHERE type = :type ORDER BY createdAt DESC")
    fun getHistoryByTypeFlow(type: String): Flow<List<HistoryEntity>>
    
    @Query("SELECT * FROM history ORDER BY createdAt DESC")
    suspend fun getAllHistory(): List<HistoryEntity>
    
    @Query("SELECT * FROM history WHERE id = :id")
    suspend fun getHistoryById(id: Long): HistoryEntity?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertHistory(entity: HistoryEntity): Long
    
    @Update
    suspend fun updateHistory(entity: HistoryEntity)
    
    @Delete
    suspend fun deleteHistory(entity: HistoryEntity)
    
    @Query("DELETE FROM history WHERE id = :id")
    suspend fun deleteHistoryById(id: Long)
    
    @Query("DELETE FROM history")
    suspend fun deleteAll()
    
    /**
     * 자동 정리: N일 이상 지난 비프리미엄 기록 삭제
     * @param thresholdMillis 삭제 기준 시간 (milliseconds)
     */
    @Query("DELETE FROM history WHERE isPremium = 0 AND createdAt < :thresholdMillis")
    suspend fun deleteOldNonPremiumHistory(thresholdMillis: Long): Int
    
    /**
     * 비프리미엄 기록 수
     */
    @Query("SELECT COUNT(*) FROM history WHERE isPremium = 0")
    suspend fun getNonPremiumCount(): Int
}
