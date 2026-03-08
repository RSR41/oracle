import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oracle_meeting/meeting.dart';

class MeetingNotificationService {
  MeetingNotificationService._();

  static final MeetingNotificationService instance =
      MeetingNotificationService._();

  static const AndroidNotificationChannel _meetingChannel =
      AndroidNotificationChannel(
    'meeting_events',
    'Meeting Events',
    description: '매칭/메시지 등 미팅 관련 알림',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    await createNotificationChannel();

    _initialized = true;
  }

  Future<void> requestPermission() async {
    if (kIsWeb) return;

    await initialize();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      final iosPlugin =
          _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

      final macPlugin =
          _plugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
      await macPlugin?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> createNotificationChannel() async {
    if (kIsWeb) return;

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_meetingChannel);
  }

  Future<void> bindMeetingHooks() async {
    await initialize();

    MeetingService.globalOnNotificationEvent = (event) async {
      await notifyEvent(event);
    };
  }

  Future<void> notifyEvent(MeetingNotificationEvent event) async {
    if (kIsWeb) return;

    if (MeetingService.activeForegroundMatchId == event.matchId) {
      return;
    }

    final notificationId =
        (event.matchId.hashCode ^ event.type.value.hashCode) & 0x7fffffff;

    await _plugin.show(
      notificationId,
      event.title,
      event.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _meetingChannel.id,
          _meetingChannel.name,
          channelDescription: _meetingChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: event.payload.isEmpty ? null : event.payload.toString(),
    );
  }
}
