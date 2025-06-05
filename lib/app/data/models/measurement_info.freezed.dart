// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeasurementInfo {
  String get interval;
  String get question;
  String get site_id;
  String get type_id;
  String get type_name;
  String get unit;
  List<MeasurementValue> get values;
  @JsonKey(fromJson: _toDateTime)
  DateTime get updatedAt;

  /// Create a copy of MeasurementInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MeasurementInfoCopyWith<MeasurementInfo> get copyWith =>
      _$MeasurementInfoCopyWithImpl<MeasurementInfo>(
          this as MeasurementInfo, _$identity);

  /// Serializes this MeasurementInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MeasurementInfo &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.site_id, site_id) || other.site_id == site_id) &&
            (identical(other.type_id, type_id) || other.type_id == type_id) &&
            (identical(other.type_name, type_name) ||
                other.type_name == type_name) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            const DeepCollectionEquality().equals(other.values, values) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      interval,
      question,
      site_id,
      type_id,
      type_name,
      unit,
      const DeepCollectionEquality().hash(values),
      updatedAt);

  @override
  String toString() {
    return 'MeasurementInfo(interval: $interval, question: $question, site_id: $site_id, type_id: $type_id, type_name: $type_name, unit: $unit, values: $values, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $MeasurementInfoCopyWith<$Res> {
  factory $MeasurementInfoCopyWith(
          MeasurementInfo value, $Res Function(MeasurementInfo) _then) =
      _$MeasurementInfoCopyWithImpl;
  @useResult
  $Res call(
      {String interval,
      String question,
      String site_id,
      String type_id,
      String type_name,
      String unit,
      List<MeasurementValue> values,
      @JsonKey(fromJson: _toDateTime) DateTime updatedAt});
}

/// @nodoc
class _$MeasurementInfoCopyWithImpl<$Res>
    implements $MeasurementInfoCopyWith<$Res> {
  _$MeasurementInfoCopyWithImpl(this._self, this._then);

  final MeasurementInfo _self;
  final $Res Function(MeasurementInfo) _then;

  /// Create a copy of MeasurementInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interval = null,
    Object? question = null,
    Object? site_id = null,
    Object? type_id = null,
    Object? type_name = null,
    Object? unit = null,
    Object? values = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      interval: null == interval
          ? _self.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      site_id: null == site_id
          ? _self.site_id
          : site_id // ignore: cast_nullable_to_non_nullable
              as String,
      type_id: null == type_id
          ? _self.type_id
          : type_id // ignore: cast_nullable_to_non_nullable
              as String,
      type_name: null == type_name
          ? _self.type_name
          : type_name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _self.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<MeasurementValue>,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _MeasurementInfo implements MeasurementInfo {
  const _MeasurementInfo(
      {required this.interval,
      required this.question,
      required this.site_id,
      required this.type_id,
      required this.type_name,
      required this.unit,
      required final List<MeasurementValue> values,
      @JsonKey(fromJson: _toDateTime) required this.updatedAt})
      : _values = values;
  factory _MeasurementInfo.fromJson(Map<String, dynamic> json) =>
      _$MeasurementInfoFromJson(json);

  @override
  final String interval;
  @override
  final String question;
  @override
  final String site_id;
  @override
  final String type_id;
  @override
  final String type_name;
  @override
  final String unit;
  final List<MeasurementValue> _values;
  @override
  List<MeasurementValue> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  @JsonKey(fromJson: _toDateTime)
  final DateTime updatedAt;

  /// Create a copy of MeasurementInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MeasurementInfoCopyWith<_MeasurementInfo> get copyWith =>
      __$MeasurementInfoCopyWithImpl<_MeasurementInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MeasurementInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MeasurementInfo &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.site_id, site_id) || other.site_id == site_id) &&
            (identical(other.type_id, type_id) || other.type_id == type_id) &&
            (identical(other.type_name, type_name) ||
                other.type_name == type_name) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      interval,
      question,
      site_id,
      type_id,
      type_name,
      unit,
      const DeepCollectionEquality().hash(_values),
      updatedAt);

  @override
  String toString() {
    return 'MeasurementInfo(interval: $interval, question: $question, site_id: $site_id, type_id: $type_id, type_name: $type_name, unit: $unit, values: $values, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$MeasurementInfoCopyWith<$Res>
    implements $MeasurementInfoCopyWith<$Res> {
  factory _$MeasurementInfoCopyWith(
          _MeasurementInfo value, $Res Function(_MeasurementInfo) _then) =
      __$MeasurementInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String interval,
      String question,
      String site_id,
      String type_id,
      String type_name,
      String unit,
      List<MeasurementValue> values,
      @JsonKey(fromJson: _toDateTime) DateTime updatedAt});
}

/// @nodoc
class __$MeasurementInfoCopyWithImpl<$Res>
    implements _$MeasurementInfoCopyWith<$Res> {
  __$MeasurementInfoCopyWithImpl(this._self, this._then);

  final _MeasurementInfo _self;
  final $Res Function(_MeasurementInfo) _then;

  /// Create a copy of MeasurementInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? interval = null,
    Object? question = null,
    Object? site_id = null,
    Object? type_id = null,
    Object? type_name = null,
    Object? unit = null,
    Object? values = null,
    Object? updatedAt = null,
  }) {
    return _then(_MeasurementInfo(
      interval: null == interval
          ? _self.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      site_id: null == site_id
          ? _self.site_id
          : site_id // ignore: cast_nullable_to_non_nullable
              as String,
      type_id: null == type_id
          ? _self.type_id
          : type_id // ignore: cast_nullable_to_non_nullable
              as String,
      type_name: null == type_name
          ? _self.type_name
          : type_name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _self._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<MeasurementValue>,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
