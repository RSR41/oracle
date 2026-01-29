// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      name: json['name'] as String,
      birthDate: json['birthDate'] as String,
      birthTime: json['birthTime'] as String,
      isUnknownTime: json['isUnknownTime'] as bool,
      gender: json['gender'] as String,
      isSolar: json['isSolar'] as bool,
      isLeapMonth: json['isLeapMonth'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthDate': instance.birthDate,
      'birthTime': instance.birthTime,
      'isUnknownTime': instance.isUnknownTime,
      'gender': instance.gender,
      'isSolar': instance.isSolar,
      'isLeapMonth': instance.isLeapMonth,
    };
