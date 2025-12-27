package com.rsr41.oracle.data.api

import com.rsr41.oracle.core.network.ApiResponse
import com.rsr41.oracle.data.dto.*
import okhttp3.MultipartBody
import retrofit2.http.*

/**
 * Oracle 백엔드 API 서비스 인터페이스
 * Base path: /public
 */
interface OracleApiService {

    @GET("/public/tag/{token}")
    suspend fun getTagStatus(@Path("token") token: String): ApiResponse<TagStatusDto>

    @POST("/public/profile")
    suspend fun createProfile(@Body request: CreateProfileRequest): ApiResponse<CreateProfileResponse>

    @POST("/public/checkin")
    suspend fun checkIn(@Body request: CheckInRequest): ApiResponse<CheckInResponse>

    @POST("/public/today-report")
    suspend fun getTodayReport(@Body request: TodayReportRequest): ApiResponse<TodayReportResponse>

    @Multipart
    @POST("/public/face/upload")
    suspend fun uploadFace(@Part image: MultipartBody.Part): ApiResponse<FaceUploadResponse>
}
