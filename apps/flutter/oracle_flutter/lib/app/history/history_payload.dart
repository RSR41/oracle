class HistoryPayload {
  static const int schemaVersion = 1;

  static Map<String, dynamic> wrap({
    required String feature,
    required Map<String, dynamic> summary,
    required Map<String, dynamic> data,
    Map<String, dynamic>? extra,
  }) {
    return {
      'schemaVersion': schemaVersion,
      'feature': feature,
      'summary': summary,
      'data': data,
      if (extra != null) 'extra': extra,
    };
  }
}

