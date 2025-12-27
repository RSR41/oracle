package com.rsr41.oracle.domain.usecase

import com.rsr41.oracle.core.result.Result
import com.rsr41.oracle.data.repository.OracleRemoteRepository
import com.rsr41.oracle.domain.model.ProfileInput
import javax.inject.Inject

class CreateProfileUseCase @Inject constructor(
    private val remoteRepository: OracleRemoteRepository
) {
    suspend operator fun invoke(profile: ProfileInput): Result<String> {
        return remoteRepository.createProfile(profile)
    }
}
