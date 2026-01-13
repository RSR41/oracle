package com.rsr41.oracle.data.local.dao

import androidx.room.*
import com.rsr41.oracle.data.local.entity.TarotCardEntity
import kotlinx.coroutines.flow.Flow

/**
 * 타로 카드 DAO
 */
@Dao
interface TarotCardDao {
    
    @Query("SELECT * FROM tarot_cards ORDER BY number ASC")
    fun getAllCards(): Flow<List<TarotCardEntity>>
    
    @Query("SELECT * FROM tarot_cards WHERE id = :id")
    suspend fun getCardById(id: String): TarotCardEntity?
    
    @Query("SELECT * FROM tarot_cards WHERE category = :category ORDER BY number ASC")
    fun getCardsByCategory(category: String): Flow<List<TarotCardEntity>>
    
    @Query("SELECT * FROM tarot_cards WHERE category = 'MAJOR' ORDER BY number ASC")
    fun getMajorArcana(): Flow<List<TarotCardEntity>>
    
    @Query("SELECT * FROM tarot_cards WHERE category = 'MINOR' ORDER BY number ASC")
    fun getMinorArcana(): Flow<List<TarotCardEntity>>
    
    @Query("SELECT * FROM tarot_cards ORDER BY RANDOM() LIMIT :count")
    suspend fun getRandomCards(count: Int): List<TarotCardEntity>
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(cards: List<TarotCardEntity>)
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(card: TarotCardEntity)
    
    @Query("DELETE FROM tarot_cards")
    suspend fun deleteAll()
    
    @Query("SELECT COUNT(*) FROM tarot_cards")
    suspend fun getCount(): Int
}
