package com.rsr41.oracle.data.local.dao

import androidx.room.*
import com.rsr41.oracle.data.local.entity.SajuContentEntity
import kotlinx.coroutines.flow.Flow

/**
 * 사주 콘텐츠 DAO
 */
@Dao
interface SajuContentDao {
    
    @Query("SELECT * FROM saju_content ORDER BY type, code ASC")
    fun getAllContent(): Flow<List<SajuContentEntity>>
    
    @Query("SELECT * FROM saju_content WHERE id = :id")
    suspend fun getContentById(id: String): SajuContentEntity?
    
    @Query("SELECT * FROM saju_content WHERE type = :type ORDER BY code ASC")
    fun getContentByType(type: String): Flow<List<SajuContentEntity>>
    
    @Query("SELECT * FROM saju_content WHERE code = :code")
    suspend fun getContentByCode(code: String): SajuContentEntity?
    
    @Query("SELECT * FROM saju_content WHERE type = '오행'")
    fun getFiveElements(): Flow<List<SajuContentEntity>>
    
    @Query("SELECT * FROM saju_content WHERE type = '천간'")
    fun getHeavenlyStems(): Flow<List<SajuContentEntity>>
    
    @Query("SELECT * FROM saju_content WHERE type = '지지'")
    fun getEarthlyBranches(): Flow<List<SajuContentEntity>>
    
    @Query("SELECT * FROM saju_content WHERE type = '십신'")
    fun getTenGods(): Flow<List<SajuContentEntity>>
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(content: List<SajuContentEntity>)
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(content: SajuContentEntity)
    
    @Query("DELETE FROM saju_content")
    suspend fun deleteAll()
    
    @Query("SELECT COUNT(*) FROM saju_content")
    suspend fun getCount(): Int
}
