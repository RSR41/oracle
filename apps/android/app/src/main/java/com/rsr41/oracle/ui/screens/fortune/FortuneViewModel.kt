package com.rsr41.oracle.ui.screens.fortune

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.rsr41.oracle.domain.model.Profile
import com.rsr41.oracle.repository.SajuRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class FortuneViewModel @Inject constructor(
    private val repository: SajuRepository
) : ViewModel() {

    var profiles by mutableStateOf<List<Profile>>(emptyList())
        private set

    var selectedProfile by mutableStateOf<Profile?>(null)
        private set

    var selectedTabIndex by mutableStateOf(0)
        private set

    init {
        loadProfiles()
    }

    fun loadProfiles() {
        profiles = repository.loadProfiles()
    }

    fun updateSelectedProfile(profile: Profile?) {
        selectedProfile = profile
    }

    fun updateTabIndex(index: Int) {
        selectedTabIndex = index
    }
}
