import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/app_utils.dart';

part 'bet_comment.freezed.dart';

part 'bet_comment.g.dart';

@freezed
abstract class BetComment with _$BetComment {
  const factory BetComment({
    required String uid,
    required String name,
    required String avatarUrl,
    required String message,
    @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required DateTime createdAt,
  }) = _BetComment;

  factory BetComment.fromJson(Map<String, dynamic> json) =>
      _$BetCommentFromJson(json);
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
