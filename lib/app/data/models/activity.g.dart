// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
      uid: json['uid'] as String,
      type: json['type'] as String,
      avatarUrl: json['avatarUrl'] as String,
      name: json['name'] as String,
      createdAt: _toDateTime(json['createdAt']),
      message: json['message'] as String,
    );

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
      'uid': instance.uid,
      'type': instance.type,
      'avatarUrl': instance.avatarUrl,
      'name': instance.name,
      'createdAt': _fromDateTime(instance.createdAt),
      'message': instance.message,
    };
