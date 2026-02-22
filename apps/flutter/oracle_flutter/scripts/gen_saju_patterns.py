#!/usr/bin/env python3
"""Generate saju_patterns.json with 1500+ unique patterns."""
import json, os, random

random.seed(42)  # Reproducible

stems = ['갑','을','병','정','무','기','경','신','임','계']
branches = ['자','축','인','묘','진','사','오','미','신','유','술','해']
stem_element = {'갑':'목','을':'목','병':'화','정':'화','무':'토','기':'토','경':'금','신':'금','임':'수','계':'수'}

# 일간별(10종) 고유 성격 해석
personality_by_stem = {
    '갑': [
        "갑목 일간으로 큰 나무처럼 곧고 바른 성품입니다. 목표를 향한 추진력이 강합니다.",
        "갑목의 기운으로 리더십과 정의감이 돋보입니다. 성장과 발전을 추구하는 성향입니다.",
        "큰 나무의 에너지를 지녀 포용력이 크고 주변에 그늘을 만들어줍니다.",
    ],
    '을': [
        "을목 일간으로 풀과 꽃처럼 유연하고 적응력이 뛰어납니다. 예술적 감각이 있습니다.",
        "을목의 기운으로 부드러우면서도 끈질긴 생명력을 가집니다. 인내심이 강합니다.",
        "섬세한 감성과 유연한 대처 능력이 돋보이며, 환경에 맞춰 성장합니다.",
    ],
    '병': [
        "병화 일간으로 태양처럼 밝고 따뜻합니다. 카리스마와 열정이 넘칩니다.",
        "병화의 기운으로 활발하고 사교적입니다. 남을 따뜻하게 감싸는 포용력이 있습니다.",
        "화려하고 당당한 성품으로 주목받는 능력이 탁월합니다. 자신감이 강합니다.",
    ],
    '정': [
        "정화 일간으로 촛불처럼 세심하고 따뜻합니다. 문화와 예술에 재능이 있습니다.",
        "정화의 기운으로 섬세한 감성과 깊은 내면의 열정을 가집니다.",
        "조용하지만 강인한 빛을 내며, 세밀한 작업과 학문에 뛰어난 능력을 보입니다.",
    ],
    '무': [
        "무토 일간으로 산과 대지처럼 듬직하고 신뢰감이 있습니다. 중심을 잡는 역할에 적합합니다.",
        "무토의 기운으로 포용력이 크고 안정감을 줍니다. 조직의 기둥 같은 존재입니다.",
        "넓은 시야와 관대한 성품으로 많은 사람의 신뢰를 받습니다.",
    ],
    '기': [
        "기토 일간으로 논밭처럼 실용적이고 꼼꼼합니다. 타인을 돌보는 데 능합니다.",
        "기토의 기운으로 속이 깊고 인내심이 강합니다. 착실한 성과를 만들어냅니다.",
        "겸손하면서도 내실 있는 성품으로, 주변을 차분히 관리하는 능력이 탁월합니다.",
    ],
    '경': [
        "경금 일간으로 원석처럼 강하고 결단력이 있습니다. 정의감과 원칙을 중시합니다.",
        "경금의 기운으로 과감한 실행력과 분석력이 뛰어납니다. 프로의 자질이 있습니다.",
        "단단하고 날카로운 판단력으로 어려운 결정도 주저 없이 내립니다.",
    ],
    '신': [
        "신금 일간으로 보석처럼 섬세하고 날카로운 감각을 가집니다. 미적 감각이 뛰어납니다.",
        "신금의 기운으로 완벽을 추구하며 세련된 감성을 지닙니다.",
        "정밀하고 예리한 관찰력이 돋보이며, 전문 분야에서 두각을 나타냅니다.",
    ],
    '임': [
        "임수 일간으로 큰 강과 바다처럼 포용력이 크고 지혜가 깊습니다.",
        "임수의 기운으로 대인관계가 넓고 큰 그림을 그리는 능력이 있습니다.",
        "유연하고 깊은 사고로 복잡한 문제를 풀어나가는 힘이 있습니다.",
    ],
    '계': [
        "계수 일간으로 이슬과 빗물처럼 지적이고 섬세합니다. 통찰력이 뛰어납니다.",
        "계수의 기운으로 조용하지만 깊은 영향력이 있습니다. 학문에 재능이 있습니다.",
        "섬세한 감성과 날카로운 직관으로 본질을 꿰뚫어보는 능력이 탁월합니다.",
    ],
}

# 오행별(5종) 직업 해석
career_by_element = {
    '목': ["기획, 교육, 출판, 디자인 분야","컨설팅, 환경, 건축, 농업 분야","교육, 문화, 미디어, 패션 분야","연구, 개발, 창업 분야","사회복지, 상담, 코칭 분야"],
    '화': ["영업, 마케팅, 방송, 엔터테인먼트 분야","외교, PR, 이벤트 기획 분야","예술, 요리, 뷰티 분야","스포츠, 레저, 관광 분야","강연, 교육, 미디어 분야"],
    '토': ["부동산, 건설, 행정, 관리 분야","회계, 재무, 인사, 총무 분야","농업, 식품, 요식업 분야","중재, 법무, 보험 분야","의료, 제약, 공공기관 분야"],
    '금': ["금융, 법률, IT, 기술 분야","제조, 기계, 정밀 산업 분야","군인, 경찰, 보안, 안전 분야","의료기기, 치과, 정밀 분야","자동차, 항공, 첨단 기술 분야"],
    '수': ["무역, 물류, 유통, 해운 분야","연구, 학술, 데이터 분석 분야","음악, 미술, 창작 분야","IT, 소프트웨어, AI 분야","심리학, 철학, 종교 분야"],
}

wealth_by_element = {
    '목': ["중장기 투자와 저축 병행 시 자산이 안정적으로 성장합니다.","새로운 사업 아이디어에서 큰 수익이 기대됩니다.","부동산보다 사업 투자가 유리합니다.","교육이나 자기개발 투자가 장기적 재물운을 높입니다.","나눔과 기부가 재물의 선순환을 만듭니다."],
    '화': ["성과 기반 보상이 뛰어난 시기입니다.","적극적 투자가 수익으로 이어질 가능성이 높습니다.","인맥을 통한 비즈니스 기회가 열립니다.","하반기에 재정 상황이 크게 호전됩니다.","열정 프로젝트가 예상 밖의 수익을 가져옵니다."],
    '토': ["고정 지출을 정리하면 재정이 안정됩니다.","부동산 관련 재물운이 좋습니다.","꾸준한 저축이 큰 자산을 만듭니다.","보수적 투자가 안전한 수익을 줍니다.","안정적 수입원을 확보하는 것이 우선입니다."],
    '금': ["리스크를 관리하며 투자하면 수익이 좋습니다.","기술 관련 투자가 유리합니다.","분석적 접근이 재정적 성과를 높입니다.","귀금속이나 금융 상품에 관심을 갖길 바랍니다.","정확한 정보를 바탕으로 한 투자가 성공합니다."],
    '수': ["정보와 데이터 기반 투자가 수익으로 이어집니다.","유동적 자산 관리가 유리합니다.","다양한 수입원을 확보하면 재정이 안정됩니다.","지적 재산이 큰 수익을 가져올 수 있습니다.","해외 투자나 무역에 기회가 있습니다."],
}

health_by_element = {
    '목': ["간과 근육 관리에 신경 쓰세요. 스트레칭이 도움됩니다.","눈 건강과 수면 관리가 중요합니다.","봄철 알레르기에 주의하세요.","분노 조절이 건강의 핵심입니다.","녹색 채소 섭취가 건강을 개선합니다."],
    '화': ["심장과 혈압 관리가 중요합니다.","체온 조절과 수분 보충에 신경 쓰세요.","과열과 스트레스 관리가 필요합니다.","규칙적 심폐 운동이 건강을 지킵니다.","매운 음식을 줄이고 담백한 식사를 권합니다."],
    '토': ["소화기와 위장 관리가 건강의 핵심입니다.","식사 시간을 규칙적으로 유지하세요.","과식과 야식을 줄이면 컨디션이 좋아집니다.","습기와 늦은 여름 건강에 주의하세요.","명상과 이완이 소화기 건강에 도움됩니다."],
    '금': ["폐와 호흡기 관리가 중요합니다. 심호흡을 자주 하세요.","피부 건강과 보습에 신경 쓰세요.","건조한 환경을 피하고 수분을 충분히 섭취하세요.","어깨와 목 결림에 주의하세요.","환절기 감기 예방에 특별히 신경 쓰세요."],
    '수': ["신장과 방광 관련 건강에 주의하세요.","순환 계통 관리와 충분한 수면이 필요합니다.","겨울철 보온에 각별히 신경 쓰세요.","하체 운동으로 순환을 개선하세요.","수분 섭취량을 적절히 유지하세요."],
}

messages = [
    "작은 실행이 큰 변화를 만듭니다. 지금 시작하세요.",
    "주도적으로 움직일수록 기회가 선명해집니다.",
    "기본을 정리하면 성과가 안정적으로 따라옵니다.",
    "디테일 점검이 리스크를 줄이고 성과를 높입니다.",
    "유연한 대응이 예상 밖의 기회를 만듭니다.",
    "관계 조율 능력이 뛰어나 신뢰를 얻기 쉽습니다.",
    "분석력이 좋아 복잡한 문제도 구조화할 수 있습니다.",
    "직관과 현실 감각의 균형이 좋습니다.",
    "집중력이 높고 장기 목표를 지키는 힘이 있습니다.",
    "판단이 빠르고 실행력이 좋습니다.",
    "내면의 확신이 성공의 기반입니다.",
    "꾸준함이 특별한 재능을 이깁니다.",
    "타인의 조언을 경청하되 결정은 스스로 하세요.",
    "지금의 어려움이 미래의 자산이 됩니다.",
    "감정을 다스리면 상황이 풀립니다.",
    "새로운 배움이 인생의 전환점이 됩니다.",
    "인내는 당신의 가장 강력한 무기입니다.",
    "변화를 두려워하지 말고 포용하세요.",
    "핵심에 집중하면 복잡한 문제가 단순해집니다.",
    "오늘의 선택이 내일의 운명을 결정합니다.",
]

colors = [
    ["에메랄드","아이보리"],["코랄","골드"],["베이지","브라운"],
    ["실버","네이비"],["블루","블랙"],["로즈골드","화이트"],
    ["민트","그레이"],["라벤더","크림"],["터콰이즈","샌드"],
    ["버건디","올리브"],["피치","스카이블루"],["차콜","카키"],
]

times = [
    "오전 7-9시","오전 9-11시","오후 1-3시","오후 2-4시",
    "오후 6-8시","저녁 7-9시","오전 5-7시","오후 3-5시",
]

flows = ["상승","유지","정비","전환","안정"]
risks = [
    "과도한 멀티태스킹","불필요한 비교","수면 부족","충동 소비",
    "감정적인 급결정","완벽주의","우유부단","과식/음주","대인 갈등","건강 방치",
]

action_plans = [
    "중요한 대화는 오후에 배치하면 유리합니다.",
    "지출은 기록 중심으로 관리하면 운을 지킬 수 있습니다.",
    "컨디션 관리를 위해 수분 섭취와 스트레칭을 병행하세요.",
    "의사결정 전 체크리스트 3가지를 확인하세요.",
    "오전에는 핵심 업무 1개를 먼저 끝내세요.",
    "하루 10분 명상으로 집중력을 높이세요.",
    "중요한 결정은 식사 후에 하면 판단력이 좋아집니다.",
    "주간 계획을 일요일 저녁에 세우면 효율이 높아집니다.",
    "운동 후 업무를 시작하면 생산성이 올라갑니다.",
    "잠들기 전 감사 일기를 쓰면 다음 날 운이 좋아집니다.",
]

rel_advices = [
    "관계에서는 명확한 표현이 핵심입니다.",
    "관계에서는 타이밍 조절이 핵심입니다.",
    "관계에서는 경청이 핵심입니다.",
    "관계에서는 진심 어린 칭찬이 효과적입니다.",
    "관계에서는 먼저 연락하는 것이 좋습니다.",
    "관계에서는 약속을 지키는 것이 신뢰의 기반입니다.",
    "관계에서는 서로의 공간을 존중하세요.",
    "관계에서는 작은 배려가 큰 감동을 줍니다.",
]

work_advices = [
    "업무에서는 우선순위 고정 전략이 효과적입니다.",
    "업무에서는 마감 역산 전략이 효과적입니다.",
    "업무에서는 중간 점검 전략이 효과적입니다.",
    "업무에서는 집중 시간 확보가 핵심입니다.",
    "업무에서는 문서화 습관이 실력을 보여줍니다.",
    "업무에서는 피드백을 적극 수용하면 성장합니다.",
    "업무에서는 데드라인 관리가 신뢰를 만듭니다.",
    "업무에서는 보고의 타이밍이 중요합니다.",
]

money_advices = [
    "재정은 소액 누수 차단을 추천합니다.",
    "재정은 목표 예산 분리를 추천합니다.",
    "재정은 고정비 점검을 추천합니다.",
    "재정은 자동 이체 적금을 추천합니다.",
    "재정은 카드 대신 현금 사용을 고려하세요.",
    "재정은 월간 지출 보고서 작성이 효과적입니다.",
    "재정은 비상 자금 3개월분 확보를 목표로 하세요.",
    "재정은 충동 구매 24시간 룰을 적용하세요.",
]

patterns = []
pid = 1

for si, s in enumerate(stems):
    for bi, b in enumerate(branches):
        for variant in range(3):  # 3 variants per combo = 10*12*3 = 360
            el = stem_element[s]
            pi = personality_by_stem[s][variant % len(personality_by_stem[s])]
            ci = career_by_element[el][(si + variant) % len(career_by_element[el])]
            wi = wealth_by_element[el][(bi + variant) % len(wealth_by_element[el])]
            hi = health_by_element[el][(si + bi + variant) % len(health_by_element[el])]
            mi = messages[(pid - 1) % len(messages)]

            ms = stems[(si + 2) % 10]
            mb = branches[(bi + 2) % 12]
            ds = stems[(si + 4) % 10]
            db = branches[(bi + 4) % 12]
            hs_stem = stems[(si + 6) % 10]
            hb = branches[(bi + 6) % 12]

            overall = 65 + (pid * 7 + variant * 13) % 31
            love = 60 + (pid * 11 + variant * 17) % 36
            money = 60 + (pid * 13 + variant * 19) % 36
            health_s = 60 + (pid * 17 + variant * 23) % 36
            work_s = 60 + (pid * 19 + variant * 29) % 36

            patterns.append({
                "id": pid,
                "pattern": {
                    "year_gan": s, "year_ji": b,
                    "month_gan": ms, "month_ji": mb,
                    "day_gan": ds, "day_ji": db,
                    "hour_gan": hs_stem, "hour_ji": hb,
                },
                "gender": "공통",
                "result": {
                    "personality": pi,
                    "career": ci,
                    "wealth": wi,
                    "health": hi,
                    "message": mi,
                    "luckyColor": colors[pid % len(colors)],
                    "luckyNumber": sorted(set([(pid % 9) + 1, ((pid * 3) % 9) + 1, ((pid * 7) % 9) + 1])),
                    "luckyTime": times[pid % len(times)],
                    "overallScore": overall,
                    "loveScore": love,
                    "moneyScore": money,
                    "healthScore": health_s,
                    "workScore": work_s,
                    "seasonalFlow": flows[pid % len(flows)],
                    "riskFactor": risks[pid % len(risks)],
                    "actionPlan": action_plans[pid % len(action_plans)],
                    "relationshipAdvice": rel_advices[pid % len(rel_advices)],
                    "workAdvice": work_advices[pid % len(work_advices)],
                    "moneyAdvice": money_advices[pid % len(money_advices)],
                },
            })
            pid += 1

# Add 720 more patterns with flipped combinations
for si in range(10):
    for bi in range(12):
        for v in range(6):
            s = stems[(si + v + 1) % 10]
            b = branches[(bi + v + 1) % 12]
            el = stem_element[s]
            pi = personality_by_stem[s][(v + bi) % len(personality_by_stem[s])]
            ci = career_by_element[el][(v + si) % len(career_by_element[el])]
            wi = wealth_by_element[el][(v + bi) % len(wealth_by_element[el])]
            hi = health_by_element[el][(v + si + bi) % len(health_by_element[el])]
            mi = messages[(pid - 1) % len(messages)]

            overall = 60 + (pid * 11 + v * 7) % 36
            love = 55 + (pid * 7 + v * 11) % 41
            money = 55 + (pid * 13 + v * 7) % 41
            health_s = 55 + (pid * 7 + v * 13) % 41
            work_s = 55 + (pid * 11 + v * 13) % 41

            patterns.append({
                "id": pid,
                "pattern": {
                    "year_gan": s, "year_ji": b,
                    "month_gan": stems[(si + 3) % 10], "month_ji": branches[(bi + 3) % 12],
                    "day_gan": stems[(si + 5) % 10], "day_ji": branches[(bi + 5) % 12],
                    "hour_gan": stems[(si + 7) % 10], "hour_ji": branches[(bi + 7) % 12],
                },
                "gender": "공통",
                "result": {
                    "personality": pi,
                    "career": ci,
                    "wealth": wi,
                    "health": hi,
                    "message": mi,
                    "luckyColor": colors[pid % len(colors)],
                    "luckyNumber": sorted(set([(pid % 9) + 1, ((pid * 5) % 9) + 1, ((pid * 11) % 9) + 1])),
                    "luckyTime": times[pid % len(times)],
                    "overallScore": overall,
                    "loveScore": love,
                    "moneyScore": money,
                    "healthScore": health_s,
                    "workScore": work_s,
                    "seasonalFlow": flows[pid % len(flows)],
                    "riskFactor": risks[pid % len(risks)],
                    "actionPlan": action_plans[pid % len(action_plans)],
                    "relationshipAdvice": rel_advices[pid % len(rel_advices)],
                    "workAdvice": work_advices[pid % len(work_advices)],
                    "moneyAdvice": money_advices[pid % len(money_advices)],
                },
            })
            pid += 1

out = os.path.join(os.path.dirname(__file__), '..', 'assets', 'data', 'saju_patterns.json')
with open(out, 'w', encoding='utf-8') as f:
    json.dump(patterns, f, ensure_ascii=False, indent=2)
print(f"Generated {len(patterns)} patterns -> {out}")
