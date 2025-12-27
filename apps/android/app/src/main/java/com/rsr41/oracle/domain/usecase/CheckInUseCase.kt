package com.rsr41.oracle.domain.usecase

import com.rsr41.oracle.core.result.Result
import com.rsr41.oracle.data.repository.OracleRemoteRepository
import com.rsr41.oracle.domain.model.CheckInResult
import javax.inject.Inject

class CheckInUseCase @Inject constructor(
    private val remoteRepository: OracleRemoteRepository
) {
    suspend operator fun invoke(profileId: String, token: String? = null): Result<CheckInResult> {
        return remoteRepository.checkIn(profileId, token)
    }
}
