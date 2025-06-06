// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
      uid: json['uid'] as String,
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      points: (json['points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'points': instance.points,
    };
