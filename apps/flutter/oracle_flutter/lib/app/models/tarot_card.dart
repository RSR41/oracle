import 'dart:convert';

import 'package:flutter/services.dart';

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
  };

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    int parseId(dynamic rawId, dynamic number) {
      if (number is int) return number;
      if (rawId is int) return rawId;
      if (rawId is String) {
        final parsed = int.tryParse(rawId.split('_').last);
        if (parsed != null) return parsed;
      }
      return 0;
    }

    return TarotCard(
      id: parseId(json['id'], json['number']),
      name: (json['name'] ?? json['nameEn'] ?? '') as String,
      nameKo: (json['nameKo'] ?? '') as String,
      upright: (json['upright'] ?? json['uprightMeaningEn'] ?? '') as String,
      uprightKo:
          (json['uprightKo'] ?? json['uprightMeaningKo'] ?? '') as String,
      reversed:
          (json['reversed'] ?? json['reversedMeaningEn'] ?? '') as String,
      reversedKo:
          (json['reversedKo'] ?? json['reversedMeaningKo'] ?? '') as String,
      description:
          (json['description'] ?? json['uprightMeaningEn'] ?? '') as String,
      descriptionKo:
          (json['descriptionKo'] ?? json['uprightMeaningKo'] ?? '') as String,
      isReversed: json['isReversed'] as bool? ?? false,
    );
  }
}

class TarotDeckLoader {
  static const String _assetPath = 'assets/data/tarot_cards.json';

  static Future<List<TarotCard>> loadDeck() async {
    try {
      final raw = await rootBundle.loadString(_assetPath);
      final decoded = jsonDecode(raw);

      final cardsJson = switch (decoded) {
        List<dynamic> l => l,
        Map<String, dynamic> m => (m['cards'] as List<dynamic>? ?? <dynamic>[]),
        _ => <dynamic>[],
      };

      final cards = cardsJson
          .whereType<Map<String, dynamic>>()
          .map(TarotCard.fromJson)
          .toList();

      if (cards.isEmpty) {
        return List.from(TarotDeck.majorArcana);
      }

      cards.sort((a, b) => a.id.compareTo(b.id));
      return cards;
    } catch (_) {
      return List.from(TarotDeck.majorArcana);
    }
  }
}

/// Major Arcana deck for MVP
class TarotDeck {
  static final List<TarotCard> majorArcana = [
    TarotCard(
      id: 0,
      name: 'The Fool',
      nameKo: '바보',
      upright: 'New beginnings, innocence, adventure',
      uprightKo: '새로운 시작, 순수함, 모험',
      reversed: 'Recklessness, risk-taking, foolishness',
      reversedKo: '무모함, 위험 감수, 어리석음',
      description: 'A fresh start awaits. Trust your instincts.',
      descriptionKo: '새로운 시작이 기다립니다. 본능을 믿으세요.',
    ),
    TarotCard(
      id: 1,
      name: 'The Magician',
      nameKo: '마법사',
      upright: 'Manifestation, resourcefulness, power',
      uprightKo: '창조, 재능 발휘, 힘',
      reversed: 'Manipulation, poor planning, untapped talents',
      reversedKo: '조작, 부실한 계획, 미발휘된 재능',
      description: 'You have all the tools you need to succeed.',
      descriptionKo: '성공에 필요한 모든 도구를 갖추고 있습니다.',
    ),
    TarotCard(
      id: 2,
      name: 'The High Priestess',
      nameKo: '여사제',
      upright: 'Intuition, sacred knowledge, the subconscious',
      uprightKo: '직관, 신성한 지식, 잠재의식',
      reversed: 'Secrets, disconnection, withdrawal',
      reversedKo: '비밀, 단절, 철수',
      description: 'Trust your inner voice and hidden wisdom.',
      descriptionKo: '내면의 목소리와 숨겨진 지혜를 믿으세요.',
    ),
    TarotCard(
      id: 3,
      name: 'The Empress',
      nameKo: '여황제',
      upright: 'Femininity, beauty, nature, nurturing',
      uprightKo: '여성성, 아름다움, 자연, 양육',
      reversed: 'Creative block, dependence on others',
      reversedKo: '창의력 막힘, 타인 의존',
      description: 'Abundance and creativity flow through you.',
      descriptionKo: '풍요와 창의력이 당신을 통해 흐릅니다.',
    ),
    TarotCard(
      id: 4,
      name: 'The Emperor',
      nameKo: '황제',
      upright: 'Authority, structure, control, fatherhood',
      uprightKo: '권위, 구조, 통제, 아버지',
      reversed: 'Tyranny, rigidity, coldness',
      reversedKo: '폭정, 경직, 냉담',
      description: 'Take charge and lead with confidence.',
      descriptionKo: '자신감을 갖고 주도하세요.',
    ),
    TarotCard(
      id: 5,
      name: 'The Hierophant',
      nameKo: '교황',
      upright: 'Tradition, conformity, morality, ethics',
      uprightKo: '전통, 순응, 도덕, 윤리',
      reversed: 'Rebellion, subversiveness, new approaches',
      reversedKo: '반항, 전복, 새로운 접근',
      description: 'Seek wisdom from trusted mentors.',
      descriptionKo: '신뢰할 수 있는 멘토에게 지혜를 구하세요.',
    ),
    TarotCard(
      id: 6,
      name: 'The Lovers',
      nameKo: '연인',
      upright: 'Love, harmony, relationships, values alignment',
      uprightKo: '사랑, 조화, 관계, 가치 일치',
      reversed: 'Self-love, disharmony, imbalance',
      reversedKo: '자기 사랑, 불화, 불균형',
      description: 'A meaningful connection or choice awaits.',
      descriptionKo: '의미 있는 인연이나 선택이 기다립니다.',
    ),
    TarotCard(
      id: 7,
      name: 'The Chariot',
      nameKo: '전차',
      upright: 'Control, willpower, success, determination',
      uprightKo: '통제, 의지력, 성공, 결단',
      reversed: 'Self-discipline, opposition, lack of direction',
      reversedKo: '자기 훈련, 반대, 방향 상실',
      description: 'Victory comes through focused determination.',
      descriptionKo: '집중된 결의를 통해 승리가 옵니다.',
    ),
    TarotCard(
      id: 8,
      name: 'Strength',
      nameKo: '힘',
      upright: 'Strength, courage, persuasion, influence',
      uprightKo: '힘, 용기, 설득, 영향력',
      reversed: 'Inner strength, self-doubt, low energy',
      reversedKo: '내면의 힘, 자기 의심, 저에너지',
      description: 'Inner courage will see you through.',
      descriptionKo: '내면의 용기가 난관을 극복하게 해줍니다.',
    ),
    TarotCard(
      id: 9,
      name: 'The Hermit',
      nameKo: '은둔자',
      upright: 'Soul-searching, introspection, being alone',
      uprightKo: '자아 탐구, 내성, 고독',
      reversed: 'Isolation, loneliness, withdrawal',
      reversedKo: '고립, 외로움, 철회',
      description: 'Take time for inner reflection.',
      descriptionKo: '내면 성찰의 시간을 가지세요.',
    ),
    TarotCard(
      id: 10,
      name: 'Wheel of Fortune',
      nameKo: '운명의 수레바퀴',
      upright: 'Good luck, karma, life cycles, destiny',
      uprightKo: '행운, 인과응보, 인생 주기, 운명',
      reversed: 'Bad luck, resistance to change, breaking cycles',
      reversedKo: '불운, 변화 저항, 순환 단절',
      description: 'Fortune turns in your favor.',
      descriptionKo: '운이 당신에게 유리하게 돌아갑니다.',
    ),
    TarotCard(
      id: 11,
      name: 'Justice',
      nameKo: '정의',
      upright: 'Justice, fairness, truth, cause and effect',
      uprightKo: '정의, 공정, 진실, 인과',
      reversed: 'Unfairness, lack of accountability, dishonesty',
      reversedKo: '불공정, 책임 결여, 부정직',
      description: 'Truth and fair outcomes will prevail.',
      descriptionKo: '진실과 공정한 결과가 승리할 것입니다.',
    ),
  ];
}
