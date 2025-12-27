package com.rsr41.oracle.core.network

import kotlinx.serialization.Serializable

/**
 * 백엔드 API 공통 응답 포맷
 * 성공: { ok:true, data:..., traceId:"..." }
 * 실패: { ok:false, error:{ code:"...", message:"...", details?:... }, traceId:"..." }
 */
@Serializable
data class ApiResponse<T>(
    val ok: Boolean,
    val data: T? = null,
    val error: ApiError? = null,
    val traceId: String? = null
)

@Serializable
data class ApiError(
    val code: String,
    val message: String,
    val details: String? = null
)
