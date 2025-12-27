package com.rsr41.oracle.ui.screens

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.domain.model.HistoryItem
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class HistoryViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {
    
    companion object {
        private const val TAG = "HistoryViewModel"
    }

    var historyList by mutableStateOf<List<HistoryItem>>(emptyList())
        private set
    
    var isLoading by mutableStateOf(true)
        private set

    var shouldNavigateToResult by mutableStateOf(false)
        private set

    init {
        loadHistory()
    }

    fun loadHistory() {
        isLoading = true
        historyList = repository.loadHistory()
        isLoading = false
        Log.d(TAG, "Loaded history: ${historyList.size} items")
    }

    fun selectItem(item: HistoryItem) {
        repository.saveLastResult(item)
        shouldNavigateToResult = true
    }

    fun deleteItem(id: String) {
        repository.deleteHistoryItem(id)
        loadHistory()
    }

    fun clearAllHistory() {
        repository.clearHistory()
        loadHistory()
    }

    fun onNavigatedToResult() {
        shouldNavigateToResult = false
    }
}
