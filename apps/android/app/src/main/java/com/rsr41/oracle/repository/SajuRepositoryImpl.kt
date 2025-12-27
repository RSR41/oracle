package com.rsr41.oracle.repository

import com.rsr41.oracle.data.local.PreferencesManager
import com.rsr41.oracle.domain.model.BirthInfo
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.HistoryItem
import com.rsr41.oracle.domain.model.SajuResult
import com.rsr41.oracle.domain.usecase.BuildMockSajuUseCase

/**
 * SajuRepository 구현체
 * - PreferencesManager를 통한 데이터 저장/로드
 * - BuildMockSajuUseCase를 통한 Mock 사주 결과 생성
 */
class SajuRepositoryImpl(
    private val preferencesManager: PreferencesManager,
    private val buildMockSajuUseCase: BuildMockSajuUseCase
) : SajuRepository {

    override fun getMockSaju(birthInfo: BirthInfo): SajuResult {
        return buildMockSajuUseCase.execute(birthInfo)
    }

    override fun loadDefaultCalendarType(): CalendarType {
        return preferencesManager.loadDefaultCalendarType()
    }

    override fun saveDefaultCalendarType(type: CalendarType) {
        preferencesManager.saveDefaultCalendarType(type)
    }

    override fun loadHistory(): List<HistoryItem> {
        return preferencesManager.loadHistory()
    }

    override fun appendHistory(item: HistoryItem) {
        preferencesManager.appendHistory(item)
    }

    override fun deleteHistoryItem(id: String) {
        preferencesManager.deleteHistoryItem(id)
    }

    override fun clearHistory() {
        preferencesManager.clearHistory()
    }

    override fun loadLastResult(): HistoryItem? {
        return preferencesManager.loadLastResult()
    }

    override fun saveLastResult(item: HistoryItem) {
        preferencesManager.saveLastResult(item)
    }
}
