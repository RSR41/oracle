enum StrengthLabel {
  strong('strong', '신강'),
  slightlyStrong('slightlyStrong', '중강'),
  balanced('balanced', '중화'),
  slightlyWeak('slightlyWeak', '중약'),
  weak('weak', '신약');

  final String code;
  final String korean;

  const StrengthLabel(this.code, this.korean);

  static StrengthLabel fromCode(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return StrengthLabel.balanced;
    }

    for (final item in StrengthLabel.values) {
      if (item.code == normalized || item.korean == normalized) {
        return item;
      }
    }

    return StrengthLabel.balanced;
  }
}

enum StrengthFactorType {
  monthOrder('monthOrder'),
  rootSupport('rootSupport'),
  visibleStemSupport('visibleStemSupport'),
  leakage('leakage'),
  hiddenStemSupport('hiddenStemSupport'),
  combinationOrClash('combinationOrClash');

  final String code;

  const StrengthFactorType(this.code);

  static StrengthFactorType fromCode(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return StrengthFactorType.monthOrder;
    }

    for (final item in StrengthFactorType.values) {
      if (item.code == normalized) {
        return item;
      }
    }

    return StrengthFactorType.monthOrder;
  }
}

class StrengthFactor {
  final StrengthFactorType type;
  final int score;
  final String title;
  final String description;
  final Map<String, dynamic> meta;

  const StrengthFactor({
    required this.type,
    required this.score,
    required this.title,
    required this.description,
    this.meta = const {},
  });

  Map<String, dynamic> toJson() => {
    'type': type.code,
    'score': score,
    'title': title,
    'description': description,
    'meta': meta,
  };

  factory StrengthFactor.fromJson(Map<String, dynamic> json) => StrengthFactor(
    type: StrengthFactorType.fromCode(json['type'] as String?),
    score: (json['score'] as num?)?.toInt() ?? 0,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    meta: Map<String, dynamic>.from(json['meta'] as Map? ?? const {}),
  );
}

class DayMasterStrengthResult {
  final int baseScore;
  final int score;
  final StrengthLabel label;
  final List<StrengthFactor> factors;
  final String methodVersion;
  final bool usedFallback;

  DayMasterStrengthResult({
    this.baseScore = 50,
    required int score,
    required this.label,
    List<StrengthFactor> factors = const [],
    this.methodVersion = 'legacy-ratio-v1',
    this.usedFallback = false,
  }) : score = score.clamp(0, 100).toInt(),
       factors = List<StrengthFactor>.unmodifiable(factors);

  String get labelText => label.korean;

  factory DayMasterStrengthResult.fromLegacyString(
    String label, {
    String methodVersion = 'legacy-ratio-v1',
  }) {
    final normalized = StrengthLabel.fromCode(label);

    int mappedScore = 50;
    switch (normalized) {
      case StrengthLabel.strong:
        mappedScore = 75;
        break;
      case StrengthLabel.slightlyStrong:
        mappedScore = 63;
        break;
      case StrengthLabel.balanced:
        mappedScore = 50;
        break;
      case StrengthLabel.slightlyWeak:
        mappedScore = 37;
        break;
      case StrengthLabel.weak:
        mappedScore = 25;
        break;
    }

    return DayMasterStrengthResult(
      score: mappedScore,
      label: normalized,
      methodVersion: methodVersion,
      usedFallback: true,
    );
  }

  Map<String, dynamic> toJson() => {
    'baseScore': baseScore,
    'score': score,
    'label': label.code,
    'labelText': labelText,
    'factors': factors.map((e) => e.toJson()).toList(),
    'methodVersion': methodVersion,
    'usedFallback': usedFallback,
  };

  factory DayMasterStrengthResult.fromJson(Map<String, dynamic> json) {
    final labelValue = json['label'] as String? ?? json['labelText'] as String?;

    return DayMasterStrengthResult(
      baseScore: (json['baseScore'] as num?)?.toInt() ?? 50,
      score: (json['score'] as num?)?.toInt() ?? 50,
      label: StrengthLabel.fromCode(labelValue),
      factors: (json['factors'] as List<dynamic>?)
              ?.map(
                (e) => StrengthFactor.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList() ??
          const [],
      methodVersion: json['methodVersion'] as String? ?? 'legacy-ratio-v1',
      usedFallback: json['usedFallback'] as bool? ?? false,
    );
  }
}
