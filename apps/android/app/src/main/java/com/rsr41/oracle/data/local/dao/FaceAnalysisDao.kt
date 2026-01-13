package com.rsr41.oracle.data.local.dao

import androidx.room.*
import com.rsr41.oracle.data.local.entity.FaceAnalysisResultEntity
import kotlinx.coroutines.flow.Flow

/**
 * 관상 분석 결과 DAO
 */
@Dao
interface FaceAnalysisDao {
    
    @Query("SELECT * FROM face_analysis_results ORDER BY timestamp DESC")
    fun getAllResults(): Flow<List<FaceAnalysisResultEntity>>
    
    @Query("SELECT * FROM face_analysis_results WHERE id = :id")
    suspend fun getResultById(id: String): FaceAnalysisResultEntity?
    
    @Query("SELECT * FROM face_analysis_results ORDER BY timestamp DESC LIMIT :count")
    fun getRecentResults(count: Int): Flow<List<FaceAnalysisResultEntity>>
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(result: FaceAnalysisResultEntity)
    
    @Delete
    suspend fun delete(result: FaceAnalysisResultEntity)
    
    @Query("DELETE FROM face_analysis_results WHERE id = :id")
    suspend fun deleteById(id: String)
    
    @Query("DELETE FROM face_analysis_results")
    suspend fun deleteAll()
    
    @Query("SELECT COUNT(*) FROM face_analysis_results")
    suspend fun getCount(): Int
}
