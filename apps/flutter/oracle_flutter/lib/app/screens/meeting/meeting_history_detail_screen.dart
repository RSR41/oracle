import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../database/history_repository.dart';
import '../../models/fortune_result.dart';

class MeetingHistoryDetailScreen extends StatelessWidget {
  final String id;
  final dynamic extra; // Optional meta (FortuneResult)

  const MeetingHistoryDetailScreen({super.key, required this.id, this.extra});

  @override
  Widget build(BuildContext context) {
    final HistoryRepository repo = HistoryRepository();
    final FortuneResult? meta = extra is FortuneResult
        ? extra as FortuneResult
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Meeting 기록 상세'), centerTitle: true),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: repo.getPayload(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final payload = snapshot.data;
          final eventData = _extractEventData(payload);
          final eventType = _eventType(meta?.type, eventData);

          // Format JSON
          String jsonText = '';
          try {
            if (payload != null) {
              jsonText = const JsonEncoder.withIndent('  ').convert(payload);
            } else if (meta != null && meta.content.isNotEmpty) {
              final decoded = jsonDecode(meta.content);
              jsonText = const JsonEncoder.withIndent('  ').convert(decoded);
            }
          } catch (_) {
            jsonText = meta?.content ?? '(내용 없음)';
          }

          if (jsonText.isEmpty) jsonText = '(내용 없음)';

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoTile('ID', id),
                        if (meta != null) ...[
                          _infoTile('Type', meta.type),
                          _infoTile('Title', meta.title),
                          _infoTile('Date', meta.date),
                          _infoTile('Summary', meta.summary),
                          _infoTile('Created', meta.createdAt),
                        ],
                        const SizedBox(height: 20),
                        _buildParsedPayload(eventType, eventData),
                        const SizedBox(height: 24),
                        const Text(
                          'Payload (JSON)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                          child: SelectableText(
                            jsonText,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.copy),
                        label: const Text('복사'),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: jsonText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('JSON이 클립보드에 복사되었습니다.'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('닫기'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _extractEventData(Map<String, dynamic>? payload) {
    if (payload == null) return const {};
    final dynamic data = payload['data'];
    if (data is Map<String, dynamic>) return data;
    return payload;
  }

  String _eventType(String? metaType, Map<String, dynamic> eventData) {
    final dynamic type = eventData['type'];
    if (type is String && type.isNotEmpty) return type;
    return metaType ?? '';
  }

  Widget _buildParsedPayload(String type, Map<String, dynamic> eventData) {
    if (eventData.isEmpty) {
      return const Text('파싱 가능한 payload 정보가 없습니다.');
    }

    final meta = eventData['meta'] is Map<String, dynamic>
        ? eventData['meta'] as Map<String, dynamic>
        : const <String, dynamic>{};

    List<Widget> rowsFor(List<String> keys) => keys
        .where((k) => meta[k] != null || eventData[k] != null)
        .map(
          (k) => _infoTile(
            k,
            (meta[k] ?? eventData[k]).toString(),
          ),
        )
        .toList();

    switch (type) {
      case 'meeting_profile_completed':
        return _parsedSection('프로필 완료', rowsFor(['userId', 'nickname', 'regionCode']));
      case 'meeting_recommendation_served':
        return _parsedSection('추천 카드 노출', rowsFor(['myUserId', 'targetUserId', 'recommendationIndex']));
      case 'meeting_compatibility_snapshot':
        return _parsedSection('궁합 스냅샷', rowsFor(['myUserId', 'targetUserId', 'score']));
      case 'meeting_match_created':
      case 'meeting_match':
        return _parsedSection('매칭 성립', rowsFor(['matchId', 'myUserId', 'targetUserId', 'score']));
      case 'meeting_report_submitted':
      case 'meeting_report':
        return _parsedSection('신고 접수', rowsFor(['matchId', 'reporterId', 'reason']));
      case 'meeting_block':
        return _parsedSection('사용자 차단', rowsFor(['blockerUserId', 'blockedUserId']));
      default:
        return _parsedSection(
          '이벤트 파싱',
          rowsFor(['type', 'title', 'body', 'createdAt']),
        );
    }
  }

  Widget _parsedSection(String title, List<Widget> children) {
    if (children.isEmpty) {
      return Text('$title: 표시할 필드가 없습니다.');
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
