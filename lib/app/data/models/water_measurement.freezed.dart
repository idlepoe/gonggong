// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterMeasurement {
  String get MSR_DATE;
  String get MSR_TIME;
  String get SITE_ID;
  String get W_CN;
  String get W_DO;
  String get W_PH;
  String get W_PHEN;
  String get W_TEMP;
  String get W_TN;
  String get W_TOC;
  String get W_TP;
  @JsonKey(fromJson: _toDateTime)
  DateTime get createdAt;

  /// Create a copy of WaterMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WaterMeasurementCopyWith<WaterMeasurement> get copyWith =>
      _$WaterMeasurementCopyWithImpl<WaterMeasurement>(
          this as WaterMeasurement, _$identity);

  /// Serializes this WaterMeasurement to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WaterMeasurement &&
            (identical(other.MSR_DATE, MSR_DATE) ||
                other.MSR_DATE == MSR_DATE) &&
            (identical(other.MSR_TIME, MSR_TIME) ||
                other.MSR_TIME == MSR_TIME) &&
            (identical(other.SITE_ID, SITE_ID) || other.SITE_ID == SITE_ID) &&
            (identical(other.W_CN, W_CN) || other.W_CN == W_CN) &&
            (identical(other.W_DO, W_DO) || other.W_DO == W_DO) &&
            (identical(other.W_PH, W_PH) || other.W_PH == W_PH) &&
            (identical(other.W_PHEN, W_PHEN) || other.W_PHEN == W_PHEN) &&
            (identical(other.W_TEMP, W_TEMP) || other.W_TEMP == W_TEMP) &&
            (identical(other.W_TN, W_TN) || other.W_TN == W_TN) &&
            (identical(other.W_TOC, W_TOC) || other.W_TOC == W_TOC) &&
            (identical(other.W_TP, W_TP) || other.W_TP == W_TP) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, MSR_DATE, MSR_TIME, SITE_ID,
      W_CN, W_DO, W_PH, W_PHEN, W_TEMP, W_TN, W_TOC, W_TP, createdAt);

  @override
  String toString() {
    return 'WaterMeasurement(MSR_DATE: $MSR_DATE, MSR_TIME: $MSR_TIME, SITE_ID: $SITE_ID, W_CN: $W_CN, W_DO: $W_DO, W_PH: $W_PH, W_PHEN: $W_PHEN, W_TEMP: $W_TEMP, W_TN: $W_TN, W_TOC: $W_TOC, W_TP: $W_TP, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $WaterMeasurementCopyWith<$Res> {
  factory $WaterMeasurementCopyWith(
          WaterMeasurement value, $Res Function(WaterMeasurement) _then) =
      _$WaterMeasurementCopyWithImpl;
  @useResult
  $Res call(
      {String MSR_DATE,
      String MSR_TIME,
      String SITE_ID,
      String W_CN,
      String W_DO,
      String W_PH,
      String W_PHEN,
      String W_TEMP,
      String W_TN,
      String W_TOC,
      String W_TP,
      @JsonKey(fromJson: _toDateTime) DateTime createdAt});
}

/// @nodoc
class _$WaterMeasurementCopyWithImpl<$Res>
    implements $WaterMeasurementCopyWith<$Res> {
  _$WaterMeasurementCopyWithImpl(this._self, this._then);

  final WaterMeasurement _self;
  final $Res Function(WaterMeasurement) _then;

  /// Create a copy of WaterMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? MSR_DATE = null,
    Object? MSR_TIME = null,
    Object? SITE_ID = null,
    Object? W_CN = null,
    Object? W_DO = null,
    Object? W_PH = null,
    Object? W_PHEN = null,
    Object? W_TEMP = null,
    Object? W_TN = null,
    Object? W_TOC = null,
    Object? W_TP = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      MSR_DATE: null == MSR_DATE
          ? _self.MSR_DATE
          : MSR_DATE // ignore: cast_nullable_to_non_nullable
              as String,
      MSR_TIME: null == MSR_TIME
          ? _self.MSR_TIME
          : MSR_TIME // ignore: cast_nullable_to_non_nullable
              as String,
      SITE_ID: null == SITE_ID
          ? _self.SITE_ID
          : SITE_ID // ignore: cast_nullable_to_non_nullable
              as String,
      W_CN: null == W_CN
          ? _self.W_CN
          : W_CN // ignore: cast_nullable_to_non_nullable
              as String,
      W_DO: null == W_DO
          ? _self.W_DO
          : W_DO // ignore: cast_nullable_to_non_nullable
              as String,
      W_PH: null == W_PH
          ? _self.W_PH
          : W_PH // ignore: cast_nullable_to_non_nullable
              as String,
      W_PHEN: null == W_PHEN
          ? _self.W_PHEN
          : W_PHEN // ignore: cast_nullable_to_non_nullable
              as String,
      W_TEMP: null == W_TEMP
          ? _self.W_TEMP
          : W_TEMP // ignore: cast_nullable_to_non_nullable
              as String,
      W_TN: null == W_TN
          ? _self.W_TN
          : W_TN // ignore: cast_nullable_to_non_nullable
              as String,
      W_TOC: null == W_TOC
          ? _self.W_TOC
          : W_TOC // ignore: cast_nullable_to_non_nullable
              as String,
      W_TP: null == W_TP
          ? _self.W_TP
          : W_TP // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _WaterMeasurement implements WaterMeasurement {
  const _WaterMeasurement(
      {required this.MSR_DATE,
      required this.MSR_TIME,
      required this.SITE_ID,
      required this.W_CN,
      required this.W_DO,
      required this.W_PH,
      required this.W_PHEN,
      required this.W_TEMP,
      required this.W_TN,
      required this.W_TOC,
      required this.W_TP,
      @JsonKey(fromJson: _toDateTime) required this.createdAt});
  factory _WaterMeasurement.fromJson(Map<String, dynamic> json) =>
      _$WaterMeasurementFromJson(json);

  @override
  final String MSR_DATE;
  @override
  final String MSR_TIME;
  @override
  final String SITE_ID;
  @override
  final String W_CN;
  @override
  final String W_DO;
  @override
  final String W_PH;
  @override
  final String W_PHEN;
  @override
  final String W_TEMP;
  @override
  final String W_TN;
  @override
  final String W_TOC;
  @override
  final String W_TP;
  @override
  @JsonKey(fromJson: _toDateTime)
  final DateTime createdAt;

  /// Create a copy of WaterMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WaterMeasurementCopyWith<_WaterMeasurement> get copyWith =>
      __$WaterMeasurementCopyWithImpl<_WaterMeasurement>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WaterMeasurementToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WaterMeasurement &&
            (identical(other.MSR_DATE, MSR_DATE) ||
                other.MSR_DATE == MSR_DATE) &&
            (identical(other.MSR_TIME, MSR_TIME) ||
                other.MSR_TIME == MSR_TIME) &&
            (identical(other.SITE_ID, SITE_ID) || other.SITE_ID == SITE_ID) &&
            (identical(other.W_CN, W_CN) || other.W_CN == W_CN) &&
            (identical(other.W_DO, W_DO) || other.W_DO == W_DO) &&
            (identical(other.W_PH, W_PH) || other.W_PH == W_PH) &&
            (identical(other.W_PHEN, W_PHEN) || other.W_PHEN == W_PHEN) &&
            (identical(other.W_TEMP, W_TEMP) || other.W_TEMP == W_TEMP) &&
            (identical(other.W_TN, W_TN) || other.W_TN == W_TN) &&
            (identical(other.W_TOC, W_TOC) || other.W_TOC == W_TOC) &&
            (identical(other.W_TP, W_TP) || other.W_TP == W_TP) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, MSR_DATE, MSR_TIME, SITE_ID,
      W_CN, W_DO, W_PH, W_PHEN, W_TEMP, W_TN, W_TOC, W_TP, createdAt);

  @override
  String toString() {
    return 'WaterMeasurement(MSR_DATE: $MSR_DATE, MSR_TIME: $MSR_TIME, SITE_ID: $SITE_ID, W_CN: $W_CN, W_DO: $W_DO, W_PH: $W_PH, W_PHEN: $W_PHEN, W_TEMP: $W_TEMP, W_TN: $W_TN, W_TOC: $W_TOC, W_TP: $W_TP, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$WaterMeasurementCopyWith<$Res>
    implements $WaterMeasurementCopyWith<$Res> {
  factory _$WaterMeasurementCopyWith(
          _WaterMeasurement value, $Res Function(_WaterMeasurement) _then) =
      __$WaterMeasurementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String MSR_DATE,
      String MSR_TIME,
      String SITE_ID,
      String W_CN,
      String W_DO,
      String W_PH,
      String W_PHEN,
      String W_TEMP,
      String W_TN,
      String W_TOC,
      String W_TP,
      @JsonKey(fromJson: _toDateTime) DateTime createdAt});
}

/// @nodoc
class __$WaterMeasurementCopyWithImpl<$Res>
    implements _$WaterMeasurementCopyWith<$Res> {
  __$WaterMeasurementCopyWithImpl(this._self, this._then);

  final _WaterMeasurement _self;
  final $Res Function(_WaterMeasurement) _then;

  /// Create a copy of WaterMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? MSR_DATE = null,
    Object? MSR_TIME = null,
    Object? SITE_ID = null,
    Object? W_CN = null,
    Object? W_DO = null,
    Object? W_PH = null,
    Object? W_PHEN = null,
    Object? W_TEMP = null,
    Object? W_TN = null,
    Object? W_TOC = null,
    Object? W_TP = null,
    Object? createdAt = null,
  }) {
    return _then(_WaterMeasurement(
      MSR_DATE: null == MSR_DATE
          ? _self.MSR_DATE
          : MSR_DATE // ignore: cast_nullable_to_non_nullable
              as String,
      MSR_TIME: null == MSR_TIME
          ? _self.MSR_TIME
          : MSR_TIME // ignore: cast_nullable_to_non_nullable
              as String,
      SITE_ID: null == SITE_ID
          ? _self.SITE_ID
          : SITE_ID // ignore: cast_nullable_to_non_nullable
              as String,
      W_CN: null == W_CN
          ? _self.W_CN
          : W_CN // ignore: cast_nullable_to_non_nullable
              as String,
      W_DO: null == W_DO
          ? _self.W_DO
          : W_DO // ignore: cast_nullable_to_non_nullable
              as String,
      W_PH: null == W_PH
          ? _self.W_PH
          : W_PH // ignore: cast_nullable_to_non_nullable
              as String,
      W_PHEN: null == W_PHEN
          ? _self.W_PHEN
          : W_PHEN // ignore: cast_nullable_to_non_nullable
              as String,
      W_TEMP: null == W_TEMP
          ? _self.W_TEMP
          : W_TEMP // ignore: cast_nullable_to_non_nullable
              as String,
      W_TN: null == W_TN
          ? _self.W_TN
          : W_TN // ignore: cast_nullable_to_non_nullable
              as String,
      W_TOC: null == W_TOC
          ? _self.W_TOC
          : W_TOC // ignore: cast_nullable_to_non_nullable
              as String,
      W_TP: null == W_TP
          ? _self.W_TP
          : W_TP // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
