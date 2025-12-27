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
class ResultViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {
    
    companion object {
        private const val TAG = "ResultViewModel"
    }

    var historyItem by mutableStateOf<HistoryItem?>(null)
        private set
    
    var isLoading by mutableStateOf(true)
        private set

    init {
        loadLastResult()
    }

    fun loadLastResult() {
        isLoading = true
        historyItem = repository.loadLastResult()
        isLoading = false
        Log.d(TAG, "Loaded last result: ${historyItem?.id ?: "null"}")
    }
}
