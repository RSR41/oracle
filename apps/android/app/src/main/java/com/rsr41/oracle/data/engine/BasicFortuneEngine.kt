package com.rsr41.oracle.data.engine

import com.rsr41.oracle.domain.engine.*
import com.rsr41.oracle.domain.model.BirthInfo
import com.rsr41.oracle.domain.model.CalendarType
import kotlinx.coroutines.delay
import java.time.LocalDate
import java.time.LocalTime
import java.time.format.DateTimeFormatter

/**
 * 기본 사주 계산 엔진 (MVP용)
 * 간단한 천간지지 계산 + 템플릿 기반 해석
 */
class BasicFortuneEngine : FortuneEngine {
    
    // 천간 (10개)
    private val heavenlyStems = listOf("갑", "을", "병", "정", "무", "기", "경", "신", "임", "계")
    
    // 지지 (12개)
    private val earthlyBranches = listOf("자", "축", "인", "묘", "진", "사", "오", "미", "신", "유", "술", "해")
    
    // 오행 매핑
    private val stemElements = mapOf(
        "갑" to "목", "을" to "목",
        "병" to "화", "정" to "화",
        "무" to "토", "기" to "토",
        "경" to "금", "신" to "금",
        "임" to "수", "계" to "수"
    )
    
    override suspend fun calculate(birthInfo: BirthInfo): Result<FortuneResult> {
        return try {
            // MVP: 간단한 계산 시뮬레이션
            delay(500)
            
            // Parse date string (yyyy-MM-dd)
            val date = try {
                LocalDate.parse(birthInfo.date, DateTimeFormatter.ISO_LOCAL_DATE)
            } catch (e: Exception) {
                LocalDate.now()
            }
            
            // Parse time string (HH:mm) - optional
            val time = if (birthInfo.time.isNotBlank()) {
                try {
                    LocalTime.parse(birthInfo.time, DateTimeFormatter.ofPattern("HH:mm"))
                } catch (e: Exception) {
                    null
                }
            } else null
            
            val year = date.year
            val month = date.monthValue
            val day = date.dayOfMonth
            
            // 년주 계산 (간단한 공식)
            val yearStemIndex = (year - 4) % 10
            val yearBranchIndex = (year - 4) % 12
            val yearPillar = Pillar(
                heavenlyStem = heavenlyStems[if (yearStemIndex >= 0) yearStemIndex else yearStemIndex + 10],
                earthlyBranch = earthlyBranches[if (yearBranchIndex >= 0) yearBranchIndex else yearBranchIndex + 12]
            )
            
            // 월주 계산 (간략화)
            val monthStemIndex = ((year % 10) * 2 + month) % 10
            val monthBranchIndex = (month + 1) % 12
            val monthPillar = Pillar(
                heavenlyStem = heavenlyStems[monthStemIndex],
                earthlyBranch = earthlyBranches[monthBranchIndex]
            )
            
            // 일주 계산 (간략화 - 실제로는 만세력 필요)
            val dayStemIndex = (year + month + day) % 10
            val dayBranchIndex = (year + month + day) % 12
            val dayPillar = Pillar(
                heavenlyStem = heavenlyStems[dayStemIndex],
                earthlyBranch = earthlyBranches[dayBranchIndex]
            )
            
            // 시주 계산 (선택적)
            val hourPillar = time?.let {
                val hourIndex = it.hour / 2
                val hourStemIndex = (dayStemIndex * 2 + hourIndex) % 10
                Pillar(
                    heavenlyStem = heavenlyStems[hourStemIndex],
                    earthlyBranch = earthlyBranches[hourIndex % 12]
                )
            }
            
            // 오행 계산
            val elements = calculateElements(yearPillar, monthPillar, dayPillar, hourPillar)
            
            // 해석 생성
            val interpretation = generateInterpretation(
                dayPillar = dayPillar,
                elements = elements,
                calendarType = birthInfo.calendarType
            )
            
            Result.success(
                FortuneResult(
                    birthDate = birthInfo.date,
                    birthTime = birthInfo.time,
                    pillars = FourPillars(
                        year = yearPillar,
                        month = monthPillar,
                        day = dayPillar,
                        hour = hourPillar
                    ),
                    elements = elements,
                    tenGods = emptyMap(), // MVP에서는 생략
                    interpretation = interpretation,
                    luckyColors = getLuckyColors(elements),
                    luckyNumbers = getLuckyNumbers(dayPillar),
                    engineInfo = getEngineInfo()
                )
            )
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    private fun calculateElements(
        year: Pillar,
        month: Pillar,
        day: Pillar,
        hour: Pillar?
    ): Map<String, Int> {
        val counts = mutableMapOf(
            "목" to 0, "화" to 0, "토" to 0, "금" to 0, "수" to 0
        )
        
        listOfNotNull(year, month, day, hour).forEach { pillar ->
            stemElements[pillar.heavenlyStem]?.let { element ->
                counts[element] = counts.getOrDefault(element, 0) + 1
            }
        }
        
        return counts
    }
    
    private fun generateInterpretation(
        dayPillar: Pillar,
        elements: Map<String, Int>,
        calendarType: CalendarType
    ): String {
        val dayMaster = dayPillar.heavenlyStem
        val dayMasterElement = stemElements[dayMaster] ?: "토"
        
        val dominantElement = elements.maxByOrNull { it.value }?.key ?: "토"
        val weakestElement = elements.minByOrNull { it.value }?.key ?: "수"
        
        return buildString {
            appendLine("📊 일간(일주 천간): $dayMaster (${dayMasterElement})")
            appendLine()
            appendLine("🔮 오행 분석:")
            elements.forEach { (element, count) ->
                val bar = "●".repeat(count) + "○".repeat(4 - count)
                appendLine("  $element: $bar ($count)")
            }
            appendLine()
            appendLine("💫 총운:")
            appendLine("${dayMasterElement}의 기운을 타고난 당신은 ${getElementDescription(dayMasterElement)}")
            appendLine()
            appendLine("${dominantElement}의 기운이 강하여 ${getElementStrength(dominantElement)}")
            if (elements[weakestElement] == 0) {
                appendLine("${weakestElement}의 기운이 부족하니 ${getElementWeakness(weakestElement)}")
            }
            appendLine()
            appendLine("⚠️ 참고: 이 결과는 기본 계산 기반입니다. 정확한 분석은 전문가 상담을 권장합니다.")
        }
    }
    
    private fun getElementDescription(element: String): String = when (element) {
        "목" -> "성장과 발전의 에너지가 있습니다. 새로운 시작에 유리하고 창의적인 면이 있습니다."
        "화" -> "열정과 에너지가 넘칩니다. 표현력이 풍부하고 리더십이 있습니다."
        "토" -> "안정과 신뢰의 기운입니다. 중심을 잘 잡고 균형감이 뛰어납니다."
        "금" -> "결단력과 정의감이 강합니다. 원칙을 중시하고 책임감이 있습니다."
        "수" -> "지혜와 유연함을 갖추었습니다. 적응력이 뛰어나고 통찰력이 있습니다."
        else -> "다양한 가능성을 가지고 있습니다."
    }
    
    private fun getElementStrength(element: String): String = when (element) {
        "목" -> "창의적이고 성장 지향적인 성향이 두드러집니다."
        "화" -> "열정적이고 표현력이 뛰어난 면이 강조됩니다."
        "토" -> "안정적이고 신뢰할 수 있는 모습이 부각됩니다."
        "금" -> "원칙적이고 정의로운 면이 강하게 나타납니다."
        "수" -> "지적이고 유연한 사고가 돋보입니다."
        else -> "균형 잡힌 모습을 보입니다."
    }
    
    private fun getElementWeakness(element: String): String = when (element) {
        "목" -> "창의성과 새로운 시작의 에너지를 보충하면 좋겠습니다."
        "화" -> "열정과 표현력을 더 발휘해보세요."
        "토" -> "안정감과 중심을 잡는 노력이 필요합니다."
        "금" -> "결단력과 원칙을 더 세워보세요."
        "수" -> "유연함과 지혜를 기르면 도움이 됩니다."
        else -> "균형을 맞추는 노력이 필요합니다."
    }
    
    private fun getLuckyColors(elements: Map<String, Int>): List<String> {
        val weakest = elements.minByOrNull { it.value }?.key ?: "토"
        return when (weakest) {
            "목" -> listOf("#228B22", "#90EE90") // 녹색 계열
            "화" -> listOf("#FF4500", "#FF6347") // 빨강 계열
            "토" -> listOf("#D2691E", "#DEB887") // 황토 계열
            "금" -> listOf("#FFD700", "#C0C0C0") // 금/은색 계열
            "수" -> listOf("#000080", "#4169E1") // 파랑 계열
            else -> listOf("#D4A574", "#8B4513") // 기본 베이지
        }
    }
    
    private fun getLuckyNumbers(dayPillar: Pillar): List<Int> {
        val stemIndex = heavenlyStems.indexOf(dayPillar.heavenlyStem)
        val branchIndex = earthlyBranches.indexOf(dayPillar.earthlyBranch)
        return listOf(
            (stemIndex + 1),
            (branchIndex + 1),
            ((stemIndex + branchIndex) % 9 + 1)
        ).distinct()
    }
    
    override fun getEngineInfo(): EngineInfo = EngineInfo(
        name = "BasicFortuneEngine",
        version = "1.0.0",
        accuracy = AccuracyLevel.MEDIUM
    )
}

