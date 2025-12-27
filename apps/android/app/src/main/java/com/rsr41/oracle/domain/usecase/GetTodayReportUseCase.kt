package com.rsr41.oracle.domain.usecase

import com.rsr41.oracle.core.result.Result
import com.rsr41.oracle.data.repository.OracleRemoteRepository
import com.rsr41.oracle.domain.model.TodayReport
import javax.inject.Inject

class GetTodayReportUseCase @Inject constructor(
    private val remoteRepository: OracleRemoteRepository
) {
    suspend operator fun invoke(profileId: String, token: String? = null): Result<TodayReport> {
        return remoteRepository.getTodayReport(profileId, token)
    }
}
