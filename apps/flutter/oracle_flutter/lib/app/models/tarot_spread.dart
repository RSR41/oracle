/// Tarot Spread (카테고리) 모델
/// 7가지 타로 리딩 타입 정의
class TarotSpread {
  final String id;
  final String name;
  final String icon;
  final String description;
  final int cardCount;
  final List<String> positionLabels;
  final String
  adviceField; // loveAdvice, moneyAdvice, healthAdvice, workAdvice, or 'general'

  const TarotSpread({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.cardCount,
    required this.positionLabels,
    this.adviceField = 'general',
  });

  static const List<TarotSpread> all = [
    daily,
    love,
    breakupReunion,
    monthly,
    yesNo,
    pastPresentFuture,
    oracle,
  ];

  // ── 일일 타로 ──
  static const daily = TarotSpread(
    id: 'daily',
    name: '일일 타로',
    icon: '🔮',
    description: '오늘 하루를 위한 메시지를 받아보세요',
    cardCount: 1,
    positionLabels: ['오늘의 메시지'],
  );

  // ── 연애운 타로 ──
  static const love = TarotSpread(
    id: 'love',
    name: '연애운 타로',
    icon: '💕',
    description: '나와 상대의 마음, 관계의 방향을 살펴봅니다',
    cardCount: 3,
    positionLabels: ['나의 마음', '상대의 마음', '관계의 방향'],
    adviceField: 'loveAdvice',
  );

  // ── 이별과 재회 ──
  static const breakupReunion = TarotSpread(
    id: 'breakup',
    name: '이별과 재회',
    icon: '💔',
    description: '이별의 원인과 재회 가능성을 확인합니다',
    cardCount: 3,
    positionLabels: ['이별의 원인', '현재 상황', '재회 가능성'],
    adviceField: 'loveAdvice',
  );

  // ── 월간 타로 ──
  static const monthly = TarotSpread(
    id: 'monthly',
    name: '월간 타로',
    icon: '📅',
    description: '이번 달의 흐름과 전환점을 알아봅니다',
    cardCount: 3,
    positionLabels: ['상반기 흐름', '전환점', '하반기 흐름'],
  );

  // ── 예/아니오 타로 ──
  static const yesNo = TarotSpread(
    id: 'yesno',
    name: '예/아니오 타로',
    icon: '✅',
    description: '간단한 질문에 예 또는 아니오로 답합니다',
    cardCount: 1,
    positionLabels: ['답변'],
  );

  // ── 과거-현재-미래 ──
  static const pastPresentFuture = TarotSpread(
    id: 'timeline',
    name: '과거-현재-미래',
    icon: '🕰️',
    description: '시간의 흐름 속에서 통찰을 얻습니다',
    cardCount: 3,
    positionLabels: ['과거', '현재', '미래'],
  );

  // ── 오라클 타로 ──
  static const oracle = TarotSpread(
    id: 'oracle',
    name: '오라클 타로',
    icon: '🌟',
    description: '5장의 카드로 깊은 통찰을 제공합니다',
    cardCount: 5,
    positionLabels: ['자아', '도전', '조언', '숨겨진 힘', '결과'],
  );
}
