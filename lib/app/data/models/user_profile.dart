import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    @Default('') String name,
    @Default('') String avatarUrl,
    @Default(0)  int points,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
