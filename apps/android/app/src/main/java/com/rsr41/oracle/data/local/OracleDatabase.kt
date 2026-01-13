package com.rsr41.oracle.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.rsr41.oracle.data.local.dao.DreamDao
import com.rsr41.oracle.data.local.dao.FaceAnalysisDao
import com.rsr41.oracle.data.local.dao.SajuContentDao
import com.rsr41.oracle.data.local.dao.TarotCardDao
import com.rsr41.oracle.data.local.entity.DreamInterpretationEntity
import com.rsr41.oracle.data.local.entity.FaceAnalysisResultEntity
import com.rsr41.oracle.data.local.entity.SajuContentEntity
import com.rsr41.oracle.data.local.entity.TarotCardEntity

/**
 * Oracle App Room Database
 * - 히스토리, 타로, 사주 콘텐츠, 꿈해몽, 관상 결과 저장
 */
@Database(
    entities = [
        HistoryEntity::class,
        TarotCardEntity::class,
        SajuContentEntity::class,
        DreamInterpretationEntity::class,
        FaceAnalysisResultEntity::class
    ],
    version = 2,
    exportSchema = false
)
@TypeConverters(HistoryTypeConverters::class)
abstract class OracleDatabase : RoomDatabase() {
    
    abstract fun historyDao(): HistoryDao
    abstract fun tarotCardDao(): TarotCardDao
    abstract fun sajuContentDao(): SajuContentDao
    abstract fun dreamDao(): DreamDao
    abstract fun faceAnalysisDao(): FaceAnalysisDao
    
    companion object {
        private const val DATABASE_NAME = "oracle_db"
        
        @Volatile
        private var INSTANCE: OracleDatabase? = null
        
        fun getInstance(context: Context): OracleDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    OracleDatabase::class.java,
                    DATABASE_NAME
                )
                    .fallbackToDestructiveMigration()
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
