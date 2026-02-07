import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/meeting_match_models.dart';
import '../models/meeting_user.dart';
import '../repository/meeting_repository.dart';

class MeetingService {
  final MeetingRepository _repo;
  final Uuid _uuid = const Uuid();
  final Random _random = Random();

  /// Callback for recording history in oracle_flutter
  final Future<void> Function(Map<String, dynamic> payload)? onHistoryRecord;

  /// Global callback for instances created elsewhere (e.g. ChatScreen)
  static Future<void> Function(Map<String, dynamic> payload)?
      globalOnHistoryRecord;

  MeetingService(this._repo, {this.onHistoryRecord});

  /// Safely record history without blocking the main flow
  Future<void> _safeHistory(Map<String, dynamic> payload) async {
    try {
      if (onHistoryRecord != null) {
        await onHistoryRecord!(payload);
      } else if (globalOnHistoryRecord != null) {
        await globalOnHistoryRecord!(payload);
      }
    } catch (_) {
      // Ignore history errors to prevent blocking gameplay
    }
  }

  Future<void> initializeMockUsers() async {
    // Only if recommendation empty
    var recs = await _repo.getRecommendations('me');
    if (recs.isNotEmpty) return;

    final names = [
      '지수',
      '민준',
      '서연',
      '도윤',
      '하은',
      '지호',
      '수아',
      '예준',
      '지우',
      '우진',
      '유진',
      '준호',
      '지원',
      '서준',
      '수빈',
      '유준',
      '은지',
      '현우',
      '다은',
      '건우'
    ];

    for (int i = 0; i < names.length; i++) {
      final isFemale = i % 2 == 0;
      final year = 1990 + _random.nextInt(10);
      final month = 1 + _random.nextInt(12);
      final day = 1 + _random.nextInt(28);

      await _repo.saveUser(MeetingUser(
        id: 'user_$i',
        nickname: names[i],
        gender: isFemale ? 'F' : 'M',
        birthDate:
            '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
        sajuJson: '{}',
        avatarPath: null,
      ));
    }
  }

  // 32-bit FNV-1a hash for deterministic results across platforms
  int _fnv1aHash(String input) {
    var hash = 0x811c9dc5;
    for (var i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  String _deterministicId(String seed) {
    return _fnv1aHash(seed).toUnsigned(32).toRadixString(16).padLeft(8, '0');
  }

  // Calculate generic compatibility score (0-100) using deterministic hash
  int calculateScore(String myId, String targetId) {
    final hash = _fnv1aHash(myId + targetId);
    return 60 + (hash.abs() % 41); // 60 ~ 100
  }

  Future<bool> likeUser(String myUserId, String targetUserId) async {
    // 1. Save like
    final now = DateTime.now().toIso8601String();
    await _repo.saveLike(MeetingLike(
        fromUserId: myUserId, toUserId: targetUserId, createdAt: now));

    // 2. Check for "Mutual Like"
    // Demo logic: 'user_0' (지수) is ALWAYS a match for demo purposes
    final hash = _fnv1aHash(myUserId + targetUserId);
    bool isMatch = (targetUserId == 'user_0') || (hash % 3 == 0);

    if (isMatch) {
      final matchId = _uuid.v4();
      await _repo.saveMatch(MeetingMatch(
          id: matchId, userA: myUserId, userB: targetUserId, matchedAt: now));

      // [ 지점 #2 ] MATCH 성립 History 기록
      await _safeHistory({
        'id': _deterministicId("match|$matchId"),
        'type': 'meeting_match',
        'title': '[Meeting] 매칭 성립',
        'body': '상대방과 매칭되었습니다! 대화를 시작해보세요.',
        'createdAt': now,
        'meta': {
          'matchId': matchId,
          'myUserId': myUserId,
          'targetUserId': targetUserId,
        }
      });

      // Auto-send initial greeting (Mock)
      await Future.delayed(const Duration(milliseconds: 500));
      await _repo.sendMessage(MeetingMessage(
        id: _uuid.v4(),
        matchId: matchId,
        senderId: targetUserId,
        text: '안녕하세요! 좋아요 눌러주셔서 감사해요 :)',
        createdAt: DateTime.now().toIso8601String(),
      ));

      return true;
    }
    return false;
  }

  Future<List<MeetingMatch>> getMatches(String userId) =>
      _repo.getMatches(userId);
  Future<MeetingUser?> getUser(String id) => _repo.getUser(id);
  Future<int> getUnreadCount(String matchId, String userId) =>
      _repo.getUnreadCount(matchId, userId);
  Future<List<MeetingMessage>> getMessages(String matchId,
          {int limit = 50, int offset = 0}) =>
      _repo.getMessages(matchId, limit: limit, offset: offset);
  Future<void> markAsRead(String matchId, String userId) =>
      _repo.markAsRead(matchId, userId);

  Future<MeetingMessage> sendMessage({
    required String matchId,
    required String myUserId,
    required String content,
    required String otherUserId,
  }) async {
    final messageId = _uuid.v4();
    final now = DateTime.now().toIso8601String();

    final message = await _repo.sendMessage(MeetingMessage(
      id: messageId,
      matchId: matchId,
      senderId: myUserId,
      text: content,
      createdAt: now,
    ));

    // [ 지점 #3 ] MESSAGE 전송 History 기록
    await _safeHistory({
      'id': _deterministicId("msg|$messageId"),
      'type': 'meeting_message',
      'title': '[Meeting] 메시지 전송',
      'body': content.length > 20 ? '${content.substring(0, 20)}...' : content,
      'createdAt': now,
      'meta': {
        'messageId': messageId,
        'matchId': matchId,
        'senderId': myUserId,
      }
    });

    // Mock Reply logic
    _scheduleMockReply(matchId, otherUserId);

    return message;
  }

  void _scheduleMockReply(String matchId, String senderId) {
    Future.delayed(const Duration(seconds: 2), () async {
      final messages = await _repo.getMessages(matchId);
      final replies = [
        '네, 반가워요! 사주 결과 보셨나요?',
        '오늘 하루 어떠셨나요?',
        '저도 그렇게 생각해요 ㅎㅎ',
        '다음에 밥 한번 먹어요!',
      ];
      // Use message count to pick a reply deterministically
      final text = replies[messages.length % replies.length];

      await _repo.sendMessage(MeetingMessage(
        id: _uuid.v4(),
        matchId: matchId,
        senderId: senderId,
        text: text,
        createdAt: DateTime.now().toIso8601String(),
      ));
    });
  }

  /// 디버그용: 테스트 메시지 생성
  Future<void> seedTestMessages(String matchId, {int count = 10}) async {
    for (int i = 0; i < count; i++) {
      final isMe = i % 2 == 0;
      await _repo.sendMessage(MeetingMessage(
        id: _uuid.v4(),
        matchId: matchId,
        senderId: isMe ? 'me' : 'other',
        text: '테스트 메시지 $i',
        createdAt: DateTime.now()
            .subtract(Duration(minutes: count - i))
            .toIso8601String(),
        readAt: isMe ? DateTime.now().toIso8601String() : null,
      ));
    }
  }

  /// 시연을 위한 전체 데이터 초기화 및 재설정
  Future<void> resetAndSeedAll({String myUserId = 'me'}) async {
    // 1. 기존 데이터 삭제
    await _repo.clearAllData();

    // 2. 추천 유저 20명 생성
    // Use fixed seed for Random to make it deterministic if needed,
    // but here we just want fixed names and counts.
    await initializeMockUsers();

    // 3. 강제 매칭 1건 생성 (시연용 - 이미 대화가 진행중인 방)
    final matchId = 'demo_match_1';
    final targetUserId = 'user_0'; // '지수'
    final now = DateTime.now().toIso8601String();

    await _repo.saveMatch(MeetingMatch(
      id: matchId,
      userA: myUserId,
      userB: targetUserId,
      matchedAt: now,
    ));

    // 4. 초기 메시지 생성
    await _repo.sendMessage(MeetingMessage(
      id: _uuid.v4(),
      matchId: matchId,
      senderId: targetUserId,
      text: '안녕하세요! 매칭되어서 기뻐요. 사주 궁합 보셨나요?',
      createdAt:
          DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
    ));

    await _repo.sendMessage(MeetingMessage(
      id: _uuid.v4(),
      matchId: matchId,
      senderId: myUserId,
      text: '네, 반가워요! 점수가 꽤 높게 나왔더라고요 ㅎㅎ',
      createdAt:
          DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
    ));

    // 5. 안 읽은 메시지 1개 추가 (상대방 측)
    await _repo.sendMessage(MeetingMessage(
      id: _uuid.v4(),
      matchId: matchId,
      senderId: targetUserId,
      text: '정말요? 제가 보낸 답변 기다릴게요!',
      createdAt: DateTime.now().toIso8601String(),
    ));

    // [ 지점 #1 ] SEED 실행됨 History 기록
    await _safeHistory({
      'id': _deterministicId("seed|$myUserId"),
      'type': 'meeting_seed',
      'title': '[Meeting] Seed 완료',
      'body': '데모 데이터가 초기화되고 새로운 인연이 생성되었습니다.',
      'createdAt': DateTime.now().toIso8601String(),
      'meta': {
        'myUserId': myUserId,
      }
    });
  }
}
