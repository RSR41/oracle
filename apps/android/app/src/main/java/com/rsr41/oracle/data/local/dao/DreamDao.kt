package com.rsr41.oracle.data.local.dao

import androidx.room.*
import com.rsr41.oracle.data.local.entity.DreamInterpretationEntity
import kotlinx.coroutines.flow.Flow

/**
 * 꿈해몽 DAO
 */
@Dao
interface DreamDao {
    
    @Query("SELECT * FROM dream_interpretations ORDER BY keywordKo ASC")
    fun getAllDreams(): Flow<List<DreamInterpretationEntity>>
    
    @Query("SELECT * FROM dream_interpretations WHERE id = :id")
    suspend fun getDreamById(id: String): DreamInterpretationEntity?
    
    @Query("SELECT * FROM dream_interpretations WHERE category = :category ORDER BY keywordKo ASC")
    fun getDreamsByCategory(category: String): Flow<List<DreamInterpretationEntity>>
    
    @Query("""
        SELECT * FROM dream_interpretations 
        WHERE keywordKo LIKE '%' || :query || '%' 
           OR synonymsKo LIKE '%' || :query || '%'
           OR keywordEn LIKE '%' || :query || '%'
           OR synonymsEn LIKE '%' || :query || '%'
        ORDER BY keywordKo ASC
    """)
    fun searchDreams(query: String): Flow<List<DreamInterpretationEntity>>
    
    @Query("SELECT * FROM dream_interpretations WHERE isGoodDream = 1 ORDER BY keywordKo ASC")
    fun getGoodDreams(): Flow<List<DreamInterpretationEntity>>
    
    @Query("SELECT * FROM dream_interpretations WHERE isGoodDream = 0 ORDER BY keywordKo ASC")
    fun getBadDreams(): Flow<List<DreamInterpretationEntity>>
    
    @Query("SELECT DISTINCT category FROM dream_interpretations ORDER BY category ASC")
    fun getAllCategories(): Flow<List<String>>
    
    @Query("SELECT * FROM dream_interpretations ORDER BY RANDOM() LIMIT :count")
    suspend fun getRandomDreams(count: Int): List<DreamInterpretationEntity>
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(dreams: List<DreamInterpretationEntity>)
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(dream: DreamInterpretationEntity)
    
    @Query("DELETE FROM dream_interpretations")
    suspend fun deleteAll()
    
    @Query("SELECT COUNT(*) FROM dream_interpretations")
    suspend fun getCount(): Int
}
