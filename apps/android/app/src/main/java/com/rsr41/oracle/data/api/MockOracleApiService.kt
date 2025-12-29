package com.rsr41.oracle.data.api

import com.rsr41.oracle.core.network.ApiResponse
import com.rsr41.oracle.data.dto.*
import kotlinx.coroutines.delay
import okhttp3.MultipartBody
import java.util.UUID

/**
 * Mock API Service for local development
 * Returns realistic dummy data matching the real API structure
 * 향후 백엔드 연동 시 NetworkModule에서 실제 Retrofit 구현체로 교체
 */
class MockOracleApiService : OracleApiService {

    override suspend fun getTagStatus(token: String): ApiResponse<TagStatusDto> {
        delay(300) // 네트워크 지연 시뮬레이션
        return ApiResponse(
            ok = true,
            data = TagStatusDto(
                token = token,
                status = "ACTIVE",
                boundProfileId = UUID.randomUUID().toString()
            ),
            error = null
        )
    }

    override suspend fun createProfile(request: CreateProfileRequest): ApiResponse<CreateProfileResponse> {
        delay(500)
        return ApiResponse(
            ok = true,
            data = CreateProfileResponse(
                profileId = UUID.randomUUID().toString()
            ),
            error = null
        )
    }

    override suspend fun checkIn(request: CheckInRequest): ApiResponse<CheckInResponse> {
        delay(400)
        return ApiResponse(
            ok = true,
            data = CheckInResponse(
                dateKey = java.time.LocalDate.now().toString(),
                unlocked = true,
                alreadyCheckedIn = false
            ),
            error = null
        )
    }

    override suspend fun getTodayReport(request: TodayReportRequest): ApiResponse<TodayReportResponse> {
        delay(600)
        return ApiResponse(
            ok = true,
            data = TodayReportResponse(
                dateKey = java.time.LocalDate.now().toString(),
                preview = "오늘은 귀인의 도움을 받기 좋은 날입니다. 새로운 만남에 적극적으로 임하세요.",
                full = """
                    🔮 오늘의 운세
                    
                    전체 운: ★★★★☆
                    오늘은 목(木)의 기운이 강하게 작용하는 날입니다.
                    창의적인 아이디어가 샘솟는 하루가 될 것입니다.
                    
                    💼 직장/사업운
                    새로운 프로젝트나 도전에 좋은 시기입니다.
                    동료들과의 협력이 좋은 결과를 가져올 것입니다.
                    
                    💕 연애운
                    솔로: 우연한 만남에 기회가 있습니다.
                    커플: 소소한 이벤트가 관계를 더욱 돈독하게 합니다.
                    
                    💰 재물운
                    충동적인 지출은 피하고, 계획적인 소비가 필요합니다.
                    투자보다는 저축에 집중하시길 권합니다.
                    
                    🍀 행운의 색: 녹색, 파란색
                    🔢 행운의 숫자: 3, 7, 8
                """.trimIndent(),
                unlocked = true
            ),
            error = null
        )
    }

    override suspend fun uploadFace(image: MultipartBody.Part): ApiResponse<FaceUploadResponse> {
        delay(1500) // 이미지 분석 시뮬레이션
        return ApiResponse(
            ok = true,
            data = FaceUploadResponse(
                dateKey = java.time.LocalDate.now().toString(),
                summaryText = """
                    📸 관상 분석 결과
                    
                    🌟 전체적인 인상
                    밝고 긍정적인 에너지가 느껴지는 인상입니다.
                    얼굴 균형도가 87%로 매우 조화로운 모습입니다.
                    
                    👀 눈
                    밝고 또렷한 눈매가 지적인 느낌을 줍니다.
                    
                    👃 코
                    안정감 있는 코의 형태가 신뢰감을 줍니다.
                    
                    👄 입
                    부드러운 입매가 친화력 있는 성격을 나타냅니다.
                    
                    ⚠️ 참고: 이 분석은 오락/참고용이며 개인의 민감 정보를 추정하지 않습니다.
                """.trimIndent(),
                flags = listOf("POSITIVE_EXPRESSION", "HIGH_SYMMETRY", "CLEAR_IMAGE")
            ),
            error = null
        )
    }
}

