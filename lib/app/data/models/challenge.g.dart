// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Challenge _$ChallengeFromJson(Map<String, dynamic> json) => _Challenge(
      id: json['id'] as String,
      siteId: json['siteId'] as String,
      snapshotId: json['snapshotId'] as String,
      title: json['title'] as String,
      delta: (json['delta'] as num).toDouble(),
      field: json['field'] as String,
      baseValue: (json['baseValue'] as num).toDouble(),
      targetValue: (json['targetValue'] as num).toDouble(),
      createdAt: _toDateTime(json['createdAt']),
      deadline: _toDateTime(json['deadline']),
      odds: (json['odds'] as num).toDouble(),
      resolved: json['resolved'] as bool,
      result: json['result'] as bool?,
    );

Map<String, dynamic> _$ChallengeToJson(_Challenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'siteId': instance.siteId,
      'snapshotId': instance.snapshotId,
      'title': instance.title,
      'delta': instance.delta,
      'field': instance.field,
      'baseValue': instance.baseValue,
      'targetValue': instance.targetValue,
      'createdAt': instance.createdAt.toIso8601String(),
      'deadline': instance.deadline.toIso8601String(),
      'odds': instance.odds,
      'resolved': instance.resolved,
      'result': instance.result,
    };
