package com.rsr41.oracle.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.TypeConverter
import androidx.room.TypeConverters
import com.rsr41.oracle.domain.model.HistoryType
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

/**
 * 히스토리 저장 엔티티
 * 모든 유형(사주, 궁합, 관상, 타로)의 기록을 통합 저장
 */
@Entity(tableName = "history")
@TypeConverters(HistoryTypeConverters::class)
data class HistoryEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val type: HistoryType,
    val title: String,
    val summary: String,
    val detailJson: String,  // 상세 데이터 JSON
    val createdAt: Long = System.currentTimeMillis(),
    val isPremium: Boolean = false  // 프리미엄 사용자 여부 (자동 삭제 제외)
)

/**
 * Room TypeConverters
 */
class HistoryTypeConverters {
    private val json = Json { 
        ignoreUnknownKeys = true
        encodeDefaults = true
    }
    
    @TypeConverter
    fun fromHistoryType(type: HistoryType): String = type.name
    
    @TypeConverter
    fun toHistoryType(value: String): HistoryType = HistoryType.valueOf(value)
    
    @TypeConverter
    fun fromMap(map: Map<String, Any>): String = json.encodeToString(map)
}
