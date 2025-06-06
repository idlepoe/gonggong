import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/app_utils.dart';

part 'activity.freezed.dart';

part 'activity.g.dart';

@freezed
abstract class Activity with _$Activity {
  const factory Activity({
    required String uid,
    required String type,
    required String avatarUrl,
    required String name,
    @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
    required DateTime createdAt,
    required String message,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

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

// DateTime → 저장용 형식 (ISO 또는 그대로 Timestamp로 써도 됨)
dynamic _fromDateTime(DateTime dateTime) => dateTime.toIso8601String();
