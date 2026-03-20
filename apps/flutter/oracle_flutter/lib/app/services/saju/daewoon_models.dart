enum DaewoonDirection {
  forward('forward', '순행'),
  backward('backward', '역행');

  final String code;
  final String korean;

  const DaewoonDirection(this.code, this.korean);

  static DaewoonDirection fromCode(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return DaewoonDirection.forward;
    }

    for (final item in DaewoonDirection.values) {
      if (item.code == normalized || item.korean == normalized) {
        return item;
      }
    }

    return DaewoonDirection.forward;
  }
}

class DaewoonEntry {
  final int order;
  final String stem;
  final String stemHanja;
  final String branch;
  final String branchHanja;
  final int startAge;
  final int endAge;
  final String description;

  const DaewoonEntry({
    required this.order,
    required this.stem,
    required this.stemHanja,
    required this.branch,
    required this.branchHanja,
    required this.startAge,
    required this.endAge,
    required this.description,
  });

  String get ganji => '$stem$branch';
  String get ganjiHanja => '$stemHanja$branchHanja';

  Map<String, dynamic> toJson() => {
    'order': order,
    'stem': stem,
    'stemHanja': stemHanja,
    'branch': branch,
    'branchHanja': branchHanja,
    'startAge': startAge,
    'endAge': endAge,
    'description': description,
  };

  factory DaewoonEntry.fromJson(Map<String, dynamic> json) => DaewoonEntry(
    order: (json['order'] as num?)?.toInt() ?? 0,
    stem: json['stem'] as String? ?? '',
    stemHanja: json['stemHanja'] as String? ?? '',
    branch: json['branch'] as String? ?? '',
    branchHanja: json['branchHanja'] as String? ?? '',
    startAge: (json['startAge'] as num?)?.toInt() ?? 0,
    endAge: (json['endAge'] as num?)?.toInt() ?? 0,
    description: json['description'] as String? ?? '',
  );
}

class DaewoonResult {
  final DaewoonDirection direction;
  final String? referenceTerm;
  final DateTime? referenceTermDateTime;
  final double? totalDays;
  final double? rawYears;
  final int? startYear;
  final int? startMonth;
  final String methodVersion;
  final bool usedFallback;
  final List<String> warnings;
  final List<DaewoonEntry> entries;

  DaewoonResult({
    required this.direction,
    this.referenceTerm,
    this.referenceTermDateTime,
    this.totalDays,
    this.rawYears,
    this.startYear,
    this.startMonth,
    this.methodVersion = 'legacy-major-cycles-v1',
    this.usedFallback = false,
    List<String> warnings = const [],
    List<DaewoonEntry> entries = const [],
  }) : warnings = List<String>.unmodifiable(warnings),
       entries = List<DaewoonEntry>.unmodifiable(entries);

  Map<String, dynamic> toJson() => {
    'direction': direction.code,
    'directionText': direction.korean,
    'referenceTerm': referenceTerm,
    'referenceTermDateTime': referenceTermDateTime?.toUtc().toIso8601String(),
    'totalDays': totalDays,
    'rawYears': rawYears,
    'startYear': startYear,
    'startMonth': startMonth,
    'methodVersion': methodVersion,
    'usedFallback': usedFallback,
    'warnings': warnings,
    'entries': entries.map((e) => e.toJson()).toList(),
  };

  factory DaewoonResult.fromJson(Map<String, dynamic> json) {
    final rawReferenceDateTime = json['referenceTermDateTime'] as String?;

    return DaewoonResult(
      direction: DaewoonDirection.fromCode(
        json['direction'] as String? ?? json['directionText'] as String?,
      ),
      referenceTerm: json['referenceTerm'] as String?,
      referenceTermDateTime: rawReferenceDateTime != null
          ? DateTime.parse(rawReferenceDateTime)
          : null,
      totalDays: (json['totalDays'] as num?)?.toDouble(),
      rawYears: (json['rawYears'] as num?)?.toDouble(),
      startYear: (json['startYear'] as num?)?.toInt(),
      startMonth: (json['startMonth'] as num?)?.toInt(),
      methodVersion:
          json['methodVersion'] as String? ?? 'legacy-major-cycles-v1',
      usedFallback: json['usedFallback'] as bool? ?? false,
      warnings: List<String>.from(json['warnings'] ?? const <String>[]),
      entries: (json['entries'] as List<dynamic>?)
              ?.map(
                (e) => DaewoonEntry.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}
