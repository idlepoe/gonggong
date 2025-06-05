// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeasurementValue {
  String get name;
  double get value;
  @JsonKey(fromJson: _toDateTime)
  DateTime get startDate;
  @JsonKey(fromJson: _toDateTime)
  DateTime get endDate;
  @JsonKey(fromJson: _toDateTime)
  DateTime get createdAt;

  /// Create a copy of MeasurementValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MeasurementValueCopyWith<MeasurementValue> get copyWith =>
      _$MeasurementValueCopyWithImpl<MeasurementValue>(
          this as MeasurementValue, _$identity);

  /// Serializes this MeasurementValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MeasurementValue &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, value, startDate, endDate, createdAt);

  @override
  String toString() {
    return 'MeasurementValue(name: $name, value: $value, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $MeasurementValueCopyWith<$Res> {
  factory $MeasurementValueCopyWith(
          MeasurementValue value, $Res Function(MeasurementValue) _then) =
      _$MeasurementValueCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      double value,
      @JsonKey(fromJson: _toDateTime) DateTime startDate,
      @JsonKey(fromJson: _toDateTime) DateTime endDate,
      @JsonKey(fromJson: _toDateTime) DateTime createdAt});
}

/// @nodoc
class _$MeasurementValueCopyWithImpl<$Res>
    implements $MeasurementValueCopyWith<$Res> {
  _$MeasurementValueCopyWithImpl(this._self, this._then);

  final MeasurementValue _self;
  final $Res Function(MeasurementValue) _then;

  /// Create a copy of MeasurementValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _MeasurementValue implements MeasurementValue {
  const _MeasurementValue(
      {required this.name,
      required this.value,
      @JsonKey(fromJson: _toDateTime) required this.startDate,
      @JsonKey(fromJson: _toDateTime) required this.endDate,
      @JsonKey(fromJson: _toDateTime) required this.createdAt});
  factory _MeasurementValue.fromJson(Map<String, dynamic> json) =>
      _$MeasurementValueFromJson(json);

  @override
  final String name;
  @override
  final double value;
  @override
  @JsonKey(fromJson: _toDateTime)
  final DateTime startDate;
  @override
  @JsonKey(fromJson: _toDateTime)
  final DateTime endDate;
  @override
  @JsonKey(fromJson: _toDateTime)
  final DateTime createdAt;

  /// Create a copy of MeasurementValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MeasurementValueCopyWith<_MeasurementValue> get copyWith =>
      __$MeasurementValueCopyWithImpl<_MeasurementValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MeasurementValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MeasurementValue &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, value, startDate, endDate, createdAt);

  @override
  String toString() {
    return 'MeasurementValue(name: $name, value: $value, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$MeasurementValueCopyWith<$Res>
    implements $MeasurementValueCopyWith<$Res> {
  factory _$MeasurementValueCopyWith(
          _MeasurementValue value, $Res Function(_MeasurementValue) _then) =
      __$MeasurementValueCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      double value,
      @JsonKey(fromJson: _toDateTime) DateTime startDate,
      @JsonKey(fromJson: _toDateTime) DateTime endDate,
      @JsonKey(fromJson: _toDateTime) DateTime createdAt});
}

/// @nodoc
class __$MeasurementValueCopyWithImpl<$Res>
    implements _$MeasurementValueCopyWith<$Res> {
  __$MeasurementValueCopyWithImpl(this._self, this._then);

  final _MeasurementValue _self;
  final $Res Function(_MeasurementValue) _then;

  /// Create a copy of MeasurementValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
  }) {
    return _then(_MeasurementValue(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
