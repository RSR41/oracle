// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryImpl _$$HistoryImplFromJson(Map<String, dynamic> json) =>
    _$HistoryImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      createdAt: json['createdAt'] as String,
      result: json['result'] as Map<String, dynamic>,
      summary: json['summary'] as String,
    );

Map<String, dynamic> _$$HistoryImplToJson(_$HistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'createdAt': instance.createdAt,
      'result': instance.result,
      'summary': instance.summary,
    };
