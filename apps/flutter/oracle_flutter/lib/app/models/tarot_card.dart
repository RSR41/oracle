/// Represents a Tarot card with its meaning
class TarotCard {
  final int id;
  final String name;
  final String nameKo;
  final String upright;
  final String uprightKo;
  final String reversed;
  final String reversedKo;
  final String description;
  final String descriptionKo;
  final bool isReversed;

  // Phase 3: 영역별 조언
  final String loveAdvice;
  final String moneyAdvice;
  final String healthAdvice;
  final String workAdvice;

  TarotCard({
    required this.id,
    required this.name,
    required this.nameKo,
    required this.upright,
    required this.uprightKo,
    required this.reversed,
    required this.reversedKo,
    required this.description,
    required this.descriptionKo,
    this.isReversed = false,
    this.loveAdvice = '',
    this.moneyAdvice = '',
    this.healthAdvice = '',
    this.workAdvice = '',
  });

  TarotCard copyWith({bool? isReversed}) {
    return TarotCard(
      id: id,
      name: name,
      nameKo: nameKo,
      upright: upright,
      uprightKo: uprightKo,
      reversed: reversed,
      reversedKo: reversedKo,
      description: description,
      descriptionKo: descriptionKo,
      isReversed: isReversed ?? this.isReversed,
      loveAdvice: loveAdvice,
      moneyAdvice: moneyAdvice,
      healthAdvice: healthAdvice,
      workAdvice: workAdvice,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nameKo': nameKo,
    'upright': upright,
    'uprightKo': uprightKo,
    'reversed': reversed,
    'reversedKo': reversedKo,
    'description': description,
    'descriptionKo': descriptionKo,
    'isReversed': isReversed,
    'loveAdvice': loveAdvice,
    'moneyAdvice': moneyAdvice,
    'healthAdvice': healthAdvice,
    'workAdvice': workAdvice,
  };

  factory TarotCard.fromJson(Map<String, dynamic> json) => TarotCard(
    id: json['id'] as int,
    name: json['name'] as String,
    nameKo: json['nameKo'] as String,
    upright: json['upright'] as String,
    uprightKo: json['uprightKo'] as String,
    reversed: json['reversed'] as String,
    reversedKo: json['reversedKo'] as String,
    description: json['description'] as String,
    descriptionKo: json['descriptionKo'] as String,
    isReversed: json['isReversed'] as bool? ?? false,
    loveAdvice: json['loveAdvice'] as String? ?? '',
    moneyAdvice: json['moneyAdvice'] as String? ?? '',
    healthAdvice: json['healthAdvice'] as String? ?? '',
    workAdvice: json['workAdvice'] as String? ?? '',
  );
}

/// Full 78-card deck is loaded from tarot_cards.json
/// This class provides a fallback deck with Major Arcana only
class TarotDeck {
  static final List<TarotCard> majorArcana = [];
}
