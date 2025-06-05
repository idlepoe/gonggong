import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/app_utils.dart';

part 'measurement_value.freezed.dart';

part 'measurement_value.g.dart';

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
abstract class MeasurementValue with _$MeasurementValue {
  const factory MeasurementValue({
    required String name,
    required double value,
    @JsonKey(fromJson: _toDateTime) required DateTime startDate,
    @JsonKey(fromJson: _toDateTime) required DateTime endDate,
    @JsonKey(fromJson: _toDateTime) required DateTime createdAt,
  }) = _MeasurementValue;

  factory MeasurementValue.fromJson(Map<String, dynamic> json) =>
      _$MeasurementValueFromJson(json);
}
