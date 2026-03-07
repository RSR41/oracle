class MeetingUser {
  final String id;
  final String nickname;
  final String gender;
  final String birthDate;
  final String? sajuJson;
  final String? avatarPath;
  // Extended fields for Phase M1
  final int? age;
  final String? introduction;
  final String? regionCode;
  final String? regionName;
  final int? height;
  final String? occupation;
  final String? profilePhotoUrl;
  final List<String>? idealTypeKeywords;
  final List<String>? activityTags;
  final String? drinkSmoke;

  MeetingUser({
    required this.id,
    required this.nickname,
    required this.gender,
    required this.birthDate,
    this.sajuJson,
    this.avatarPath,
    this.age,
    this.introduction,
    this.regionCode,
    this.regionName,
    this.height,
    this.occupation,
    this.profilePhotoUrl,
    this.idealTypeKeywords,
    this.activityTags,
    this.drinkSmoke,
  });

  /// Compute age from birthDate if not explicitly set
  int get displayAge {
    if (age != null) return age!;
    try {
      final bd = DateTime.parse(birthDate);
      final now = DateTime.now();
      int a = now.year - bd.year;
      if (now.month < bd.month ||
          (now.month == bd.month && now.day < bd.day)) {
        a--;
      }
      return a;
    } catch (_) {
      return 0;
    }
  }

  /// Compatibility band label from a numeric score
  static String compatibilityBand(int score) {
    if (score >= 90) return 'EXCELLENT';
    if (score >= 75) return 'GOOD';
    if (score >= 60) return 'NORMAL';
    return 'CAUTION';
  }

  /// Korean band label
  static String compatibilityBandKo(int score) {
    if (score >= 90) return '최고';
    if (score >= 75) return '좋음';
    if (score >= 60) return '보통';
    return '주의';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'gender': gender,
        'birthDate': birthDate,
        'sajuJson': sajuJson,
        'avatarPath': avatarPath,
        'age': age,
        'introduction': introduction,
        'regionCode': regionCode,
        'regionName': regionName,
        'height': height,
        'occupation': occupation,
        'profilePhotoUrl': profilePhotoUrl,
        'idealTypeKeywords': idealTypeKeywords?.join(','),
        'activityTags': activityTags?.join(','),
        'drinkSmoke': drinkSmoke,
      };

  factory MeetingUser.fromJson(Map<String, dynamic> json) => MeetingUser(
        id: json['id'],
        nickname: json['nickname'],
        gender: json['gender'],
        birthDate: json['birthDate'],
        sajuJson: json['sajuJson'],
        avatarPath: json['avatarPath'],
        age: json['age'] as int?,
        introduction: json['introduction'] as String?,
        regionCode: json['regionCode'] as String?,
        regionName: json['regionName'] as String?,
        height: json['height'] as int?,
        occupation: json['occupation'] as String?,
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
        idealTypeKeywords: json['idealTypeKeywords'] != null
            ? (json['idealTypeKeywords'] as String).split(',')
            : null,
        activityTags: json['activityTags'] != null
            ? (json['activityTags'] as String).split(',')
            : null,
        drinkSmoke: json['drinkSmoke'] as String?,
      );
}
