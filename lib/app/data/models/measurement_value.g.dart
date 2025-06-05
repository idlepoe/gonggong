// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeasurementValue _$MeasurementValueFromJson(Map<String, dynamic> json) =>
    _MeasurementValue(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      startDate: _toDateTime(json['startDate']),
      endDate: _toDateTime(json['endDate']),
      createdAt: _toDateTime(json['createdAt']),
    );

Map<String, dynamic> _$MeasurementValueToJson(_MeasurementValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
