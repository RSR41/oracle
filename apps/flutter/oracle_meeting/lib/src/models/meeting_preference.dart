class MeetingPreference {
  final String profileId;
  final String? targetGender;
  final int ageMin;
  final int ageMax;
  final String? regionScope;
  final int? distanceKm;

  MeetingPreference({
    required this.profileId,
    this.targetGender,
    this.ageMin = 20,
    this.ageMax = 40,
    this.regionScope,
    this.distanceKm,
  });

  Map<String, dynamic> toMap() => {
        'profileId': profileId,
        'targetGender': targetGender,
        'ageMin': ageMin,
        'ageMax': ageMax,
        'regionScope': regionScope,
        'distanceKm': distanceKm,
      };

  factory MeetingPreference.fromMap(Map<String, dynamic> map) =>
      MeetingPreference(
        profileId: map['profileId'],
        targetGender: map['targetGender'],
        ageMin: map['ageMin'] ?? 20,
        ageMax: map['ageMax'] ?? 40,
        regionScope: map['regionScope'],
        distanceKm: map['distanceKm'],
      );
}
