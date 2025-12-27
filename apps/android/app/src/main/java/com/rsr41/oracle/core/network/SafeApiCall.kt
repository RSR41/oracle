package com.rsr41.oracle.core.network

import com.rsr41.oracle.core.result.AppException
import com.rsr41.oracle.core.result.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import retrofit2.HttpException
import timber.log.Timber
import java.io.IOException

/**
 * 안전한 API 호출 래퍼
 * - 네트워크 에러, HTTP 에러, 서버 에러를 Result.Error로 변환
 * - 성공 시 Result.Success 반환
 */
suspend fun <T> safeApiCall(apiCall: suspend () -> ApiResponse<T>): Result<T> {
    return withContext(Dispatchers.IO) {
        try {
            val response = apiCall()
            if (response.ok && response.data != null) {
                Timber.d("API Success, traceId: ${response.traceId}")
                Result.Success(response.data)
            } else {
                val error = response.error
                Timber.w("API Error: ${error?.code} - ${error?.message}, traceId: ${response.traceId}")
                Result.Error(
                    AppException.Server(
                        code = error?.code ?: "UNKNOWN",
                        message = error?.message ?: "서버 오류가 발생했습니다",
                        traceId = response.traceId
                    )
                )
            }
        } catch (e: IOException) {
            Timber.e(e, "Network error")
            Result.Error(AppException.Network())
        } catch (e: HttpException) {
            Timber.e(e, "HTTP error: ${e.code()}")
            Result.Error(AppException.Server("HTTP_${e.code()}", e.message(), null))
        } catch (e: Exception) {
            Timber.e(e, "Unknown error")
            Result.Error(AppException.Unknown())
        }
    }
}
