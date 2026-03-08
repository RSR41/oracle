import '../models/meeting_match_models.dart';
import '../models/meeting_user.dart';

/// Remote datasource contract for M2/M3 phases.
///
/// Server should be the source of truth, while SQLite is used as
/// cache/offline fallback.
abstract class MeetingRemoteRepository {
  Future<List<MeetingUser>> fetchRecommendations(String myUserId);

  Future<MeetingLikeResult> submitLike({
    required String fromUserId,
    required String toUserId,
    required String createdAt,
  });

  Future<List<MeetingMatch>> fetchMatches(String userId);

  Future<MeetingMessage> sendMessage(MeetingMessage message);

  Future<List<MeetingMessage>> fetchMessages(
    String matchId, {
    int limit = 50,
    int offset = 0,
  });

  Future<int> fetchUnreadCount(String matchId, String userId);

  Future<void> markAsRead(String matchId, String userId);
}
