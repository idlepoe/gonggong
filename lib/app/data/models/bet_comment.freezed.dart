// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bet_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BetComment {
  String get uid;
  String get name;
  String get avatarUrl;
  String get message;
  @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
  DateTime get createdAt;

  /// Create a copy of BetComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BetCommentCopyWith<BetComment> get copyWith =>
      _$BetCommentCopyWithImpl<BetComment>(this as BetComment, _$identity);

  /// Serializes this BetComment to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BetComment &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uid, name, avatarUrl, message, createdAt);

  @override
  String toString() {
    return 'BetComment(uid: $uid, name: $name, avatarUrl: $avatarUrl, message: $message, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $BetCommentCopyWith<$Res> {
  factory $BetCommentCopyWith(
          BetComment value, $Res Function(BetComment) _then) =
      _$BetCommentCopyWithImpl;
  @useResult
  $Res call(
      {String uid,
      String name,
      String avatarUrl,
      String message,
      @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
      DateTime createdAt});
}

/// @nodoc
class _$BetCommentCopyWithImpl<$Res> implements $BetCommentCopyWith<$Res> {
  _$BetCommentCopyWithImpl(this._self, this._then);

  final BetComment _self;
  final $Res Function(BetComment) _then;

  /// Create a copy of BetComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? avatarUrl = null,
    Object? message = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _BetComment implements BetComment {
  const _BetComment(
      {required this.uid,
      required this.name,
      required this.avatarUrl,
      required this.message,
      @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
      required this.createdAt});
  factory _BetComment.fromJson(Map<String, dynamic> json) =>
      _$BetCommentFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String avatarUrl;
  @override
  final String message;
  @override
  @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
  final DateTime createdAt;

  /// Create a copy of BetComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BetCommentCopyWith<_BetComment> get copyWith =>
      __$BetCommentCopyWithImpl<_BetComment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BetCommentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BetComment &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uid, name, avatarUrl, message, createdAt);

  @override
  String toString() {
    return 'BetComment(uid: $uid, name: $name, avatarUrl: $avatarUrl, message: $message, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$BetCommentCopyWith<$Res>
    implements $BetCommentCopyWith<$Res> {
  factory _$BetCommentCopyWith(
          _BetComment value, $Res Function(_BetComment) _then) =
      __$BetCommentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      String avatarUrl,
      String message,
      @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
      DateTime createdAt});
}

/// @nodoc
class __$BetCommentCopyWithImpl<$Res> implements _$BetCommentCopyWith<$Res> {
  __$BetCommentCopyWithImpl(this._self, this._then);

  final _BetComment _self;
  final $Res Function(_BetComment) _then;

  /// Create a copy of BetComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? avatarUrl = null,
    Object? message = null,
    Object? createdAt = null,
  }) {
    return _then(_BetComment(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
