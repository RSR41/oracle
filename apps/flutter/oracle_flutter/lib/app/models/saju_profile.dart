class SajuProfile {
  final String nickname;
  final String gender; // 'M' or 'F'
  final String birthDate; // ISO format YYYY-MM-DD
  final String? birthTime; // HH:mm
  final String? birthLocation;

  SajuProfile({
    required this.nickname,
    required this.gender,
    required this.birthDate,
    this.birthTime,
    this.birthLocation,
  });

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'gender': gender,
    'birthDate': birthDate,
    'birthTime': birthTime,
    'birthLocation': birthLocation,
  };

  factory SajuProfile.fromJson(Map<String, dynamic> json) => SajuProfile(
    nickname: json['nickname'],
    gender: json['gender'],
    birthDate: json['birthDate'],
    birthTime: json['birthTime'],
    birthLocation: json['birthLocation'],
  );
}
