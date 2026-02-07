import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
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

          // Format JSON
          String jsonText = '';
          try {
            if (payload != null) {
              jsonText = const JsonEncoder.withIndent('  ').convert(payload);
            } else if (meta != null && meta.content.isNotEmpty) {
              // Fallback to meta.content if it's a JSON string
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
