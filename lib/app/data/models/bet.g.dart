// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bet _$BetFromJson(Map<String, dynamic> json) => _Bet(
      uid: json['uid'] as String,
      site_id: json['site_id'] as String,
      type_id: json['type_id'] as String,
      direction: json['direction'] as String,
      amount: (json['amount'] as num).toDouble(),
      odds: (json['odds'] as num).toDouble(),
      userName: json['userName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      question: json['question'] as String?,
      isCancelled: json['isCancelled'] as bool? ?? false,
      createdAt: _toDateTime(json['createdAt']),
    );

Map<String, dynamic> _$BetToJson(_Bet instance) => <String, dynamic>{
      'uid': instance.uid,
      'site_id': instance.site_id,
      'type_id': instance.type_id,
      'direction': instance.direction,
      'amount': instance.amount,
      'odds': instance.odds,
      'userName': instance.userName,
      'avatarUrl': instance.avatarUrl,
      'question': instance.question,
      'isCancelled': instance.isCancelled,
      'createdAt': _fromDateTime(instance.createdAt),
    };
