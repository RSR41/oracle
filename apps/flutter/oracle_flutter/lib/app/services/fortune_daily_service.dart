import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

class DailyFortuneData {
  const DailyFortuneData({
    required this.overall,
    required this.love,
    required this.money,
    required this.health,
    required this.work,
    required this.message,
    required this.luckyColor,
    required this.luckyNumber,
    required this.luckyTime,
    required this.loveText,
    required this.moneyText,
    required this.healthText,
    required this.workText,
    required this.seasonalFlow,
    required this.riskFactor,
    required this.actionPlan,
    required this.relationshipAdvice,
    required this.workAdvice,
    required this.moneyAdvice,
  });

  final int overall;
  final int love;
  final int money;
  final int health;
  final int work;
  final String message;
  final String luckyColor;
  final int luckyNumber;
  final String luckyTime;
  final String loveText;
  final String moneyText;
  final String healthText;
  final String workText;
  final String seasonalFlow;
  final String riskFactor;
  final String actionPlan;
  final String relationshipAdvice;
  final String workAdvice;
  final String moneyAdvice;
}

class FortuneDailyService {
  static List<Map<String, dynamic>>? _cache;

  // ── 다채로운 행운 데이터 풀 ──

  static const List<String> _luckyColors = [
    '에메랄드',
    '코랄',
    '로즈골드',
    '민트',
    '라벤더',
    '터콰이즈',
    '버건디',
    '피치',
    '차콜',
    '골드',
    '실버',
    '네이비',
    '아이보리',
    '베이지',
    '카키',
    '올리브',
    '스카이블루',
    '크림',
    '브라운',
    '화이트',
    '블랙',
    '그레이',
    '오렌지',
    '인디고',
    '샌드',
    '마젠타',
    '루비',
    '사파이어',
    '자수정',
    '진주',
  ];

  static const List<String> _luckyTimes = [
    '오전 5-7시 (묘시)',
    '오전 7-9시 (진시)',
    '오전 9-11시 (사시)',
    '오전 11시-오후 1시 (오시)',
    '오후 1-3시 (미시)',
    '오후 3-5시 (신시)',
    '오후 5-7시 (유시)',
    '오후 7-9시 (술시)',
    '오후 9-11시 (해시)',
    '오후 11시-오전 1시 (자시)',
    '오전 1-3시 (축시)',
    '오전 3-5시 (인시)',
  ];

  static const List<String> _messages = [
    '작은 실행이 큰 변화를 만듭니다. 오늘 한 가지를 반드시 시작하세요.',
    '주변 사람들에게 감사를 표현하면 뜻밖의 행운이 찾아옵니다.',
    '직관을 믿으세요. 오늘은 감각이 예리한 날입니다.',
    '새로운 도전에 용기를 내세요. 결과가 기대 이상일 수 있습니다.',
    '여유를 가지세요. 급할수록 돌아가는 것이 지름길입니다.',
    '오늘은 기존 관계를 돌보는 데 에너지를 쓰면 좋습니다.',
    '디테일에 집중하세요. 작은 차이가 큰 결과를 만듭니다.',
    '과감한 결단이 필요한 날입니다. 망설이지 마세요.',
    '건강이 모든 것의 기반입니다. 오늘 운동을 빠뜨리지 마세요.',
    '학습하는 태도가 성장의 열쇠입니다. 새로운 것을 배워보세요.',
    '재정 점검의 날입니다. 지출 패턴을 한번 살펴보세요.',
    '인내심을 발휘하세요. 지금의 기다림이 미래의 자산이 됩니다.',
    '오늘의 만남 한 사람이 인생의 전환점이 될 수 있습니다.',
    '감정을 다스리면 상황이 자연스럽게 풀립니다.',
    '핵심에 집중하면 복잡한 문제도 단순해집니다.',
    '변화를 두려워하지 마세요. 모든 변화 속에 기회가 있습니다.',
    '체력이 곧 경쟁력입니다. 컨디션 관리에 최선을 다하세요.',
    '오늘은 계획보다 실행에 더 무게를 두세요.',
    '겸손한 태도가 주변의 도움을 이끌어냅니다.',
    '자신만의 페이스를 유지하세요. 남과 비교하지 마세요.',
    '어제의 실수에 연연하지 마세요. 오늘은 새로운 기회입니다.',
    '작은 약속도 반드시 지키세요. 신뢰가 운을 만듭니다.',
    '집중 시간을 확보하세요. 30분의 몰입이 3시간의 분산보다 낫습니다.',
    '옷차림에 신경 쓰면 자신감이 올라가는 날입니다.',
    '물을 많이 마시세요. 오늘 수분 섭취가 건강운의 핵심입니다.',
    '정리정돈이 기운을 바꿉니다. 주변 환경을 깨끗이 하세요.',
    '감사 일기를 쓰면 내일의 운이 더 좋아집니다.',
    '오늘은 혼자보다 함께할 때 더 좋은 결과가 나옵니다.',
    '아침 루틴이 하루를 결정합니다. 첫 1시간을 소중히 쓰세요.',
    '꿈을 크게 가지되 행동은 구체적으로 하세요.',
  ];

  static const List<String> _seasonalFlows = [
    '상승',
    '유지',
    '정비',
    '전환',
    '안정',
    '도약',
    '수렴',
    '확장',
  ];

  static const List<String> _riskFactors = [
    '과도한 멀티태스킹',
    '불필요한 비교',
    '수면 부족',
    '충동 소비',
    '감정적 급결정',
    '완벽주의',
    '우유부단',
    '과식 또는 음주',
    '대인 갈등',
    '건강 방치',
    '과로',
    '정보 과부하',
    '약속 불이행',
    '무리한 일정',
    '자기 비하',
    '과도한 기대',
  ];

  static const List<String> _actionPlans = [
    '오전에 핵심 업무 1가지를 먼저 끝내세요.',
    '중요한 대화는 오후 시간에 배치하면 유리합니다.',
    '하루 10분 명상으로 집중력을 높이세요.',
    '잠들기 전 다음 날 할 일 3가지를 적어두세요.',
    '점심 후 15분 산책이 오후 에너지를 높여줍니다.',
    'SNS 사용을 1시간 줄이면 생산성이 크게 올라갑니다.',
    '어려운 일은 체력이 좋은 오전에 처리하세요.',
    '식사 후 결정은 판단력이 올라갑니다. 공복 결정은 피하세요.',
    '주간 계획을 일요일 저녁에 세우면 효율이 높아집니다.',
    '가장 중요한 3가지만 리스트업하고 나머지는 내려놓으세요.',
    '업무 이메일은 하루 3번만 확인하면 집중력이 올라갑니다.',
    '타인의 부탁에 정중히 거절하는 연습도 필요합니다.',
  ];

  static const List<String> _relAdvices = [
    '관계에서는 명확한 표현이 핵심입니다.',
    '먼저 연락하는 것이 관계의 온도를 높입니다.',
    '경청이 최고의 사랑 표현입니다.',
    '서로의 공간을 존중하면 관계가 깊어집니다.',
    '작은 배려가 큰 감동을 줍니다.',
    '약속을 지키는 것이 신뢰의 기반입니다.',
    '진심 어린 칭찬 한마디가 관계를 변화시킵니다.',
    '갈등이 생기면 24시간 후에 대화하세요. 감정이 가라앉습니다.',
    '함께하는 시간의 질이 양보다 중요합니다.',
    '상대의 장점에 집중하면 관계가 더 풍요로워집니다.',
  ];

  static const List<String> _workAdvices = [
    '우선순위 고정 전략이 효과적입니다.',
    '마감 역산으로 일정을 관리하세요.',
    '중간 점검 습관이 큰 실수를 방지합니다.',
    '집중 시간 2시간 확보가 하루 생산성을 좌우합니다.',
    '문서화 습관이 전문성을 보여줍니다.',
    '피드백을 적극 수용하면 성장이 빨라집니다.',
    '보고의 타이밍이 평가를 결정합니다.',
    '동료에게 도움을 요청하는 것도 실력입니다.',
    '업무 일지를 쓰면 성장 속도가 2배가 됩니다.',
    '퇴근 후 완전한 휴식이 내일의 성과를 만듭니다.',
  ];

  static const List<String> _moneyAdvices = [
    '소액 누수를 차단하면 월 10만원 이상 절약됩니다.',
    '목표별 통장 분리가 저축의 핵심입니다.',
    '고정비를 분기별로 점검하세요.',
    '자동이체 적금으로 강제 저축을 시작하세요.',
    '충동 구매 24시간 룰: 하루 지나고도 필요하면 사세요.',
    '월간 지출 보고서를 스스로에게 작성하면 재정이 투명해집니다.',
    '비상 자금 3개월분을 확보하는 것이 1순위입니다.',
    '포인트와 마일리지를 적극 활용하세요.',
    '구독 서비스를 점검하고 안 쓰는 것은 즉시 해지하세요.',
    '수입이 들어오면 먼저 저축하고 나머지로 소비하세요.',
  ];

  // 종합 운세 상세 해석 (점수대별)
  static const Map<String, List<String>> _overallInterpretations = {
    'excellent': [
      // 85-100
      '오늘은 모든 분야에서 빛나는 최고의 날입니다. 중요한 결정이나 새로운 시작에 매우 유리합니다. 자신감을 가지고 적극적으로 행동하세요.',
      '에너지가 최고조에 달하는 날입니다. 주변 사람들과의 시너지가 강해지며, 협업을 통해 놀라운 결과를 만들어낼 수 있습니다.',
      '행운의 기운이 강하게 작용하는 날입니다. 평소 망설이던 일을 시작하기에 최적의 시기이며, 의외의 좋은 소식이 찾아올 수 있습니다.',
      '직관과 판단력이 모두 뛰어난 날입니다. 복직한 문제도 명쾌하게 풀어낼 수 있으며, 주변의 신뢰를 얻는 기회가 됩니다.',
    ],
    'good': [
      // 70-84
      '전반적으로 안정적이고 긍정적인 하루입니다. 계획한 일들이 순조롭게 진행되며, 작은 행운들이 곳곳에서 도움을 줍니다.',
      '꾸준한 노력이 빛을 발하는 날입니다. 인간관계에서도 따뜻한 교류가 있으며, 마음의 여유를 느낄 수 있습니다.',
      '성실한 태도가 좋은 결과로 이어지는 날입니다. 급하게 서두르지 않고 차분히 임하면 기대 이상의 성과를 얻을 수 있습니다.',
      '하루의 리듬이 잘 맞아가는 날입니다. 오전에 중요한 일을 처리하면 오후가 여유로워지며, 자기 관리에도 좋은 시간입니다.',
    ],
    'average': [
      // 55-69
      '평범하지만 의미 있는 하루입니다. 큰 변화보다는 내면의 성장에 집중하면 좋으며, 작은 것에서 기쁨을 찾는 연습이 도움됩니다.',
      '무난한 하루이지만 방심은 금물입니다. 기본에 충실하고 주변을 돌아보면 예상치 못한 기회를 발견할 수 있습니다.',
      '하루의 흐름이 느린 편이지만 조급해하지 마세요. 준비하는 시간이라 생각하고 내일을 위한 계획을 세우면 유익합니다.',
      '에너지를 분산시키지 말고 한 가지에 집중하면 좋은 결과를 얻을 수 있는 날입니다. 멀티태스킹보다 집중이 필요합니다.',
    ],
    'caution': [
      // 40-54
      '주의가 필요한 하루입니다. 중요한 결정은 내일로 미루고, 체력 관리와 감정 조절에 신경 쓰면 무난하게 넘길 수 있습니다.',
      '예상치 못한 장애물이 나타날 수 있는 날입니다. 유연하게 대처하고 무리한 약속은 피하는 것이 현명합니다.',
      '컨디션이 평소보다 낮을 수 있습니다. 충분한 휴식을 취하고 무리하지 않으면 내일은 한결 나아질 것입니다.',
      '인간관계에서 오해가 생기기 쉬운 날입니다. 말 한마디에 신중을 기하고, 문자보다 직접 대화를 선택하세요.',
    ],
  };

  // 점수대별 해석 선택을 위한 deterministic seed 기반 인덱스 생성
  int _seededIndex(int seed, int listLength) {
    return ((seed * 2654435761) >> 16) % listLength;
  }

  Future<DailyFortuneData> getFortune(DateTime date) async {
    final patterns = await _loadPatterns();
    final daySeed = date.year * 10000 + date.month * 100 + date.day;

    // 다중 시드로 패턴 선택 다양화
    final patternIdx = daySeed % patterns.length;
    final pattern = patterns[patternIdx];
    final result = Map<String, dynamic>.from(pattern['result'] as Map);

    // 날짜 기반 다양한 시드로 각 항목을 독립적으로 선택
    final colorSeed = daySeed * 7 + 13;
    final timeSeed = daySeed * 11 + 29;
    final numSeed = daySeed * 13 + 37;
    final msgSeed = daySeed * 17 + 41;
    final flowSeed = daySeed * 19 + 43;
    final riskSeed = daySeed * 23 + 47;
    final actionSeed = daySeed * 29 + 53;
    final relSeed = daySeed * 31 + 59;
    final workSeed = daySeed * 37 + 61;
    final moneySeed = daySeed * 41 + 67;

    // 행운의 색상 - 2개를 독립적으로 선택
    final color1 = _luckyColors[_seededIndex(colorSeed, _luckyColors.length)];
    final color2 =
        _luckyColors[_seededIndex(colorSeed + 1, _luckyColors.length)];
    final luckyColor = color1 == color2 ? color1 : '$color1, $color2';

    // 행운의 숫자 - 1~45 범위에서 독립적으로 선택
    final num1 = _seededIndex(numSeed, 45) + 1;
    final num2 = _seededIndex(numSeed + 7, 45) + 1;
    final luckyNumber = num1 == num2 ? num1 : min(num1, num2);

    // 행운의 시간 - 12시진 중 선택
    final luckyTime = _luckyTimes[_seededIndex(timeSeed, _luckyTimes.length)];

    // 종합 메시지 (패턴의 것 또는 풀에서 독립 선택)
    final message = _messages[_seededIndex(msgSeed, _messages.length)];

    // 점수들 - 패턴 기반 + 날짜별 변동
    final baseOverall = result['overallScore'] as int;
    final variation = (_seededIndex(daySeed, 21) - 10); // -10 ~ +10
    final overall = _clamp(baseOverall + variation);
    final love = _clamp(
      (result['loveScore'] as int) + _seededIndex(daySeed * 3, 15) - 7,
    );
    final money = _clamp(
      (result['moneyScore'] as int) + _seededIndex(daySeed * 5, 15) - 7,
    );
    final health = _clamp(
      (result['healthScore'] as int) + _seededIndex(daySeed * 7, 15) - 7,
    );
    final work = _clamp(
      (result['workScore'] as int) + _seededIndex(daySeed * 9, 15) - 7,
    );

    // 종합 운세 해석 (점수대에 따라 다른 풀에서 선택)
    final String overallCategory;
    if (overall >= 85) {
      overallCategory = 'excellent';
    } else if (overall >= 70) {
      overallCategory = 'good';
    } else if (overall >= 55) {
      overallCategory = 'average';
    } else {
      overallCategory = 'caution';
    }
    final interpretations = _overallInterpretations[overallCategory]!;
    final overallInterpretation =
        interpretations[_seededIndex(daySeed, interpretations.length)];
    final fullMessage = '$message\n\n$overallInterpretation';

    return DailyFortuneData(
      overall: overall,
      love: love,
      money: money,
      health: health,
      work: work,
      message: fullMessage,
      luckyColor: luckyColor,
      luckyNumber: luckyNumber,
      luckyTime: luckyTime,
      loveText: '애정운: ${result['personality']}',
      moneyText: '재물운: ${result['wealth']}',
      healthText: '건강운: ${result['health']}',
      workText: '직장/학업운: ${result['career']}',
      seasonalFlow:
          _seasonalFlows[_seededIndex(flowSeed, _seasonalFlows.length)],
      riskFactor: _riskFactors[_seededIndex(riskSeed, _riskFactors.length)],
      actionPlan: _actionPlans[_seededIndex(actionSeed, _actionPlans.length)],
      relationshipAdvice:
          _relAdvices[_seededIndex(relSeed, _relAdvices.length)],
      workAdvice: _workAdvices[_seededIndex(workSeed, _workAdvices.length)],
      moneyAdvice: _moneyAdvices[_seededIndex(moneySeed, _moneyAdvices.length)],
    );
  }

  Future<List<Map<String, dynamic>>> _loadPatterns() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString('assets/data/saju_patterns.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    _cache = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return _cache!;
  }

  int _clamp(int score) => score.clamp(40, 100);
}
