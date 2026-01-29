// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  String get name => throw _privateConstructorUsedError;
  String get birthDate => throw _privateConstructorUsedError; // YYYY-MM-DD
  String get birthTime => throw _privateConstructorUsedError; // HH:mm
  bool get isUnknownTime => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError; // M/F
  bool get isSolar => throw _privateConstructorUsedError;
  bool get isLeapMonth => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
  @useResult
  $Res call(
      {String name,
      String birthDate,
      String birthTime,
      bool isUnknownTime,
      String gender,
      bool isSolar,
      bool isLeapMonth});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? birthDate = null,
    Object? birthTime = null,
    Object? isUnknownTime = null,
    Object? gender = null,
    Object? isSolar = null,
    Object? isLeapMonth = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String,
      birthTime: null == birthTime
          ? _value.birthTime
          : birthTime // ignore: cast_nullable_to_non_nullable
              as String,
      isUnknownTime: null == isUnknownTime
          ? _value.isUnknownTime
          : isUnknownTime // ignore: cast_nullable_to_non_nullable
              as bool,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      isSolar: null == isSolar
          ? _value.isSolar
          : isSolar // ignore: cast_nullable_to_non_nullable
              as bool,
      isLeapMonth: null == isLeapMonth
          ? _value.isLeapMonth
          : isLeapMonth // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileImplCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$ProfileImplCopyWith(
          _$ProfileImpl value, $Res Function(_$ProfileImpl) then) =
      __$$ProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String birthDate,
      String birthTime,
      bool isUnknownTime,
      String gender,
      bool isSolar,
      bool isLeapMonth});
}

/// @nodoc
class __$$ProfileImplCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$ProfileImpl>
    implements _$$ProfileImplCopyWith<$Res> {
  __$$ProfileImplCopyWithImpl(
      _$ProfileImpl _value, $Res Function(_$ProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? birthDate = null,
    Object? birthTime = null,
    Object? isUnknownTime = null,
    Object? gender = null,
    Object? isSolar = null,
    Object? isLeapMonth = null,
  }) {
    return _then(_$ProfileImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String,
      birthTime: null == birthTime
          ? _value.birthTime
          : birthTime // ignore: cast_nullable_to_non_nullable
              as String,
      isUnknownTime: null == isUnknownTime
          ? _value.isUnknownTime
          : isUnknownTime // ignore: cast_nullable_to_non_nullable
              as bool,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      isSolar: null == isSolar
          ? _value.isSolar
          : isSolar // ignore: cast_nullable_to_non_nullable
              as bool,
      isLeapMonth: null == isLeapMonth
          ? _value.isLeapMonth
          : isLeapMonth // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileImpl implements _Profile {
  const _$ProfileImpl(
      {required this.name,
      required this.birthDate,
      required this.birthTime,
      required this.isUnknownTime,
      required this.gender,
      required this.isSolar,
      this.isLeapMonth = false});

  factory _$ProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImplFromJson(json);

  @override
  final String name;
  @override
  final String birthDate;
// YYYY-MM-DD
  @override
  final String birthTime;
// HH:mm
  @override
  final bool isUnknownTime;
  @override
  final String gender;
// M/F
  @override
  final bool isSolar;
  @override
  @JsonKey()
  final bool isLeapMonth;

  @override
  String toString() {
    return 'Profile(name: $name, birthDate: $birthDate, birthTime: $birthTime, isUnknownTime: $isUnknownTime, gender: $gender, isSolar: $isSolar, isLeapMonth: $isLeapMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.birthTime, birthTime) ||
                other.birthTime == birthTime) &&
            (identical(other.isUnknownTime, isUnknownTime) ||
                other.isUnknownTime == isUnknownTime) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.isSolar, isSolar) || other.isSolar == isSolar) &&
            (identical(other.isLeapMonth, isLeapMonth) ||
                other.isLeapMonth == isLeapMonth));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, birthDate, birthTime,
      isUnknownTime, gender, isSolar, isLeapMonth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      __$$ProfileImplCopyWithImpl<_$ProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImplToJson(
      this,
    );
  }
}

abstract class _Profile implements Profile {
  const factory _Profile(
      {required final String name,
      required final String birthDate,
      required final String birthTime,
      required final bool isUnknownTime,
      required final String gender,
      required final bool isSolar,
      final bool isLeapMonth}) = _$ProfileImpl;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$ProfileImpl.fromJson;

  @override
  String get name;
  @override
  String get birthDate;
  @override // YYYY-MM-DD
  String get birthTime;
  @override // HH:mm
  bool get isUnknownTime;
  @override
  String get gender;
  @override // M/F
  bool get isSolar;
  @override
  bool get isLeapMonth;
  @override
  @JsonKey(ignore: true)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
