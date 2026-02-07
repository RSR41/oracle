class FortuneResult {
  final String id;
  final String type; // 'fortune', 'tarot', etc.
  final String title;
  final String date;
  final String summary; // "overall" score or brief
  final String content; // JSON payload or simple string
  final int overallScore;
  final String createdAt;

  FortuneResult({
    required this.id,
    required this.type,
    required this.title,
    required this.date,
    required this.summary,
    required this.content,
    required this.overallScore,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'date': date,
      'summary': summary,
      'content': content,
      'overallScore': overallScore,
      'createdAt': createdAt,
    };
  }

  factory FortuneResult.fromJson(Map<String, dynamic> json) {
    return FortuneResult(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      overallScore: json['overallScore'] as int,
      createdAt: json['createdAt'] as String,
    );
  }
}
