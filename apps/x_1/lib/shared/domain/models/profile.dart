import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String name,
    required String birthDate, // YYYY-MM-DD
    required String birthTime, // HH:mm
    required bool isUnknownTime,
    required String gender, // M/F
    required bool isSolar,
    @Default(false) bool isLeapMonth, // For Lunar
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
