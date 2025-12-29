package com.rsr41.oracle.repository

import com.rsr41.oracle.domain.model.Profile
import java.util.Random

class MockManseEngine : ManseEngine {

    private val stems = listOf("甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸")
    private val branches = listOf("子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥")

    override fun getDaewun(profile: Profile): ManseDaewunResult {
        val seed = profile.id.hashCode().toLong()
        val random = Random(seed)
        
        // 대운 시작 나이 (1~10 사이 랜덤)
        val startAgeBase = random.nextInt(10) + 1
        
        val list = mutableListOf<DaewunItem>()
        val birthYear = try { profile.birthDate.split("-")[0].toInt() } catch(e:Exception) { 1990 }
        
        // 8개 대운 생성
        for (i in 0 until 8) {
            val age = startAgeBase + (i * 10)
            val startYear = birthYear + age
            val endYear = startYear + 9
            val stem = stems[random.nextInt(10)]
            val branch = branches[random.nextInt(12)]
            val ganji = "$stem$branch"
            
            // 현재 나이 계산 (대략)
            val currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)
            val isCurrent = currentYear in startYear..endYear
            
            val keyword = when(i % 4) {
                0 -> "새로운 시작"
                1 -> "성장과 발전"
                2 -> "결실과 수확"
                else -> "정리와 휴식"
            }
            
            list.add(DaewunItem(
                startAge = age,
                startYear = startYear,
                endYear = endYear,
                ganji = ganji,
                keyword = keyword,
                description = "$startYear~$endYear 대운은 $keyword 의 시기입니다. ${ganji}의 기운이 들어와 변화가 예상됩니다.",
                isCurrent = isCurrent
            ))
        }

        return ManseDaewunResult(
            profileId = profile.id,
            currentDaewun = list.find { it.isCurrent } ?: list.first(),
            daewunList = list
        )
    }

    override fun getSaeun(profile: Profile, year: Int): ManseSaeunResult {
        val seed = (profile.id + year).hashCode().toLong()
        val random = Random(seed)
        
        val stem = stems[year % 10] // 단순화된 로직
        val branch = branches[year % 12]
        val ganji = "$stem$branch"

        val summary = "올해($year)는 당신에게 중요한 변화의 시기가 될 것입니다. 특히 상반기보다는 하반기에 운이 트입니다."
        
        val quarters = listOf(
            QuarterlyPoint("1분기(봄)", "준비", "새로운 계획을 세우고 씨앗을 뿌리는 시기입니다."),
            QuarterlyPoint("2분기(여름)", "성장", "노력한 만큼 성과가 보이기 시작합니다."),
            QuarterlyPoint("3분기(가을)", "수확", "기다리던 결실을 맺을 수 있습니다."),
            QuarterlyPoint("4분기(겨울)", "저장", "다음 해를 위해 에너지를 비축하세요.")
        )

        return ManseSaeunResult(
            profileId = profile.id,
            year = year,
            ganji = ganji,
            keyword = "변화와 기회",
            summary = summary,
            quarterlyPoints = quarters
        )
    }

    override fun getWolun(profile: Profile, year: Int, month: Int): ManseWolunResult {
         val seed = (profile.id + year + month).hashCode().toLong()
         val random = Random(seed)
         
         val stem = stems[random.nextInt(10)]
         val branch = branches[random.nextInt(12)]
         val ganji = "$stem$branch"
         
         val score = 50 + random.nextInt(50) // 50~100점
         
         return ManseWolunResult(
             profileId = profile.id,
             year = year,
             month = month,
             ganji = ganji,
             score = score,
             summary = "$month 월은 전반적으로 안정적인 흐름을 보입니다.",
             advice = "과도한 욕심을 버리고 주변 사람들과 협력하세요."
         )
    }
}
