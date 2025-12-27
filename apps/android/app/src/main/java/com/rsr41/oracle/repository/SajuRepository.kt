package com.rsr41.oracle.repository

import com.rsr41.oracle.domain.model.*

/**
 * 사주 데이터 저장소 인터페이스
 * - 설정값 관리
 * - 히스토리 관리
 * - 결과 생성 및 저장
 */
interface SajuRepository {
    // 사주 결과 생성 (Mock)
    fun getMockSaju(birthInfo: BirthInfo): SajuResult
    
    // 설정값
    fun loadDefaultCalendarType(): CalendarType
    fun saveDefaultCalendarType(type: CalendarType)
    
    // 프로필 (로컬)
    fun loadProfiles(): List<Profile>
    fun saveProfile(profile: Profile)
    fun deleteProfile(id: String)

    // 히스토리 (Enhanced)
    fun loadHistoryRecords(): List<HistoryRecord>
    fun appendHistoryRecord(record: HistoryRecord)
    fun deleteHistoryRecord(id: String)
    fun clearAllHistoryRecords()

    // 히스토리 (Legacy)
    fun loadHistory(): List<HistoryItem>
    fun appendHistory(item: HistoryItem)
    fun deleteHistoryItem(id: String)
    fun clearHistory()
    
    // 마지막 결과
    fun loadLastResult(): HistoryItem?
    fun saveLastResult(item: HistoryItem)
}
