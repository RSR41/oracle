enum MeetingNotificationEventType {
  meetingMatchCreated,
  meetingMessageReceived,
}

extension MeetingNotificationEventTypeValue on MeetingNotificationEventType {
  String get value {
    switch (this) {
      case MeetingNotificationEventType.meetingMatchCreated:
        return 'meeting_match_created';
      case MeetingNotificationEventType.meetingMessageReceived:
        return 'meeting_message_received';
    }
  }
}

class MeetingNotificationEvent {
  final MeetingNotificationEventType type;
  final String matchId;
  final String title;
  final String body;
  final Map<String, dynamic> payload;

  const MeetingNotificationEvent({
    required this.type,
    required this.matchId,
    required this.title,
    required this.body,
    this.payload = const {},
  });
}
