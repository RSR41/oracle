import 'dart:math';
import 'dream_interpreter.dart';

/// Mock implementation of DreamInterpreter for MVP.
/// Generates plausible dream interpretation results locally.
class MockDreamInterpreter implements DreamInterpreter {
  final _random = Random();

  // Korean dream interpretation templates
  static const _summaries = [
    '이 꿈은 새로운 시작과 변화를 암시합니다.',
    '현재의 감정 상태가 꿈에 반영되었습니다.',
    '무의식 속 욕구가 상징적으로 나타났습니다.',
    '가까운 미래에 좋은 소식이 있을 징조입니다.',
    '내면의 불안이 꿈으로 표현되었습니다.',
    '잠재된 능력을 발휘할 때가 왔다는 메시지입니다.',
  ];

  static const _detailTemplates = [
    '꿈에서 등장한 요소들은 당신의 현실 생활과 밀접한 연관이 있습니다. '
        '특히 주요 상징물들은 최근 겪고 있는 상황이나 감정을 반영합니다. '
        '이 꿈은 무의식이 보내는 중요한 메시지로, 현재 상황을 돌아보는 것이 좋겠습니다.',

    '꿈의 전개 방식은 당신의 문제 해결 방식을 보여줍니다. '
        '등장인물이나 장소는 과거의 경험이나 미래에 대한 기대를 상징합니다. '
        '긍정적인 결말은 좋은 결과를 예고하는 길몽입니다.',

    '이 꿈은 심리적 성장의 과정을 나타냅니다. '
        '어려움을 극복하는 장면이 있다면, 현실에서도 비슷한 성취가 있을 것입니다. '
        '꿈속의 감정은 현재 필요한 것이 무엇인지 알려주는 단서입니다.',
  ];

  static const _keywordPool = [
    '행운',
    '사랑',
    '성공',
    '변화',
    '성장',
    '치유',
    '발견',
    '기회',
    '관계',
    '재물',
    '건강',
    '여행',
    '새출발',
    '자아실현',
    '소통',
    '화해',
    '승진',
    '합격',
    '만남',
    '축복',
  ];

  static const _adviceTemplates = [
    '오늘은 새로운 도전을 시작하기 좋은 날입니다. 두려워하지 마세요.',
    '주변 사람들에게 마음을 열어보세요. 뜻밖의 도움을 받을 수 있습니다.',
    '작은 것에 감사하는 마음으로 하루를 시작해보세요.',
    '지금 고민하는 일은 시간이 해결해줄 것입니다. 조급해하지 마세요.',
    '직감을 믿으세요. 당신의 결정이 옳을 가능성이 높습니다.',
    '건강에 특별히 신경 쓰시고, 충분한 휴식을 취하세요.',
  ];

  @override
  Future<DreamResult> interpret(String dreamContent) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Generate random but consistent results
    final summaryIndex = _random.nextInt(_summaries.length);
    final detailIndex = _random.nextInt(_detailTemplates.length);
    final adviceIndex = _random.nextInt(_adviceTemplates.length);

    // Pick 3-5 random keywords
    final keywordCount = 3 + _random.nextInt(3);
    final shuffledKeywords = List<String>.from(_keywordPool)..shuffle(_random);
    final selectedKeywords = shuffledKeywords.take(keywordCount).toList();

    // Generate luck score (50-100)
    final luckScore = 50 + _random.nextInt(51);

    return DreamResult(
      summary: _summaries[summaryIndex],
      details: _detailTemplates[detailIndex],
      keywords: selectedKeywords,
      advice: _adviceTemplates[adviceIndex],
      luckScore: luckScore,
    );
  }
}
