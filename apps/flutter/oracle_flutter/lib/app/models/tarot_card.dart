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
  );
}
