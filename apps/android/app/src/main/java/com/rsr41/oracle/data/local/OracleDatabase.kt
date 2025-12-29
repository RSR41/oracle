package com.rsr41.oracle.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters

/**
 * Oracle App Room Database
 */
@Database(
    entities = [HistoryEntity::class],
    version = 1,
    exportSchema = false
)
@TypeConverters(HistoryTypeConverters::class)
abstract class OracleDatabase : RoomDatabase() {
    
    abstract fun historyDao(): HistoryDao
    
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
