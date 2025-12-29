package com.rsr41.oracle.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rsr41.oracle.domain.model.HistoryRecord
import com.rsr41.oracle.domain.model.HistoryType
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class HistoryViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {
    
    companion object {
        private const val TAG = "HistoryViewModel"
        private const val TTL_FREE_MS = 7 * 24 * 60 * 60 * 1000L // 7 days
    }

    // Premium Stub (To be replaced with Billing/DataStore later)
    var isPremium by mutableStateOf(false)
        private set

    // Filtering
    var selectedFilter by mutableStateOf<HistoryType?>(null)
        private set

    private var _allRecords = emptyList<HistoryRecord>()

    var historyRecords by mutableStateOf<List<HistoryRecord>>(emptyList())
        private set
    
    var isLoading by mutableStateOf(false)
        private set

    var shouldNavigateToResult by mutableStateOf(false)
        private set

    init {
        loadHistory()
    }

    fun loadHistory() {
        viewModelScope.launch {
            isLoading = true
            
            // 1. Purge Expired (Mock logic: if !isPremium, remove old items)
            if (!isPremium) {
                purgeExpiredRecords()
            }
            
            // 2. Load
            _allRecords = repository.loadHistoryRecords()
            applyFilter()
            
            isLoading = false
            Log.d(TAG, "Loaded history: ${_allRecords.size} records")
        }
    }

    private fun purgeExpiredRecords() {
        val now = System.currentTimeMillis()
        val all = repository.loadHistoryRecords()
        
        // Items to KEEP
        val valid = all.filter { record ->
            // If expiresAt is set, respect it. If not, apply default free TTL rule if not premium
            val expiry = record.expiresAt ?: (record.createdAt + TTL_FREE_MS)
            now < expiry
        }

        // If items were removed, save back
        if (valid.size != all.size) {
             Log.d(TAG, "Purging ${all.size - valid.size} expired records")
             repository.clearAllHistoryRecords()
             // Re-add to preserve order in simplest way
             valid.reversed().forEach { repository.appendHistoryRecord(it) } 
        }
    }

    fun setFilter(type: HistoryType?) {
        selectedFilter = type
        applyFilter()
    }

    private fun applyFilter() {
        historyRecords = if (selectedFilter == null) {
            _allRecords
        } else {
            _allRecords.filter { it.type == selectedFilter }
        }
    }

    fun togglePremium() {
        isPremium = !isPremium
        // If becoming non-premium, purge might happen next load.
        // If becoming premium, no purge ensures old items stay (if not already gone).
        loadHistory() 
    }

    fun selectRecord(record: HistoryRecord) {
        // TODO: Pass generic 'record' to ResultScreen, not just Saju.
        // For MVP, simplistic navigation
        shouldNavigateToResult = true
    }

    fun deleteRecord(id: String) {
        repository.deleteHistoryRecord(id)
        loadHistory()
    }

    fun clearAll() {
        repository.clearAllHistoryRecords()
        loadHistory()
    }

    fun onNavigatedToResult() {
        shouldNavigateToResult = false
    }
}
