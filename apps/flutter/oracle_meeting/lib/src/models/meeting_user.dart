class MeetingUser {
  final String id;
  final String nickname;
  final String gender;
  final String birthDate;
  final String? sajuJson;
  final String? avatarPath;

  MeetingUser({
    required this.id,
    required this.nickname,
    required this.gender,
    required this.birthDate,
    this.sajuJson,
    this.avatarPath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'gender': gender,
        'birthDate': birthDate,
        'sajuJson': sajuJson,
        'avatarPath': avatarPath,
      };

  factory MeetingUser.fromJson(Map<String, dynamic> json) => MeetingUser(
        id: json['id'],
        nickname: json['nickname'],
        gender: json['gender'],
        birthDate: json['birthDate'],
        sajuJson: json['sajuJson'],
        avatarPath: json['avatarPath'],
      );
}
