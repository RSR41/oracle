package com.rsr41.oracle.core.di

import android.content.Context
import com.rsr41.oracle.data.local.HistoryDao
import com.rsr41.oracle.data.local.OracleDatabase
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/**
 * Database Hilt Module
 */
@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {
    
    @Provides
    @Singleton
    fun provideOracleDatabase(
        @ApplicationContext context: Context
    ): OracleDatabase {
        return OracleDatabase.getInstance(context)
    }
    
    @Provides
    @Singleton
    fun provideHistoryDao(database: OracleDatabase): HistoryDao {
        return database.historyDao()
    }
}
