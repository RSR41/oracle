abstract class MeetingMatchRule {
  int calculateCompatibilityScore(String myUserId, String targetUserId);

  bool shouldCreateMatch(String myUserId, String targetUserId);
}

/// Local demo rule set.
///
/// - Compatibility score: deterministic 60~100 range using FNV-1a hash.
/// - Match probability: deterministic `hash % 3 == 0` with a demo fast-track
///   for `user_0`.
class HashModuloMeetingMatchRule implements MeetingMatchRule {
  const HashModuloMeetingMatchRule();

  int _fnv1aHash(String input) {
    var hash = 0x811c9dc5;
    for (var i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  @override
  int calculateCompatibilityScore(String myUserId, String targetUserId) {
    final hash = _fnv1aHash(myUserId + targetUserId);
    return 60 + (hash.abs() % 41);
  }

  @override
  bool shouldCreateMatch(String myUserId, String targetUserId) {
    if (targetUserId == 'user_0') return true;
    final hash = _fnv1aHash(myUserId + targetUserId);
    return hash % 3 == 0;
  }
}
