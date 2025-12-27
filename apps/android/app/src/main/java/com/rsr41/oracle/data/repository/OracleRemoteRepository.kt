package com.rsr41.oracle.data.repository

import com.rsr41.oracle.core.network.safeApiCall
import com.rsr41.oracle.core.result.Result
import com.rsr41.oracle.core.result.*
import com.rsr41.oracle.data.api.OracleApiService
import com.rsr41.oracle.data.dto.*
import com.rsr41.oracle.domain.model.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Remote Repository - 백엔드 API 통신
 */
@Singleton
class OracleRemoteRepository @Inject constructor(
    private val apiService: OracleApiService
) {
    suspend fun getTagStatus(token: String): Result<TagStatus> {
        return safeApiCall { apiService.getTagStatus(token) }.map { dto ->
            TagStatus(
                token = dto.token,
                status = TagStatusType.fromString(dto.status),
                boundProfileId = dto.boundProfileId
            )
        }
    }

    suspend fun createProfile(profile: ProfileInput): Result<String> {
        val request = CreateProfileRequest(
            birthDate = profile.birthDate,
            birthTime = profile.birthTime,
            timeUnknown = profile.timeUnknown,
            calendarType = profile.calendarType.apiValue,
            gender = profile.gender.apiValue
        )
        return safeApiCall { apiService.createProfile(request) }.map { it.profileId }
    }

    suspend fun checkIn(profileId: String, token: String?): Result<CheckInResult> {
        val request = CheckInRequest(profileId, token)
        return safeApiCall { apiService.checkIn(request) }.map { dto ->
            CheckInResult(dto.dateKey, dto.unlocked, dto.alreadyCheckedIn)
        }
    }

    suspend fun getTodayReport(profileId: String, token: String?): Result<TodayReport> {
        val request = TodayReportRequest(profileId, token)
        return safeApiCall { apiService.getTodayReport(request) }.map { dto ->
            TodayReport(dto.dateKey, dto.preview, dto.full, dto.unlocked)
        }
    }

    suspend fun uploadFace(imageFile: File): Result<FaceResult> {
        val requestBody = imageFile.asRequestBody("image/*".toMediaTypeOrNull())
        val part = MultipartBody.Part.createFormData("image", imageFile.name, requestBody)
        return safeApiCall { apiService.uploadFace(part) }.map { dto ->
            FaceResult(dto.dateKey, dto.summaryText, dto.flags)
        }
    }
}
