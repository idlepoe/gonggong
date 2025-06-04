// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WaterMeasurement _$WaterMeasurementFromJson(Map<String, dynamic> json) =>
    _WaterMeasurement(
      MSR_DATE: json['MSR_DATE'] as String,
      MSR_TIME: json['MSR_TIME'] as String,
      SITE_ID: json['SITE_ID'] as String,
      W_CN: json['W_CN'] as String,
      W_DO: json['W_DO'] as String,
      W_PH: json['W_PH'] as String,
      W_PHEN: json['W_PHEN'] as String,
      W_TEMP: json['W_TEMP'] as String,
      W_TN: json['W_TN'] as String,
      W_TOC: json['W_TOC'] as String,
      W_TP: json['W_TP'] as String,
      createdAt: _toDateTime(json['createdAt']),
    );

Map<String, dynamic> _$WaterMeasurementToJson(_WaterMeasurement instance) =>
    <String, dynamic>{
      'MSR_DATE': instance.MSR_DATE,
      'MSR_TIME': instance.MSR_TIME,
      'SITE_ID': instance.SITE_ID,
      'W_CN': instance.W_CN,
      'W_DO': instance.W_DO,
      'W_PH': instance.W_PH,
      'W_PHEN': instance.W_PHEN,
      'W_TEMP': instance.W_TEMP,
      'W_TN': instance.W_TN,
      'W_TOC': instance.W_TOC,
      'W_TP': instance.W_TP,
      'createdAt': instance.createdAt.toIso8601String(),
    };
