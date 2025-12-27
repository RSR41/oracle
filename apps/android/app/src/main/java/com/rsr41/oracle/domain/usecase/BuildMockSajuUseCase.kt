package com.rsr41.oracle.domain.usecase

import android.util.Log
import com.rsr41.oracle.domain.model.BirthInfo
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.Gender
import com.rsr41.oracle.domain.model.SajuResult

/**
 * Mock 사주 결과 생성 UseCase
 * 
 * 추후 진짜 사주 계산 엔진(CalculateRealSajuUseCase)으로 교체 가능하도록 설계됨.
 * 현재는 입력값에 따라 약간 다른 Mock 문구를 생성하여 테스트 가능성을 높임.
 */
class BuildMockSajuUseCase {
    
    companion object {
        private const val TAG = "BuildMockSajuUseCase"
    }

    /**
     * 입력된 생년월일 정보를 기반으로 Mock 사주 결과 생성
     * @param birthInfo 생년월일 정보
     * @return SajuResult Mock 결과
     */
    fun execute(birthInfo: BirthInfo): SajuResult {
        Log.d(TAG, "Generating mock saju for: date=${birthInfo.date}, gender=${birthInfo.gender}, calendar=${birthInfo.calendarType}")
        
        val genderText = when (birthInfo.gender) {
            Gender.MALE -> "남성"
            Gender.FEMALE -> "여성"
        }
        
        val calendarText = when (birthInfo.calendarType) {
            CalendarType.SOLAR -> "양력"
            CalendarType.LUNAR -> "음력"
        }

        // 날짜에서 월 추출하여 계절별 운세 생성
        val month = try {
            birthInfo.date.split("-")[1].toInt()
        } catch (e: Exception) {
            1
        }

        val seasonalFortune = when (month) {
            in 3..5 -> "봄의 기운이 가득하여 새로운 시작에 유리합니다."
            in 6..8 -> "여름의 열정이 넘쳐 활발한 활동이 기대됩니다."
            in 9..11 -> "가을의 결실을 맺을 수 있는 시기입니다."
            else -> "겨울의 인내가 빛을 발할 때입니다."
        }

        val summaryToday = """
            |$genderText ($calendarText 기준)
            |$seasonalFortune
            |오늘은 차분하게 계획을 세우면 좋은 결과가 있을 것입니다.
        """.trimMargin()

        // Mock 사주 기둥 (실제 계산은 추후 구현)
        val pillars = """
            |년주: 甲子 (갑자) [Mock]
            |월주: 乙丑 (을축) [Mock]
            |일주: 丙寅 (병인) [Mock]
            |시주: ${if (birthInfo.time.isNotBlank()) "丁卯 (정묘) [Mock]" else "시간 미입력"}
        """.trimMargin()

        val result = SajuResult(
            summaryToday = summaryToday,
            pillars = pillars,
            generatedAtMillis = System.currentTimeMillis()
        )

        Log.d(TAG, "Mock saju generated successfully")
        return result
    }
}
