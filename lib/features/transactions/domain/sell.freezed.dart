// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Sell _$SellFromJson(Map<String, dynamic> json) {
  return _Sell.fromJson(json);
}

/// @nodoc
mixin _$Sell {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'exec_at')
  DateTime get execAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_id')
  String get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'crypt_id')
  String get cryptId => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_yen')
  double get unitYen => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get yen => throw _privateConstructorUsedError;
  @JsonKey(name: 'commission_id')
  String? get commissionId => throw _privateConstructorUsedError;
  double? get profit => throw _privateConstructorUsedError;
  @JsonKey(name: 'swap_id')
  String? get swapId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Sell to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellCopyWith<Sell> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellCopyWith<$Res> {
  factory $SellCopyWith(Sell value, $Res Function(Sell) then) =
      _$SellCopyWithImpl<$Res, Sell>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'exec_at') DateTime execAt,
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'crypt_id') String cryptId,
    @JsonKey(name: 'unit_yen') double unitYen,
    double amount,
    double yen,
    @JsonKey(name: 'commission_id') String? commissionId,
    double? profit,
    @JsonKey(name: 'swap_id') String? swapId,
    String type,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$SellCopyWithImpl<$Res, $Val extends Sell>
    implements $SellCopyWith<$Res> {
  _$SellCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? execAt = null,
    Object? accountId = null,
    Object? cryptId = null,
    Object? unitYen = null,
    Object? amount = null,
    Object? yen = null,
    Object? commissionId = freezed,
    Object? profit = freezed,
    Object? swapId = freezed,
    Object? type = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            execAt: null == execAt
                ? _value.execAt
                : execAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String,
            cryptId: null == cryptId
                ? _value.cryptId
                : cryptId // ignore: cast_nullable_to_non_nullable
                      as String,
            unitYen: null == unitYen
                ? _value.unitYen
                : unitYen // ignore: cast_nullable_to_non_nullable
                      as double,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            yen: null == yen
                ? _value.yen
                : yen // ignore: cast_nullable_to_non_nullable
                      as double,
            commissionId: freezed == commissionId
                ? _value.commissionId
                : commissionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            profit: freezed == profit
                ? _value.profit
                : profit // ignore: cast_nullable_to_non_nullable
                      as double?,
            swapId: freezed == swapId
                ? _value.swapId
                : swapId // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SellImplCopyWith<$Res> implements $SellCopyWith<$Res> {
  factory _$$SellImplCopyWith(
    _$SellImpl value,
    $Res Function(_$SellImpl) then,
  ) = __$$SellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'exec_at') DateTime execAt,
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'crypt_id') String cryptId,
    @JsonKey(name: 'unit_yen') double unitYen,
    double amount,
    double yen,
    @JsonKey(name: 'commission_id') String? commissionId,
    double? profit,
    @JsonKey(name: 'swap_id') String? swapId,
    String type,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$SellImplCopyWithImpl<$Res>
    extends _$SellCopyWithImpl<$Res, _$SellImpl>
    implements _$$SellImplCopyWith<$Res> {
  __$$SellImplCopyWithImpl(_$SellImpl _value, $Res Function(_$SellImpl) _then)
    : super(_value, _then);

  /// Create a copy of Sell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? execAt = null,
    Object? accountId = null,
    Object? cryptId = null,
    Object? unitYen = null,
    Object? amount = null,
    Object? yen = null,
    Object? commissionId = freezed,
    Object? profit = freezed,
    Object? swapId = freezed,
    Object? type = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SellImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        execAt: null == execAt
            ? _value.execAt
            : execAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        cryptId: null == cryptId
            ? _value.cryptId
            : cryptId // ignore: cast_nullable_to_non_nullable
                  as String,
        unitYen: null == unitYen
            ? _value.unitYen
            : unitYen // ignore: cast_nullable_to_non_nullable
                  as double,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        yen: null == yen
            ? _value.yen
            : yen // ignore: cast_nullable_to_non_nullable
                  as double,
        commissionId: freezed == commissionId
            ? _value.commissionId
            : commissionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        profit: freezed == profit
            ? _value.profit
            : profit // ignore: cast_nullable_to_non_nullable
                  as double?,
        swapId: freezed == swapId
            ? _value.swapId
            : swapId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SellImpl implements _Sell {
  const _$SellImpl({
    required this.id,
    @JsonKey(name: 'exec_at') required this.execAt,
    @JsonKey(name: 'account_id') required this.accountId,
    @JsonKey(name: 'crypt_id') required this.cryptId,
    @JsonKey(name: 'unit_yen') required this.unitYen,
    required this.amount,
    required this.yen,
    @JsonKey(name: 'commission_id') this.commissionId,
    this.profit,
    @JsonKey(name: 'swap_id') this.swapId,
    required this.type,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$SellImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'exec_at')
  final DateTime execAt;
  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  @JsonKey(name: 'crypt_id')
  final String cryptId;
  @override
  @JsonKey(name: 'unit_yen')
  final double unitYen;
  @override
  final double amount;
  @override
  final double yen;
  @override
  @JsonKey(name: 'commission_id')
  final String? commissionId;
  @override
  final double? profit;
  @override
  @JsonKey(name: 'swap_id')
  final String? swapId;
  @override
  final String type;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Sell(id: $id, execAt: $execAt, accountId: $accountId, cryptId: $cryptId, unitYen: $unitYen, amount: $amount, yen: $yen, commissionId: $commissionId, profit: $profit, swapId: $swapId, type: $type, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.execAt, execAt) || other.execAt == execAt) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.cryptId, cryptId) || other.cryptId == cryptId) &&
            (identical(other.unitYen, unitYen) || other.unitYen == unitYen) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.yen, yen) || other.yen == yen) &&
            (identical(other.commissionId, commissionId) ||
                other.commissionId == commissionId) &&
            (identical(other.profit, profit) || other.profit == profit) &&
            (identical(other.swapId, swapId) || other.swapId == swapId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    execAt,
    accountId,
    cryptId,
    unitYen,
    amount,
    yen,
    commissionId,
    profit,
    swapId,
    type,
    userId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Sell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellImplCopyWith<_$SellImpl> get copyWith =>
      __$$SellImplCopyWithImpl<_$SellImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellImplToJson(this);
  }
}

abstract class _Sell implements Sell {
  const factory _Sell({
    required final String id,
    @JsonKey(name: 'exec_at') required final DateTime execAt,
    @JsonKey(name: 'account_id') required final String accountId,
    @JsonKey(name: 'crypt_id') required final String cryptId,
    @JsonKey(name: 'unit_yen') required final double unitYen,
    required final double amount,
    required final double yen,
    @JsonKey(name: 'commission_id') final String? commissionId,
    final double? profit,
    @JsonKey(name: 'swap_id') final String? swapId,
    required final String type,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$SellImpl;

  factory _Sell.fromJson(Map<String, dynamic> json) = _$SellImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'exec_at')
  DateTime get execAt;
  @override
  @JsonKey(name: 'account_id')
  String get accountId;
  @override
  @JsonKey(name: 'crypt_id')
  String get cryptId;
  @override
  @JsonKey(name: 'unit_yen')
  double get unitYen;
  @override
  double get amount;
  @override
  double get yen;
  @override
  @JsonKey(name: 'commission_id')
  String? get commissionId;
  @override
  double? get profit;
  @override
  @JsonKey(name: 'swap_id')
  String? get swapId;
  @override
  String get type;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Sell
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellImplCopyWith<_$SellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
