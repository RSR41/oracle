package com.rsr41.oracle.ui.screens.dream

import android.content.Context
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rsr41.oracle.data.local.OracleDatabase
import com.rsr41.oracle.data.local.entity.DreamInterpretationEntity
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class DreamViewModel @Inject constructor(
    @ApplicationContext private val context: Context
) : ViewModel() {

    private val dreamDao = OracleDatabase.getInstance(context).dreamDao()
    
    // 검색 쿼리
    var searchQuery by mutableStateOf("")
        private set
    
    // 선택된 카테고리
    var selectedCategory by mutableStateOf<String?>(null)
        private set
    
    // 검색 결과
    private val _searchResults = MutableStateFlow<List<DreamInterpretationEntity>>(emptyList())
    val searchResults: StateFlow<List<DreamInterpretationEntity>> = _searchResults.asStateFlow()
    
    // 모든 카테고리
    private val _categories = MutableStateFlow<List<String>>(emptyList())
    val categories: StateFlow<List<String>> = _categories.asStateFlow()
    
    // 인기 키워드 (랜덤 샘플)
    private val _popularKeywords = MutableStateFlow<List<DreamInterpretationEntity>>(emptyList())
    val popularKeywords: StateFlow<List<DreamInterpretationEntity>> = _popularKeywords.asStateFlow()
    
    // 선택된 꿈 해몽 상세
    var selectedDream by mutableStateOf<DreamInterpretationEntity?>(null)
        private set
    
    // 로딩 상태
    var isLoading by mutableStateOf(false)
        private set
    
    private var searchJob: Job? = null
    
    init {
        loadCategories()
        loadPopularKeywords()
    }
    
    private fun loadCategories() {
        viewModelScope.launch {
            dreamDao.getAllCategories().collect { cats ->
                _categories.value = cats
            }
        }
    }
    
    private fun loadPopularKeywords() {
        viewModelScope.launch(Dispatchers.IO) {
            val keywords = dreamDao.getRandomDreams(8)
            _popularKeywords.value = keywords
        }
    }
    
    fun onSearchQueryChange(query: String) {
        searchQuery = query
        searchJob?.cancel()
        
        if (query.isBlank()) {
            _searchResults.value = emptyList()
            return
        }
        
        searchJob = viewModelScope.launch {
            delay(300) // Debounce
            dreamDao.searchDreams(query).collect { results ->
                _searchResults.value = results
            }
        }
    }
    
    fun onCategorySelected(category: String?) {
        selectedCategory = category
        
        viewModelScope.launch {
            isLoading = true
            if (category == null) {
                dreamDao.getAllDreams().collect { dreams ->
                    _searchResults.value = dreams
                    isLoading = false
                }
            } else {
                dreamDao.getDreamsByCategory(category).collect { dreams ->
                    _searchResults.value = dreams
                    isLoading = false
                }
            }
        }
    }
    
    fun onDreamSelected(dream: DreamInterpretationEntity) {
        selectedDream = dream
    }
    
    fun clearSelection() {
        selectedDream = null
    }
    
    fun refreshPopularKeywords() {
        loadPopularKeywords()
    }
}
