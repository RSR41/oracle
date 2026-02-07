/// Result of dream interpretation
class DreamResult {
  final String summary;
  final String details;
  final List<String> keywords;
  final String advice;
  final int luckScore;

  DreamResult({
    required this.summary,
    required this.details,
    required this.keywords,
    required this.advice,
    required this.luckScore,
  });

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'details': details,
    'keywords': keywords,
    'advice': advice,
    'luckScore': luckScore,
  };

  factory DreamResult.fromJson(Map<String, dynamic> json) => DreamResult(
    summary: json['summary'] as String,
    details: json['details'] as String,
    keywords: List<String>.from(json['keywords']),
    advice: json['advice'] as String,
    luckScore: json['luckScore'] as int,
  );
}

/// Interface for dream interpretation services
abstract class DreamInterpreter {
  Future<DreamResult> interpret(String dreamContent);
}
