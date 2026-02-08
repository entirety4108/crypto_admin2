// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Purchase _$PurchaseFromJson(Map<String, dynamic> json) {
  return _Purchase.fromJson(json);
}

/// @nodoc
mixin _$Purchase {
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
  @JsonKey(name: 'deposit_yen')
  double get depositYen => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_yen')
  double get purchaseYen => throw _privateConstructorUsedError;
  @JsonKey(name: 'commission_id')
  String? get commissionId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'airdrop_type')
  int? get airdropType => throw _privateConstructorUsedError;
  @JsonKey(name: 'airdrop_profit')
  double? get airdropProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Purchase to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Purchase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseCopyWith<Purchase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseCopyWith<$Res> {
  factory $PurchaseCopyWith(Purchase value, $Res Function(Purchase) then) =
      _$PurchaseCopyWithImpl<$Res, Purchase>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'exec_at') DateTime execAt,
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'crypt_id') String cryptId,
    @JsonKey(name: 'unit_yen') double unitYen,
    double amount,
    @JsonKey(name: 'deposit_yen') double depositYen,
    @JsonKey(name: 'purchase_yen') double purchaseYen,
    @JsonKey(name: 'commission_id') String? commissionId,
    String type,
    @JsonKey(name: 'airdrop_type') int? airdropType,
    @JsonKey(name: 'airdrop_profit') double? airdropProfit,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$PurchaseCopyWithImpl<$Res, $Val extends Purchase>
    implements $PurchaseCopyWith<$Res> {
  _$PurchaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Purchase
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
    Object? depositYen = null,
    Object? purchaseYen = null,
    Object? commissionId = freezed,
    Object? type = null,
    Object? airdropType = freezed,
    Object? airdropProfit = freezed,
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
            depositYen: null == depositYen
                ? _value.depositYen
                : depositYen // ignore: cast_nullable_to_non_nullable
                      as double,
            purchaseYen: null == purchaseYen
                ? _value.purchaseYen
                : purchaseYen // ignore: cast_nullable_to_non_nullable
                      as double,
            commissionId: freezed == commissionId
                ? _value.commissionId
                : commissionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            airdropType: freezed == airdropType
                ? _value.airdropType
                : airdropType // ignore: cast_nullable_to_non_nullable
                      as int?,
            airdropProfit: freezed == airdropProfit
                ? _value.airdropProfit
                : airdropProfit // ignore: cast_nullable_to_non_nullable
                      as double?,
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
abstract class _$$PurchaseImplCopyWith<$Res>
    implements $PurchaseCopyWith<$Res> {
  factory _$$PurchaseImplCopyWith(
    _$PurchaseImpl value,
    $Res Function(_$PurchaseImpl) then,
  ) = __$$PurchaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'exec_at') DateTime execAt,
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'crypt_id') String cryptId,
    @JsonKey(name: 'unit_yen') double unitYen,
    double amount,
    @JsonKey(name: 'deposit_yen') double depositYen,
    @JsonKey(name: 'purchase_yen') double purchaseYen,
    @JsonKey(name: 'commission_id') String? commissionId,
    String type,
    @JsonKey(name: 'airdrop_type') int? airdropType,
    @JsonKey(name: 'airdrop_profit') double? airdropProfit,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$PurchaseImplCopyWithImpl<$Res>
    extends _$PurchaseCopyWithImpl<$Res, _$PurchaseImpl>
    implements _$$PurchaseImplCopyWith<$Res> {
  __$$PurchaseImplCopyWithImpl(
    _$PurchaseImpl _value,
    $Res Function(_$PurchaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Purchase
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
    Object? depositYen = null,
    Object? purchaseYen = null,
    Object? commissionId = freezed,
    Object? type = null,
    Object? airdropType = freezed,
    Object? airdropProfit = freezed,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$PurchaseImpl(
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
        depositYen: null == depositYen
            ? _value.depositYen
            : depositYen // ignore: cast_nullable_to_non_nullable
                  as double,
        purchaseYen: null == purchaseYen
            ? _value.purchaseYen
            : purchaseYen // ignore: cast_nullable_to_non_nullable
                  as double,
        commissionId: freezed == commissionId
            ? _value.commissionId
            : commissionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        airdropType: freezed == airdropType
            ? _value.airdropType
            : airdropType // ignore: cast_nullable_to_non_nullable
                  as int?,
        airdropProfit: freezed == airdropProfit
            ? _value.airdropProfit
            : airdropProfit // ignore: cast_nullable_to_non_nullable
                  as double?,
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
class _$PurchaseImpl implements _Purchase {
  const _$PurchaseImpl({
    required this.id,
    @JsonKey(name: 'exec_at') required this.execAt,
    @JsonKey(name: 'account_id') required this.accountId,
    @JsonKey(name: 'crypt_id') required this.cryptId,
    @JsonKey(name: 'unit_yen') required this.unitYen,
    required this.amount,
    @JsonKey(name: 'deposit_yen') required this.depositYen,
    @JsonKey(name: 'purchase_yen') required this.purchaseYen,
    @JsonKey(name: 'commission_id') this.commissionId,
    required this.type,
    @JsonKey(name: 'airdrop_type') this.airdropType,
    @JsonKey(name: 'airdrop_profit') this.airdropProfit,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$PurchaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseImplFromJson(json);

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
  @JsonKey(name: 'deposit_yen')
  final double depositYen;
  @override
  @JsonKey(name: 'purchase_yen')
  final double purchaseYen;
  @override
  @JsonKey(name: 'commission_id')
  final String? commissionId;
  @override
  final String type;
  @override
  @JsonKey(name: 'airdrop_type')
  final int? airdropType;
  @override
  @JsonKey(name: 'airdrop_profit')
  final double? airdropProfit;
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
    return 'Purchase(id: $id, execAt: $execAt, accountId: $accountId, cryptId: $cryptId, unitYen: $unitYen, amount: $amount, depositYen: $depositYen, purchaseYen: $purchaseYen, commissionId: $commissionId, type: $type, airdropType: $airdropType, airdropProfit: $airdropProfit, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.execAt, execAt) || other.execAt == execAt) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.cryptId, cryptId) || other.cryptId == cryptId) &&
            (identical(other.unitYen, unitYen) || other.unitYen == unitYen) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.depositYen, depositYen) ||
                other.depositYen == depositYen) &&
            (identical(other.purchaseYen, purchaseYen) ||
                other.purchaseYen == purchaseYen) &&
            (identical(other.commissionId, commissionId) ||
                other.commissionId == commissionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.airdropType, airdropType) ||
                other.airdropType == airdropType) &&
            (identical(other.airdropProfit, airdropProfit) ||
                other.airdropProfit == airdropProfit) &&
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
    depositYen,
    purchaseYen,
    commissionId,
    type,
    airdropType,
    airdropProfit,
    userId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Purchase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseImplCopyWith<_$PurchaseImpl> get copyWith =>
      __$$PurchaseImplCopyWithImpl<_$PurchaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseImplToJson(this);
  }
}

abstract class _Purchase implements Purchase {
  const factory _Purchase({
    required final String id,
    @JsonKey(name: 'exec_at') required final DateTime execAt,
    @JsonKey(name: 'account_id') required final String accountId,
    @JsonKey(name: 'crypt_id') required final String cryptId,
    @JsonKey(name: 'unit_yen') required final double unitYen,
    required final double amount,
    @JsonKey(name: 'deposit_yen') required final double depositYen,
    @JsonKey(name: 'purchase_yen') required final double purchaseYen,
    @JsonKey(name: 'commission_id') final String? commissionId,
    required final String type,
    @JsonKey(name: 'airdrop_type') final int? airdropType,
    @JsonKey(name: 'airdrop_profit') final double? airdropProfit,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$PurchaseImpl;

  factory _Purchase.fromJson(Map<String, dynamic> json) =
      _$PurchaseImpl.fromJson;

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
  @JsonKey(name: 'deposit_yen')
  double get depositYen;
  @override
  @JsonKey(name: 'purchase_yen')
  double get purchaseYen;
  @override
  @JsonKey(name: 'commission_id')
  String? get commissionId;
  @override
  String get type;
  @override
  @JsonKey(name: 'airdrop_type')
  int? get airdropType;
  @override
  @JsonKey(name: 'airdrop_profit')
  double? get airdropProfit;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Purchase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseImplCopyWith<_$PurchaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
