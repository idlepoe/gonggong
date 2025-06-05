import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/app_utils.dart';

part 'bet.freezed.dart';

part 'bet.g.dart';

@freezed
abstract class Bet with _$Bet {
  const factory Bet({
    required String uid,
    required String site_id,
    required String type_id,
    required String direction, // 'up' or 'down'
    required double amount,
    required double odds,
    String? userName, // 표시용 닉네임
    String? avatarUrl, // 아바타 이미지 URL
    String? question, // 질문 내용
    @Default(false) bool isCancelled,
    @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
    required DateTime createdAt,
  }) = _Bet;

  factory Bet.fromJson(Map<String, dynamic> json) => _$BetFromJson(json);
}

// Firestore Timestamp → DateTime
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
