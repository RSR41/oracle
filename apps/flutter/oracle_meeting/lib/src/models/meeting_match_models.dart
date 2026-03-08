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

class MeetingPass {
  final String fromUserId;
  final String toUserId;
  final String createdAt;

  MeetingPass({
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
  final int? compatibilityScore;

  MeetingMatch({
    required this.id,
    required this.userA,
    required this.userB,
    required this.matchedAt,
    this.compatibilityScore,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userA': userA,
        'userB': userB,
        'matchedAt': matchedAt,
        'compatibilityScore': compatibilityScore,
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
  final String? description;
  final String createdAt;
  final MeetingReportStatus status;

  MeetingReport({
    required this.id,
    required this.matchId,
    required this.reporterId,
    required this.reason,
    this.description,
    required this.createdAt,
    this.status = MeetingReportStatus.pending,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'matchId': matchId,
        'reporterId': reporterId,
        'reason': reason,
        'description': description,
        'createdAt': createdAt,
        'status': status.value,
      };

  factory MeetingReport.fromMap(Map<String, dynamic> map) => MeetingReport(
        id: map['id'] as String,
        matchId: map['matchId'] as String,
        reporterId: map['reporterId'] as String,
        reason: map['reason'] as String,
        description: map['description'] as String?,
        createdAt: map['createdAt'] as String,
        status: MeetingReportStatus.fromValue(map['status'] as String?),
      );
}

class MeetingBlock {
  final String id;
  final String blockerUserId;
  final String blockedUserId;
  final String createdAt;

  MeetingBlock({
    required this.id,
    required this.blockerUserId,
    required this.blockedUserId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'blockerUserId': blockerUserId,
        'blockedUserId': blockedUserId,
        'createdAt': createdAt,
      };

  factory MeetingBlock.fromMap(Map<String, dynamic> map) => MeetingBlock(
        id: map['id'],
        blockerUserId: map['blockerUserId'],
        blockedUserId: map['blockedUserId'],
        createdAt: map['createdAt'],
      );
}
enum MeetingReportStatus {
  pending,
  reviewed,
  actioned,
  rejected;

  String get value => name;

  static MeetingReportStatus fromValue(String? value) {
    return MeetingReportStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => MeetingReportStatus.pending,
    );
  }
}

extension MeetingReportStatusTransition on MeetingReportStatus {
  bool canTransitionTo(MeetingReportStatus next) {
    switch (this) {
      case MeetingReportStatus.pending:
        return next == MeetingReportStatus.reviewed ||
            next == MeetingReportStatus.rejected;
      case MeetingReportStatus.reviewed:
        return next == MeetingReportStatus.actioned ||
            next == MeetingReportStatus.rejected;
      case MeetingReportStatus.actioned:
      case MeetingReportStatus.rejected:
        return false;
    }
  }
}
