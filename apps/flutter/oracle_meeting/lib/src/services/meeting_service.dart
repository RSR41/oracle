import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/meeting_match_models.dart';
import '../models/meeting_user.dart';
import '../models/meeting_notification_event.dart';
import '../repository/meeting_repository.dart';
import 'meeting_match_rule.dart';

class MeetingHistoryEventTypes {
  static const String profileCompleted = 'meeting_profile_completed';
  static const String compatibilitySnapshot = 'meeting_compatibility_snapshot';
  static const String recommendationServed = 'meeting_recommendation_served';
  static const String matchCreated = 'meeting_match_created';
  static const String reportSubmitted = 'meeting_report_submitted';

  // Legacy / supplementary types kept for backward compatibility.
  static const String seed = 'meeting_seed';
  static const String block = 'meeting_block';
}

class MeetingService {
  final MeetingRepository _repo;
  final Uuid _uuid = const Uuid();
  final Random _random = Random();
  final MeetingMatchRule _matchRule;

  /// Callback for recording history in oracle_flutter
  final Future<void> Function(Map<String, dynamic> payload)? onHistoryRecord;

  /// Global callback for instances created elsewhere (e.g. ChatScreen)
  static Future<void> Function(Map<String, dynamic> payload)?
      globalOnHistoryRecord;

  /// Global callback for local notifications in host apps (oracle_flutter).
  static Future<void> Function(MeetingNotificationEvent event)?
      globalOnNotificationEvent;

  /// Active opened matchId in foreground chat to prevent duplicate alerts.
  static String? activeForegroundMatchId;

  MeetingService(
    this._repo, {
    this.onHistoryRecord,
    MeetingMatchRule? matchRule,
  }) : _matchRule = matchRule ?? const HashModuloMeetingMatchRule();

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

  bool _shouldSkipNotification(String matchId) {
    return activeForegroundMatchId == matchId;
  }

  Future<void> _safeNotify(MeetingNotificationEvent event) async {
    if (_shouldSkipNotification(event.matchId)) return;
    try {
      final callback = globalOnNotificationEvent;
      if (callback != null) {
        await callback(event);
      }
    } catch (_) {
      // Ignore notification errors to prevent blocking meeting flows
    }
  }

  // ─────────────────── Mock Data ───────────────────

  static final _introductions = [
    '카페에서 책 읽는 것을 좋아해요 ☕',
    '주말에는 등산이나 캠핑을 즐겨요 🏕️',
    '요리하는 걸 좋아하는 집순이/집돌이입니다 🍳',
    '음악과 여행을 사랑하는 자유로운 영혼 🎵',
    '반려동물과 함께하는 일상이 행복해요 🐕',
    '운동을 좋아하고 건강한 라이프스타일을 추구해요 💪',
    '영화와 넷플릭스가 취미인 감성파입니다 🎬',
    '맛집 탐방이 취미예요! 같이 가실 분? 🍜',
    '사진 찍는 걸 좋아해서 인스타를 열심히 해요 📸',
    '게임도 좋아하고 보드게임 카페도 자주 가요 🎮',
    '진지한 만남을 원해요. 같이 성장할 사람 찾습니다 🌱',
    '유머감각이 있는 편이에요. 항상 웃는 얼굴! 😊',
    '주말 드라이브가 취미이고 카페 투어를 즐겨요 🚗',
    '독서와 글쓰기를 좋아하는 문학 소녀/소년 📖',
    '서로 존중하며 편안한 관계를 원해요 💕',
    '여행 다니면서 맛있는 거 먹는 게 최고! ✈️',
    '운동 후 치맥이 삶의 낙입니다 🍺',
    '주말에 전시회나 공연 보러 가는 것을 좋아해요 🎨',
    '날씨 좋은 날 한강 산책이 최고예요 🌅',
    '귀엽고 포근한 사람을 좋아해요 🧸',
  ];

  static final _regions = [
    {'code': 'SEL', 'name': '서울'},
    {'code': 'GYG', 'name': '경기'},
    {'code': 'ICN', 'name': '인천'},
    {'code': 'BSN', 'name': '부산'},
    {'code': 'DGU', 'name': '대구'},
    {'code': 'GWJ', 'name': '광주'},
    {'code': 'DJN', 'name': '대전'},
    {'code': 'JJD', 'name': '제주'},
  ];

  static final _occupations = [
    '회사원', 'IT 개발자', '디자이너', '마케터', '교사',
    '간호사', '약사', '공무원', '자영업', '대학생',
    '대학원생', '프리랜서', '영업직', '연구원', '금융업',
    '요리사', '엔지니어', '건축가', '법률가', '의료인',
  ];

  static final _names = [
    '지수', '민준', '서연', '도윤', '하은',
    '지호', '수아', '예준', '지우', '우진',
    '유진', '준호', '지원', '서준', '수빈',
    '유준', '은지', '현우', '다은', '건우',
  ];

  Future<void> initializeMockUsers() async {
    var recs = await _repo.getRecommendations('me');
    if (recs.isNotEmpty) return;

    for (int i = 0; i < _names.length; i++) {
      final isFemale = i % 2 == 0;
      final year = 1990 + _random.nextInt(10);
      final month = 1 + _random.nextInt(12);
      final day = 1 + _random.nextInt(28);
      final region = _regions[i % _regions.length];
      final heights = isFemale
          ? [155, 158, 160, 162, 165, 168, 170]
          : [170, 173, 175, 178, 180, 182, 185];

      await _repo.saveUser(MeetingUser(
        id: 'user_$i',
        nickname: _names[i],
        gender: isFemale ? 'F' : 'M',
        birthDate:
            '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
        sajuJson: '{}',
        avatarPath: null,
        introduction: _introductions[i],
        regionCode: region['code'],
        regionName: region['name'],
        height: heights[_random.nextInt(heights.length)],
        occupation: _occupations[i],
        idealTypeKeywords: _pickRandom(['유머', '진지함', '활발함', '차분함', '다정함', '지적임'], 2),
        activityTags: _pickRandom(['카페', '등산', '영화', '운동', '여행', '독서', '게임', '요리'], 3),
      ));
    }
  }

  List<String> _pickRandom(List<String> source, int count) {
    final shuffled = List<String>.from(source)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  // ─────────────────── Score Calculation ───────────────────

  int _stableHash(String input) {
    var hash = 0x811c9dc5;
    for (var i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  String _deterministicId(String seed) {
    return _stableHash(seed).toUnsigned(32).toRadixString(16).padLeft(8, '0');
  }


  Future<void> _recordHistoryEvent({
    required String eventType,
    required String idSeed,
    required String title,
    required String body,
    Map<String, dynamic>? meta,
  }) async {
    final createdAt = DateTime.now().toIso8601String();
    await _safeHistory({
      'id': _deterministicId(idSeed),
      'type': eventType,
      'title': title,
      'body': body,
      'createdAt': createdAt,
      if (meta != null) 'meta': meta,
    });
  }

  /// Calculate compatibility score (60-100)
  int calculateScore(String myId, String targetId) =>
      _matchRule.calculateCompatibilityScore(myId, targetId);

  /// 저장 시점: 사용자의 소개팅 프로필 저장/완료 직후
  Future<void> recordProfileCompleted({
    required String userId,
    required String nickname,
    String? regionCode,
  }) async {
    await _recordHistoryEvent(
      eventType: MeetingHistoryEventTypes.profileCompleted,
      idSeed: 'profile|$userId',
      title: '[Meeting] 프로필 작성 완료',
      body: '$nickname님의 소개팅 프로필이 준비되었습니다.',
      meta: {
        'userId': userId,
        'nickname': nickname,
        if (regionCode != null) 'regionCode': regionCode,
      },
    );
  }

  /// 저장 시점: 추천 카드(소개 대상)가 사용자에게 노출될 때
  Future<void> recordRecommendationServed({
    required String myUserId,
    required String targetUserId,
    required int recommendationIndex,
  }) async {
    await _recordHistoryEvent(
      eventType: MeetingHistoryEventTypes.recommendationServed,
      idSeed: 'recommendation|$myUserId|$targetUserId|$recommendationIndex',
      title: '[Meeting] 추천 카드 노출',
      body: '새로운 추천 상대가 표시되었습니다.',
      meta: {
        'myUserId': myUserId,
        'targetUserId': targetUserId,
        'recommendationIndex': recommendationIndex,
      },
    );
  }

  /// 저장 시점: 궁합 점수를 계산해 화면에 스냅샷으로 보여줄 때
  Future<void> recordCompatibilitySnapshot({
    required String myUserId,
    required String targetUserId,
    required int score,
  }) async {
    await _recordHistoryEvent(
      eventType: MeetingHistoryEventTypes.compatibilitySnapshot,
      idSeed: 'compatibility|$myUserId|$targetUserId|$score',
      title: '[Meeting] 궁합 스냅샷 저장',
      body: '두 사람의 궁합 분석 스냅샷이 저장되었습니다.',
      meta: {
        'myUserId': myUserId,
        'targetUserId': targetUserId,
        'score': score,
      },
    );
  }

  // ─────────────────── Like / Pass / Match ───────────────────

  Future<bool> likeUser(String myUserId, String targetUserId) async {
    final now = DateTime.now().toIso8601String();
    await _repo.saveLike(MeetingLike(
        fromUserId: myUserId, toUserId: targetUserId, createdAt: now));

    // Remote-first like flow (M2/M3), then local mock fallback.
    final remoteLike = await _repo.submitLikeRemote(
      fromUserId: myUserId,
      toUserId: targetUserId,
      createdAt: now,
    );

    final isMatch = remoteLike?.isMatch ??
        _matchRule.shouldCreateMatch(myUserId, targetUserId);

    if (isMatch) {
      final existingMatch = remoteLike?.match;
      final score =
          existingMatch?.compatibilityScore ?? calculateScore(myUserId, targetUserId);
      final match = existingMatch ??
          MeetingMatch(
            id: _uuid.v4(),
            userA: myUserId,
            userB: targetUserId,
            matchedAt: now,
            compatibilityScore: score,
          );
      await _repo.saveMatch(match);
      final matchId = match.id;

      await _safeHistory({
        'id': _deterministicId("match|$matchId"),
        'type': MeetingHistoryEventTypes.matchCreated,
        'title': '[Meeting] 매칭 성립',
        'body': '상대방과 매칭되었습니다! 대화를 시작해보세요.',
        'createdAt': now,
        'meta': {
          'matchId': matchId,
          'myUserId': myUserId,
          'targetUserId': targetUserId,
          'score': score,
        }
      });

      await _safeNotify(MeetingNotificationEvent(
        type: MeetingNotificationEventType.meetingMatchCreated,
        matchId: matchId,
        title: '새로운 매칭이 성립됐어요 💜',
        body: '상대방과 대화를 시작해보세요.',
        payload: {
          'eventType': MeetingNotificationEventType
              .meetingMatchCreated
              .value,
          'matchId': matchId,
          'myUserId': myUserId,
          'targetUserId': targetUserId,
          'score': score,
        },
      ));

      // Auto-send initial greeting
      await Future.delayed(const Duration(milliseconds: 300));
      await _repo.sendMessage(MeetingMessage(
        id: _uuid.v4(),
        matchId: matchId,
        senderId: targetUserId,
        text: '안녕하세요! 좋아요 눌러주셔서 감사해요 😊',
        createdAt: DateTime.now().toIso8601String(),
      ));

      return true;
    }
    return false;
  }

  Future<void> passUser(String myUserId, String targetUserId) async {
    final now = DateTime.now().toIso8601String();
    await _repo.savePass(MeetingPass(
        fromUserId: myUserId, toUserId: targetUserId, createdAt: now));
  }

  // ─────────────────── Block / Report ───────────────────

  Future<void> blockUser(String myUserId, String targetUserId) async {
    final block = MeetingBlock(
      id: _uuid.v4(),
      blockerUserId: myUserId,
      blockedUserId: targetUserId,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _repo.blockUser(block);

    await _safeHistory({
      'id': _deterministicId("block|$myUserId|$targetUserId"),
      'type': MeetingHistoryEventTypes.block,
      'title': '[Meeting] 사용자 차단',
      'body': '사용자를 차단했습니다.',
      'createdAt': DateTime.now().toIso8601String(),
      'meta': {
        'blockerUserId': myUserId,
        'blockedUserId': targetUserId,
      }
    });
  }

  Future<MeetingReport> reportUser({
    required String matchId,
    required String reporterId,
    required String reason,
    String? description,
  }) async {
    final report = MeetingReport(
      id: _uuid.v4(),
      matchId: matchId,
      reporterId: reporterId,
      reason: reason,
      description: description,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _repo.reportUser(report);
    await _repo.syncMeetingReportToServer(report);

    await _safeHistory({
      'id': _deterministicId("report|${report.id}"),
      'type': MeetingHistoryEventTypes.reportSubmitted,
      'title': '[Meeting] 신고 접수',
      'body': '신고가 접수되었습니다.',
      'createdAt': DateTime.now().toIso8601String(),
      'meta': {
        'matchId': matchId,
        'reporterId': reporterId,
        'reason': reason,
      }
    });

    return report;
  }

  Future<MeetingReport?> getRecentReportForMatch({
    required String matchId,
    required String reporterId,
    required Duration within,
  }) async {
    final reports = await _repo.getReports(
      reporterId: reporterId,
      matchId: matchId,
      limit: 10,
    );
    if (reports.isEmpty) return null;

    final now = DateTime.now();
    for (final report in reports) {
      final createdAt = DateTime.tryParse(report.createdAt);
      if (createdAt == null) continue;
      if (now.difference(createdAt) <= within) {
        return report;
      }
    }
    return null;
  }

  // ─────────────────── Data Access ───────────────────

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
  Future<MeetingMessage?> getLastMessage(String matchId) =>
      _repo.getLastMessage(matchId);

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

    // Schedule mock reply
    _scheduleMockReply(
      matchId: matchId,
      senderId: otherUserId,
      receiverId: myUserId,
    );

    return message;
  }

  void _scheduleMockReply({
    required String matchId,
    required String senderId,
    required String receiverId,
  }) {
    Future.delayed(const Duration(seconds: 2), () async {
      final messages = await _repo.getMessages(matchId);
      final replies = [
        '네, 반가워요! 사주 결과 보셨나요?',
        '오늘 하루 어떠셨나요?',
        '저도 그렇게 생각해요 ㅎㅎ',
        '다음에 밥 한번 먹어요!',
        '사주 궁합이 잘 맞다니 신기하네요 ✨',
        '어디 사세요? 가까우면 좋겠다!',
      ];
      final text = replies[messages.length % replies.length];

      final createdAt = DateTime.now().toIso8601String();
      await _repo.sendMessage(MeetingMessage(
        id: _uuid.v4(),
        matchId: matchId,
        senderId: senderId,
        text: text,
        createdAt: createdAt,
      ));

      await _safeNotify(MeetingNotificationEvent(
        type: MeetingNotificationEventType.meetingMessageReceived,
        matchId: matchId,
        title: '새 메시지가 도착했어요',
        body: text,
        payload: {
          'eventType': MeetingNotificationEventType
              .meetingMessageReceived
              .value,
          'matchId': matchId,
          'senderId': senderId,
          'receiverId': receiverId,
          'text': text,
          'createdAt': createdAt,
        },
      ));
    });
  }

  // ─────────────────── Demo Reset ───────────────────

  Future<void> resetAndSeedAll({String myUserId = 'me'}) async {
    await _repo.clearAllData();
    await initializeMockUsers();

    final matchId = 'demo_match_1';
    final targetUserId = 'user_0';
    final now = DateTime.now().toIso8601String();
    final score = calculateScore(myUserId, targetUserId);

    await _repo.saveMatch(MeetingMatch(
      id: matchId,
      userA: myUserId,
      userB: targetUserId,
      matchedAt: now,
      compatibilityScore: score,
    ));

    await _repo.sendMessage(MeetingMessage(
      id: _uuid.v4(),
      matchId: matchId,
      senderId: targetUserId,
      text: '안녕하세요! 매칭되어서 기뻐요. 사주 궁합 보셨나요? 😊',
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

    await _repo.sendMessage(MeetingMessage(
      id: _uuid.v4(),
      matchId: matchId,
      senderId: targetUserId,
      text: '정말요? 우리 진짜 잘 맞을 것 같아요! 💜',
      createdAt: DateTime.now().toIso8601String(),
    ));

    await _safeHistory({
      'id': _deterministicId("seed|$myUserId"),
      'type': MeetingHistoryEventTypes.seed,
      'title': '[Meeting] Seed 완료',
      'body': '데모 데이터가 초기화되고 새로운 인연이 생성되었습니다.',
      'createdAt': DateTime.now().toIso8601String(),
      'meta': {'myUserId': myUserId}
    });
  }
}
