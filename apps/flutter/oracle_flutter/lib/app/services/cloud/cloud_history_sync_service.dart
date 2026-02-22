import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:oracle_flutter/app/config/feature_flags.dart';
import 'package:oracle_flutter/app/config/supabase_config.dart';
import 'package:oracle_flutter/app/database/history_repository.dart';

class CloudHistorySyncService {
  CloudHistorySyncService._();

  static const String _table = 'history_records';

  static bool get _enabled =>
      FeatureFlags.cloudSync && SupabaseConfig.isConfigured;

  static Future<void> syncOnStartup() async {
    if (!_enabled) {
      debugPrint('Cloud sync skipped: disabled or missing Supabase config.');
      return;
    }

    try {
      final client = Supabase.instance.client;
      await _ensureAuth(client);

      final repo = HistoryRepository();
      final localRows = await repo.getAllRows();

      if (localRows.isNotEmpty) {
        final payload = localRows.map(_toCloudRow).toList();
        await client.from(_table).upsert(payload, onConflict: 'id');
      }

      final remoteRows = await client
          .from(_table)
          .select()
          .order('created_at', ascending: false)
          .limit(1000);

      for (final row in remoteRows) {
        final record = Map<String, dynamic>.from(row as Map);
        await repo.upsertRawRow(_toLocalRow(record));
      }

      debugPrint(
        'Cloud sync complete. local=${localRows.length}, remote=${remoteRows.length}',
      );
    } catch (e, st) {
      debugPrint('Cloud sync failed: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static Future<void> _ensureAuth(SupabaseClient client) async {
    final session = client.auth.currentSession;
    if (session != null) return;
    await client.auth.signInAnonymously();
  }

  static Map<String, dynamic> _toCloudRow(Map<String, dynamic> row) {
    return {
      'id': row['id'],
      'type': row['type'],
      'title': row['title'],
      'summary': row['summary'],
      'content': row['content'],
      'overall_score': row['overallScore'],
      'date': row['date'],
      'created_at': row['createdAt'],
      'payload_json': row['payloadJson'],
      'media_paths': row['mediaPaths'],
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> _toLocalRow(Map<String, dynamic> row) {
    final payloadJson = row['payload_json'];
    final mediaPaths = row['media_paths'];

    return {
      'id': row['id'] as String,
      'type': row['type'] as String,
      'title': row['title'] as String,
      'summary': row['summary'] as String? ?? '',
      'content': row['content'] as String? ?? '',
      'overallScore': (row['overall_score'] as num?)?.toInt() ?? 0,
      'date': row['date'] as String,
      'createdAt': row['created_at'] as String,
      'payloadJson': payloadJson == null
          ? null
          : payloadJson is String
          ? payloadJson
          : jsonEncode(payloadJson),
      'mediaPaths': mediaPaths == null
          ? null
          : mediaPaths is String
          ? mediaPaths
          : jsonEncode(mediaPaths),
    };
  }
}

