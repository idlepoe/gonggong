// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bet {
  String get uid;
  String get site_id;
  String get type_id;
  String get direction; // 'up' or 'down'
  double get amount;
  double get odds;
  String? get userName; // 표시용 닉네임
  String? get avatarUrl; // 아바타 이미지 URL
  String? get question; // 질문 내용
  bool get isCancelled;
  @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
  DateTime get createdAt;

  /// Create a copy of Bet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BetCopyWith<Bet> get copyWith =>
      _$BetCopyWithImpl<Bet>(this as Bet, _$identity);

  /// Serializes this Bet to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Bet &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.site_id, site_id) || other.site_id == site_id) &&
            (identical(other.type_id, type_id) || other.type_id == type_id) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.odds, odds) || other.odds == odds) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, site_id, type_id, direction,
      amount, odds, userName, avatarUrl, question, isCancelled, createdAt);

  @override
  String toString() {
    return 'Bet(uid: $uid, site_id: $site_id, type_id: $type_id, direction: $direction, amount: $amount, odds: $odds, userName: $userName, avatarUrl: $avatarUrl, question: $question, isCancelled: $isCancelled, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $BetCopyWith<$Res> {
  factory $BetCopyWith(Bet value, $Res Function(Bet) _then) = _$BetCopyWithImpl;
  @useResult
  $Res call(
      {String uid,
      String site_id,
      String type_id,
      String direction,
      double amount,
      double odds,
      String? userName,
      String? avatarUrl,
      String? question,
      bool isCancelled,
      @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
      DateTime createdAt});
}

/// @nodoc
class _$BetCopyWithImpl<$Res> implements $BetCopyWith<$Res> {
  _$BetCopyWithImpl(this._self, this._then);

  final Bet _self;
  final $Res Function(Bet) _then;

  /// Create a copy of Bet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? site_id = null,
    Object? type_id = null,
    Object? direction = null,
    Object? amount = null,
    Object? odds = null,
    Object? userName = freezed,
    Object? avatarUrl = freezed,
    Object? question = freezed,
    Object? isCancelled = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      site_id: null == site_id
          ? _self.site_id
          : site_id // ignore: cast_nullable_to_non_nullable
              as String,
      type_id: null == type_id
          ? _self.type_id
          : type_id // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _self.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      odds: null == odds
          ? _self.odds
          : odds // ignore: cast_nullable_to_non_nullable
              as double,
      userName: freezed == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      question: freezed == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String?,
      isCancelled: null == isCancelled
          ? _self.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Bet implements Bet {
  const _Bet(
      {required this.uid,
      required this.site_id,
      required this.type_id,
      required this.direction,
      required this.amount,
      required this.odds,
      this.userName,
      this.avatarUrl,
      this.question,
      this.isCancelled = false,
      @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
      required this.createdAt});
  factory _Bet.fromJson(Map<String, dynamic> json) => _$BetFromJson(json);

  @override
  final String uid;
  @override
  final String site_id;
  @override
  final String type_id;
  @override
  final String direction;
// 'up' or 'down'
  @override
  final double amount;
  @override
  final double odds;
  @override
  final String? userName;
// 표시용 닉네임
  @override
  final String? avatarUrl;
// 아바타 이미지 URL
  @override
  final String? question;
// 질문 내용
  @override
  @JsonKey()
  final bool isCancelled;
  @override
  @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
  final DateTime createdAt;

  /// Create a copy of Bet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BetCopyWith<_Bet> get copyWith =>
      __$BetCopyWithImpl<_Bet>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BetToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Bet &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.site_id, site_id) || other.site_id == site_id) &&
            (identical(other.type_id, type_id) || other.type_id == type_id) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.odds, odds) || other.odds == odds) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, site_id, type_id, direction,
      amount, odds, userName, avatarUrl, question, isCancelled, createdAt);

  @override
  String toString() {
    return 'Bet(uid: $uid, site_id: $site_id, type_id: $type_id, direction: $direction, amount: $amount, odds: $odds, userName: $userName, avatarUrl: $avatarUrl, question: $question, isCancelled: $isCancelled, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$BetCopyWith<$Res> implements $BetCopyWith<$Res> {
  factory _$BetCopyWith(_Bet value, $Res Function(_Bet) _then) =
      __$BetCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid,
      String site_id,
      String type_id,
      String direction,
      double amount,
      double odds,
      String? userName,
      String? avatarUrl,
      String? question,
      bool isCancelled,
      @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime)
      DateTime createdAt});
}

/// @nodoc
class __$BetCopyWithImpl<$Res> implements _$BetCopyWith<$Res> {
  __$BetCopyWithImpl(this._self, this._then);

  final _Bet _self;
  final $Res Function(_Bet) _then;

  /// Create a copy of Bet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? site_id = null,
    Object? type_id = null,
    Object? direction = null,
    Object? amount = null,
    Object? odds = null,
    Object? userName = freezed,
    Object? avatarUrl = freezed,
    Object? question = freezed,
    Object? isCancelled = null,
    Object? createdAt = null,
  }) {
    return _then(_Bet(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      site_id: null == site_id
          ? _self.site_id
          : site_id // ignore: cast_nullable_to_non_nullable
              as String,
      type_id: null == type_id
          ? _self.type_id
          : type_id // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _self.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      odds: null == odds
          ? _self.odds
          : odds // ignore: cast_nullable_to_non_nullable
              as double,
      userName: freezed == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      question: freezed == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String?,
      isCancelled: null == isCancelled
          ? _self.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
