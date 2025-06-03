// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Challenge {
  String get id;
  String get siteId;
  String get snapshotId;
  String get title;
  double get delta;
  String get field;
  double get baseValue;
  double get targetValue;
  @JsonKey(fromJson: _toDateTime)
  DateTime get createdAt;
  @JsonKey(fromJson: _toDateTime)
  DateTime get deadline;
  double get odds;
  bool get resolved;
  bool? get result;

  /// Create a copy of Challenge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChallengeCopyWith<Challenge> get copyWith =>
      _$ChallengeCopyWithImpl<Challenge>(this as Challenge, _$identity);

  /// Serializes this Challenge to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Challenge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.snapshotId, snapshotId) ||
                other.snapshotId == snapshotId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.baseValue, baseValue) ||
                other.baseValue == baseValue) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.odds, odds) || other.odds == odds) &&
            (identical(other.resolved, resolved) ||
                other.resolved == resolved) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      siteId,
      snapshotId,
      title,
      delta,
      field,
      baseValue,
      targetValue,
      createdAt,
      deadline,
      odds,
      resolved,
      result);

  @override
  String toString() {
    return 'Challenge(id: $id, siteId: $siteId, snapshotId: $snapshotId, title: $title, delta: $delta, field: $field, baseValue: $baseValue, targetValue: $targetValue, createdAt: $createdAt, deadline: $deadline, odds: $odds, resolved: $resolved, result: $result)';
  }
}

/// @nodoc
abstract mixin class $ChallengeCopyWith<$Res> {
  factory $ChallengeCopyWith(Challenge value, $Res Function(Challenge) _then) =
      _$ChallengeCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String siteId,
      String snapshotId,
      String title,
      double delta,
      String field,
      double baseValue,
      double targetValue,
      @JsonKey(fromJson: _toDateTime) DateTime createdAt,
      @JsonKey(fromJson: _toDateTime) DateTime deadline,
      double odds,
      bool resolved,
      bool? result});
}

/// @nodoc
class _$ChallengeCopyWithImpl<$Res> implements $ChallengeCopyWith<$Res> {
  _$ChallengeCopyWithImpl(this._self, this._then);

  final Challenge _self;
  final $Res Function(Challenge) _then;

  /// Create a copy of Challenge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? siteId = null,
    Object? snapshotId = null,
    Object? title = null,
    Object? delta = null,
    Object? field = null,
    Object? baseValue = null,
    Object? targetValue = null,
    Object? createdAt = null,
    Object? deadline = null,
    Object? odds = null,
    Object? resolved = null,
    Object? result = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      siteId: null == siteId
          ? _self.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as String,
      snapshotId: null == snapshotId
          ? _self.snapshotId
          : snapshotId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      delta: null == delta
          ? _self.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as double,
      field: null == field
          ? _self.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      baseValue: null == baseValue
          ? _self.baseValue
          : baseValue // ignore: cast_nullable_to_non_nullable
              as double,
      targetValue: null == targetValue
          ? _self.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deadline: null == deadline
          ? _self.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      odds: null == odds
          ? _self.odds
          : odds // ignore: cast_nullable_to_non_nullable
              as double,
      resolved: null == resolved
          ? _self.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Challenge implements Challenge {
  const _Challenge(
      {required this.id,
      required this.siteId,
      required this.snapshotId,
      required this.title,
      required this.delta,
      required this.field,
      required this.baseValue,
      required this.targetValue,
      @JsonKey(fromJson: _toDateTime) required this.createdAt,
      @JsonKey(fromJson: _toDateTime) required this.deadline,
      required this.odds,
      required this.resolved,
      this.result});
  factory _Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  @override
  final String id;
  @override
  final String siteId;
  @override
  final String snapshotId;
  @override
  final String title;
  @override
  final double delta;
  @override
  final String field;
  @override
  final double baseValue;
  @override
  final double targetValue;
  @override
  @JsonKey(fromJson: _toDateTime)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _toDateTime)
  final DateTime deadline;
  @override
  final double odds;
  @override
  final bool resolved;
  @override
  final bool? result;

  /// Create a copy of Challenge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChallengeCopyWith<_Challenge> get copyWith =>
      __$ChallengeCopyWithImpl<_Challenge>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChallengeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Challenge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.snapshotId, snapshotId) ||
                other.snapshotId == snapshotId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.baseValue, baseValue) ||
                other.baseValue == baseValue) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.odds, odds) || other.odds == odds) &&
            (identical(other.resolved, resolved) ||
                other.resolved == resolved) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      siteId,
      snapshotId,
      title,
      delta,
      field,
      baseValue,
      targetValue,
      createdAt,
      deadline,
      odds,
      resolved,
      result);

  @override
  String toString() {
    return 'Challenge(id: $id, siteId: $siteId, snapshotId: $snapshotId, title: $title, delta: $delta, field: $field, baseValue: $baseValue, targetValue: $targetValue, createdAt: $createdAt, deadline: $deadline, odds: $odds, resolved: $resolved, result: $result)';
  }
}

/// @nodoc
abstract mixin class _$ChallengeCopyWith<$Res>
    implements $ChallengeCopyWith<$Res> {
  factory _$ChallengeCopyWith(
          _Challenge value, $Res Function(_Challenge) _then) =
      __$ChallengeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String siteId,
      String snapshotId,
      String title,
      double delta,
      String field,
      double baseValue,
      double targetValue,
      @JsonKey(fromJson: _toDateTime) DateTime createdAt,
      @JsonKey(fromJson: _toDateTime) DateTime deadline,
      double odds,
      bool resolved,
      bool? result});
}

/// @nodoc
class __$ChallengeCopyWithImpl<$Res> implements _$ChallengeCopyWith<$Res> {
  __$ChallengeCopyWithImpl(this._self, this._then);

  final _Challenge _self;
  final $Res Function(_Challenge) _then;

  /// Create a copy of Challenge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? siteId = null,
    Object? snapshotId = null,
    Object? title = null,
    Object? delta = null,
    Object? field = null,
    Object? baseValue = null,
    Object? targetValue = null,
    Object? createdAt = null,
    Object? deadline = null,
    Object? odds = null,
    Object? resolved = null,
    Object? result = freezed,
  }) {
    return _then(_Challenge(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      siteId: null == siteId
          ? _self.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as String,
      snapshotId: null == snapshotId
          ? _self.snapshotId
          : snapshotId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      delta: null == delta
          ? _self.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as double,
      field: null == field
          ? _self.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      baseValue: null == baseValue
          ? _self.baseValue
          : baseValue // ignore: cast_nullable_to_non_nullable
              as double,
      targetValue: null == targetValue
          ? _self.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deadline: null == deadline
          ? _self.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      odds: null == odds
          ? _self.odds
          : odds // ignore: cast_nullable_to_non_nullable
              as double,
      resolved: null == resolved
          ? _self.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
