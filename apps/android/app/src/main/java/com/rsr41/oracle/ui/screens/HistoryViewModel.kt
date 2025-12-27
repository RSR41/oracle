package com.rsr41.oracle.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rsr41.oracle.domain.model.HistoryItem
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
    }

    var historyRecords by mutableStateOf<List<HistoryRecord>>(emptyList())
        private set

    var historyList by mutableStateOf<List<HistoryItem>>(emptyList())
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
            historyRecords = repository.loadHistoryRecords()
            historyList = repository.loadHistory()
            isLoading = false
            Log.d(TAG, "Loaded history: ${historyRecords.size} records, ${historyList.size} legacy items")
        }
    }

    fun selectRecord(record: HistoryRecord) {
        if (record.type == HistoryType.SAJU_FORTUNE) {
            shouldNavigateToResult = true
        }
    }

    fun selectLegacyItem(item: HistoryItem) {
        repository.saveLastResult(item)
        shouldNavigateToResult = true
    }

    fun deleteRecord(id: String) {
        repository.deleteHistoryRecord(id)
        loadHistory()
    }

    fun deleteItem(id: String) {
        repository.deleteHistoryItem(id)
        loadHistory()
    }

    fun clearAll() {
        repository.clearAllHistoryRecords()
        repository.clearHistory()
        loadHistory()
    }

    fun onNavigatedToResult() {
        shouldNavigateToResult = false
    }
}
