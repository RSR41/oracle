import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:x_1/shared/domain/models/profile.dart';
import 'package:x_1/core/utils/lunar_calendar_util.dart';
import 'package:x_1/shared/data/local/profile_repository.dart';

part 'fortune_provider.g.dart';

@riverpod
class Fortune extends _$Fortune {
  @override
  FortuneState build() {
    // Load profile asynchronously
    _loadProfile();
    return const FortuneState(isLoading: true);
  }

  Future<void> _loadProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(profileRepositoryProvider);
      final profile = await repo.getProfile();
      state = state.copyWith(currentProfile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> setProfile(Profile profile) async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(profileRepositoryProvider);
      await repo.saveProfile(profile);
      state = state.copyWith(currentProfile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // Basic validation or processing could go here
  Map<String, dynamic>? getLunarDate() {
    final profile = state.currentProfile;
    if (profile == null) return null;

    // Parse date
    try {
      final parts = profile.birthDate.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      final date = DateTime(year, month, day);

      if (profile.isSolar) {
        return LunarCalendarUtil.solarToLunar(date);
      } else {
        // Already lunar, just return as is
        return {
          'year': year,
          'month': month,
          'day': day,
          'isLeap': profile.isLeapMonth,
        };
      }
    } catch (e) {
      return null;
    }
  }
}

class FortuneState {
  final Profile? currentProfile;
  final bool isLoading;
  final String? error;

  const FortuneState({
    this.currentProfile,
    this.isLoading = false,
    this.error,
  });

  FortuneState copyWith({
    Profile? currentProfile,
    bool? isLoading,
    String? error,
  }) {
    return FortuneState(
      currentProfile: currentProfile ?? this.currentProfile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
