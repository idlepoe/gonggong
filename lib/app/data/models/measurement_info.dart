import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gonggong/app/data/models/measurement_value.dart';

import '../utils/app_utils.dart';
import 'bet.dart';

part 'measurement_info.freezed.dart';

part 'measurement_info.g.dart';

DateTime _toDateTime(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return AppUtils.parseCompactDateTime(value);
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
abstract class MeasurementInfo with _$MeasurementInfo {
  const factory MeasurementInfo({
    required String interval,
    required String question,
    required String site_id,
    required String site_name,
    required String type_id,
    required String type_name,
    required String unit,
    required List<MeasurementValue> values,
    @JsonKey(fromJson: _toDateTime)
    required DateTime updatedAt, // Firestore timestamp
    Bet? myBet, // 👈 여기에 포함
  }) = _MeasurementInfo;

  factory MeasurementInfo.fromJson(Map<String, dynamic> json) =>
      _$MeasurementInfoFromJson(json);
}
