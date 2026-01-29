import 'package:freezed_annotation/freezed_annotation.dart';

part 'history.freezed.dart';
part 'history.g.dart';

@freezed
class History with _$History {
  const factory History({
    required String id,
    required String type, // fortune, compatibility, etc.
    required String createdAt,
    required Map<String, dynamic> result, // The result data
    required String summary, // Short text for list view
  }) = _History;

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
}
