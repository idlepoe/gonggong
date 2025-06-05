// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeasurementInfo _$MeasurementInfoFromJson(Map<String, dynamic> json) =>
    _MeasurementInfo(
      interval: json['interval'] as String,
      question: json['question'] as String,
      site_id: json['site_id'] as String,
      site_name: json['site_name'] as String,
      type_id: json['type_id'] as String,
      type_name: json['type_name'] as String,
      unit: json['unit'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => MeasurementValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: _toDateTime(json['updatedAt']),
      myBet: json['myBet'] == null
          ? null
          : Bet.fromJson(json['myBet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeasurementInfoToJson(_MeasurementInfo instance) =>
    <String, dynamic>{
      'interval': instance.interval,
      'question': instance.question,
      'site_id': instance.site_id,
      'site_name': instance.site_name,
      'type_id': instance.type_id,
      'type_name': instance.type_name,
      'unit': instance.unit,
      'values': instance.values,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'myBet': instance.myBet,
    };
