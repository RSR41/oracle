package com.rsr41.oracle.repository

import com.rsr41.oracle.domain.model.Profile
import com.rsr41.oracle.ui.screens.compatibility.CompatibilityType
import java.util.Random

class MockCompatibilityEngine : CompatibilityEngine {

    override fun analyze(myProfile: Profile, partnerProfile: Profile, type: CompatibilityType): CompatibilityResult {
        // Deterministic Seed: MyID + PartnerID + Type
        val seed = (myProfile.id + partnerProfile.id + type.name).hashCode().toLong()
        val random = Random(seed)

        val score = 60 + random.nextInt(41) // 60 ~ 100

        val (summary, pros, cons, advice) = when (type) {
            CompatibilityType.LOVE -> generateLoveContent(random, myProfile.nickname, partnerProfile.nickname)
            CompatibilityType.MARRIAGE -> generateMarriageContent(random, myProfile.nickname, partnerProfile.nickname)
            CompatibilityType.BUSINESS -> generateBusinessContent(random, myProfile.nickname, partnerProfile.nickname)
        }

        return CompatibilityResult(
            myProfileId = myProfile.id,
            partnerProfileId = partnerProfile.id,
            type = type,
            score = score,
            summary = summary,
            pros = pros,
            cons = cons,
            advice = advice
        )
    }

    private fun generateLoveContent(random: Random, p1: String, p2: String): Content {
        val summaries = listOf(
            "$p1 님과 $p2 님은 서로 다른 매력에 이끌리는 관계입니다.",
            "두 분은 마치 오랫동안 알고 지낸 것처럼 편안한 사이입니다.",
            "열정적인 사랑보다는 잔잔한 신뢰가 돋보이는 커플입니다."
        )
        val prosList = listOf(
            "서로의 취미를 존중합니다.", "대화가 잘 통합니다.", "개그 코드가 잘 맞습니다.", 
            "힘들 때 큰 위로가 됩니다.", "서로를 성장시키는 관계입니다."
        )
        val consList = listOf(
            "사소한 오해로 다툴 수 있습니다.", "표현 방식의 차이가 있습니다.", "연락 문제로 서운할 수 있습니다.",
            "경제 관념의 차이가 있을 수 있습니다."
        )
        val adviceList = listOf(
            "서로의 다름을 인정하고 대화로 풀어가세요.",
            "작은 선물로 마음을 표현해보세요.",
            "함께하는 시간을 늘려보세요."
        )

        return Content(
            summary = summaries[random.nextInt(summaries.size)],
            pros = pickN(random, prosList, 3),
            cons = pickN(random, consList, 2), // Cons usually minimal for fun
            advice = adviceList[random.nextInt(adviceList.size)]
        )
    }

    private fun generateMarriageContent(random: Random, p1: String, p2: String): Content {
        val summaries = listOf(
            "결혼을 전제로 하기에 매우 안정적인 궁합입니다.",
            "서로 협력하여 가정을 이루기에 좋은 파트너입니다.",
            "현실적인 문제들을 함께 해결해 나갈 수 있는 단단한 관계입니다."
        )
        val prosList = listOf(
            "자녀 교육관이 일치합니다.", "재정 관리가 투명합니다.", "양가 부모님과의 관계가 원만합니다.",
            "가사 분담이 조화롭습니다."
        )
        val consList = listOf(
            "생활 습관의 차이가 있을 수 있습니다.", "육아 방식에서 이견이 생길 수 있습니다."
        )
        
        return Content(
            summary = summaries[random.nextInt(summaries.size)],
            pros = pickN(random, prosList, 3),
            cons = pickN(random, consList, 2),
            advice = "부부 사이에는 솔직함이 최선의 무기입니다."
        )
    }

    private fun generateBusinessContent(random: Random, p1: String, p2: String): Content {
         val summaries = listOf(
            "비즈니스 파트너로서 시너지가 기대되는 조합입니다.",
            "서로의 단점을 보완해줄 수 있는 전략적 제휴가 가능합니다.",
            "함께 일하면 1+1이 3이 되는 놀라운 성과를 낼 수 있습니다."
        )
         val prosList = listOf(
            "추진력이 뛰어납니다.", "아이디어 회의가 즐겁습니다.", "책임감이 강합니다.", "목표 의식이 뚜렷합니다."
        )
         val consList = listOf(
            "수익 배분에서 명확한 합의가 필요합니다.", "의사 결정 속도가 다를 수 있습니다."
        )
        
         return Content(
            summary = summaries[random.nextInt(summaries.size)],
            pros = pickN(random, prosList, 3),
            cons = pickN(random, consList, 2),
            advice = "계약서나 합의사항을 문서화하는 것이 좋습니다."
        )
    }

    private fun pickN(random: Random, list: List<String>, n: Int): List<String> {
        return list.shuffled(random).take(n)
    }

    data class Content(val summary: String, val pros: List<String>, val cons: List<String>, val advice: String)
}
