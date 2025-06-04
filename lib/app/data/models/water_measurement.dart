import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_measurement.freezed.dart';

part 'water_measurement.g.dart';

DateTime _toDateTime(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is Map &&
      value.containsKey('_seconds') &&
      value.containsKey('_nanoseconds')) {
    return DateTime.fromMillisecondsSinceEpoch(
      (value['_seconds'] as int) * 1000,
    );
  }
  if (value == null) {
    return DateTime.now();
  }
  return value as DateTime;
}

@freezed
abstract class WaterMeasurement with _$WaterMeasurement {
  const factory WaterMeasurement({
    required String MSR_DATE,
    required String MSR_TIME,
    required String SITE_ID,
    required String W_CN,
    required String W_DO,
    required String W_PH,
    required String W_PHEN,
    required String W_TEMP,
    required String W_TN,
    required String W_TOC,
    required String W_TP,
    @JsonKey(fromJson: _toDateTime) required DateTime createdAt,
  }) = _WaterMeasurement;

  factory WaterMeasurement.fromJson(Map<String, dynamic> json) =>
      _$WaterMeasurementFromJson(json);
}
