// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bet_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BetComment _$BetCommentFromJson(Map<String, dynamic> json) => _BetComment(
      uid: json['uid'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      message: json['message'] as String,
      createdAt: _toDateTime(json['createdAt']),
    );

Map<String, dynamic> _$BetCommentToJson(_BetComment instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'message': instance.message,
      'createdAt': _fromDateTime(instance.createdAt),
    };
