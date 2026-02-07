class MeetingLike {
  final String fromUserId;
  final String toUserId;
  final String createdAt;

  MeetingLike({
    required this.fromUserId,
    required this.toUserId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'createdAt': createdAt,
      };
}

class MeetingMatch {
  final String id;
  final String userA;
  final String userB;
  final String matchedAt;

  MeetingMatch({
    required this.id,
    required this.userA,
    required this.userB,
    required this.matchedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userA': userA,
        'userB': userB,
        'matchedAt': matchedAt,
      };
}

class MeetingMessage {
  final String id;
  final String matchId;
  final String senderId;
  final String text;
  final String createdAt;
  final String? readAt;

  MeetingMessage({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.readAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'matchId': matchId,
        'senderId': senderId,
        'text': text,
        'createdAt': createdAt,
        'readAt': readAt,
      };

  factory MeetingMessage.fromMap(Map<String, dynamic> map) => MeetingMessage(
        id: map['id'],
        matchId: map['matchId'],
        senderId: map['senderId'],
        text: map['text'],
        createdAt: map['createdAt'],
        readAt: map['readAt'],
      );
}

class MeetingReport {
  final String id;
  final String matchId;
  final String reporterId;
  final String reason;
  final String createdAt;

  MeetingReport({
    required this.id,
    required this.matchId,
    required this.reporterId,
    required this.reason,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'matchId': matchId,
        'reporterId': reporterId,
        'reason': reason,
        'createdAt': createdAt,
      };
}
