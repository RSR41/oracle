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
        
        // Deterministic Seed based on input
        val seed = (birthInfo.date + birthInfo.time + birthInfo.gender.name + birthInfo.calendarType.name).hashCode().toLong()
        val random = java.util.Random(seed)

        val genderText = if (birthInfo.gender == Gender.MALE) "남성" else "여성"
        val calendarText = if (birthInfo.calendarType == CalendarType.SOLAR) "양력" else "음력"

        val seasons = listOf(
            "봄의 따스한 기운이 당신을 감싸고 있습니다. 새로운 시작을 하기에 더할 나위 없이 좋은 시기입니다.",
            "여름의 열정적인 에너지가 넘칩니다. 추진하고 있는 일이 있다면 거침없이 나아가세요.",
            "가을의 풍요로움이 깃들어 있습니다. 그동안의 노력이 결실을 맺을 것입니다.",
            "겨울의 지혜와 인내가 필요합니다. 잠시 멈춰 내면을 단단히 다지는 것이 좋습니다."
        )
        val seasonalFortune = seasons[random.nextInt(seasons.size)]

        val adviceList = listOf(
            "오늘은 주변 사람들에게 귀를 기울이세요.",
            "독단적인 결정보다는 협력이 중요한 하루입니다.",
            "재물운이 상승하고 있으니 투자를 고려해보세요.",
            "건강에 유의하시고 충분한 휴식을 취하세요.",
            "예기치 않은 행운이 찾아올 수 있습니다.",
            "이동수가 있으니 여행이나 출장을 계획해보세요."
        )
        val dailyAdvice = adviceList[random.nextInt(adviceList.size)]

        val summaryToday = """
            $genderText ($calendarText) - 오늘 당신의 운세
            
            $seasonalFortune
            
            핵심 조언: $dailyAdvice
        """.trimIndent()

        // Mock Pillars (Random but deterministic)
        val stems = listOf("甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸")
        val branches = listOf("子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥")
        
        fun getPillar() = "${stems[random.nextInt(10)]}${branches[random.nextInt(12)]}"
        
        val pillars = """
            년주: ${getPillar()} (Your Year)
            월주: ${getPillar()} (Your Month)
            일주: ${getPillar()} (Your Day)
            시주: ${if (birthInfo.time.isNotBlank()) getPillar() else "미입력"} (Your Time)
        """.trimIndent()

        val luckyColors = listOf(
            "#FFD700" to "황금", // Gold
            "#FF4500" to "주황", // Red-Orange
            "#4169E1" to "파랑", // Royal Blue
            "#228B22" to "초록", // Forest Green
            "#C0C0C0" to "은색"  // Silver
        )
        val selectedColor = luckyColors[random.nextInt(luckyColors.size)]
        
        return SajuResult(
            summaryToday = summaryToday,
            pillars = pillars,
            luckyColor = selectedColor.first,
            luckyNumber = random.nextInt(9) + 1,
            generatedAtMillis = System.currentTimeMillis()
        )
    }
}
