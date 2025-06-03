import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge.freezed.dart';

part 'challenge.g.dart';

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
  return value as DateTime;
}

@freezed
abstract class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String siteId,
    required String snapshotId,
    required String title,
    required double delta,
    required String field,
    required double baseValue,
    required double targetValue,
    @JsonKey(fromJson: _toDateTime) required DateTime createdAt,
    @JsonKey(fromJson: _toDateTime) required DateTime deadline,
    required double odds,
    required bool resolved,
    bool? result,
  }) = _Challenge;

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
}
