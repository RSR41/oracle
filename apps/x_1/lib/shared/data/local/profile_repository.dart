import 'dart:convert';
import 'package:x_1/shared/domain/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider =
    Provider<ProfileRepository>((ref) => ProfileRepository());

class ProfileRepository {
  static const String _key = 'user_profile';

  Future<void> saveProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile.toJson());
    await prefs.setString(_key, jsonString);
  }

  Future<Profile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    try {
      final jsonMap = jsonDecode(jsonString);
      return Profile.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
