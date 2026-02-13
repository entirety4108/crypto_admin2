// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Transfer _$TransferFromJson(Map<String, dynamic> json) {
  return _Transfer.fromJson(json);
}

/// @nodoc
mixin _$Transfer {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_account_id')
  String get fromAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_account_id')
  String get toAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'crypt_id')
  String get cryptId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'exec_at')
  DateTime get execAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'fee_crypt_id')
  String? get feeCryptId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fee_amount')
  double? get feeAmount => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Transfer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferCopyWith<Transfer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferCopyWith<$Res> {
  factory $TransferCopyWith(Transfer value, $Res Function(Transfer) then) =
      _$TransferCopyWithImpl<$Res, Transfer>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'from_account_id') String fromAccountId,
    @JsonKey(name: 'to_account_id') String toAccountId,
    @JsonKey(name: 'crypt_id') String cryptId,
    double amount,
    @JsonKey(name: 'exec_at') DateTime execAt,
    @JsonKey(name: 'fee_crypt_id') String? feeCryptId,
    @JsonKey(name: 'fee_amount') double? feeAmount,
    String? memo,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$TransferCopyWithImpl<$Res, $Val extends Transfer>
    implements $TransferCopyWith<$Res> {
  _$TransferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fromAccountId = null,
    Object? toAccountId = null,
    Object? cryptId = null,
    Object? amount = null,
    Object? execAt = null,
    Object? feeCryptId = freezed,
    Object? feeAmount = freezed,
    Object? memo = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            fromAccountId: null == fromAccountId
                ? _value.fromAccountId
                : fromAccountId // ignore: cast_nullable_to_non_nullable
                      as String,
            toAccountId: null == toAccountId
                ? _value.toAccountId
                : toAccountId // ignore: cast_nullable_to_non_nullable
                      as String,
            cryptId: null == cryptId
                ? _value.cryptId
                : cryptId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            execAt: null == execAt
                ? _value.execAt
                : execAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            feeCryptId: freezed == feeCryptId
                ? _value.feeCryptId
                : feeCryptId // ignore: cast_nullable_to_non_nullable
                      as String?,
            feeAmount: freezed == feeAmount
                ? _value.feeAmount
                : feeAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            memo: freezed == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$TransferImplCopyWith<$Res>
    implements $TransferCopyWith<$Res> {
  factory _$$TransferImplCopyWith(
    _$TransferImpl value,
    $Res Function(_$TransferImpl) then,
  ) = __$$TransferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'from_account_id') String fromAccountId,
    @JsonKey(name: 'to_account_id') String toAccountId,
    @JsonKey(name: 'crypt_id') String cryptId,
    double amount,
    @JsonKey(name: 'exec_at') DateTime execAt,
    @JsonKey(name: 'fee_crypt_id') String? feeCryptId,
    @JsonKey(name: 'fee_amount') double? feeAmount,
    String? memo,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$TransferImplCopyWithImpl<$Res>
    extends _$TransferCopyWithImpl<$Res, _$TransferImpl>
    implements _$$TransferImplCopyWith<$Res> {
  __$$TransferImplCopyWithImpl(
    _$TransferImpl _value,
    $Res Function(_$TransferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fromAccountId = null,
    Object? toAccountId = null,
    Object? cryptId = null,
    Object? amount = null,
    Object? execAt = null,
    Object? feeCryptId = freezed,
    Object? feeAmount = freezed,
    Object? memo = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TransferImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        fromAccountId: null == fromAccountId
            ? _value.fromAccountId
            : fromAccountId // ignore: cast_nullable_to_non_nullable
                  as String,
        toAccountId: null == toAccountId
            ? _value.toAccountId
            : toAccountId // ignore: cast_nullable_to_non_nullable
                  as String,
        cryptId: null == cryptId
            ? _value.cryptId
            : cryptId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        execAt: null == execAt
            ? _value.execAt
            : execAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        feeCryptId: freezed == feeCryptId
            ? _value.feeCryptId
            : feeCryptId // ignore: cast_nullable_to_non_nullable
                  as String?,
        feeAmount: freezed == feeAmount
            ? _value.feeAmount
            : feeAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        memo: freezed == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$TransferImpl implements _Transfer {
  const _$TransferImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'from_account_id') required this.fromAccountId,
    @JsonKey(name: 'to_account_id') required this.toAccountId,
    @JsonKey(name: 'crypt_id') required this.cryptId,
    required this.amount,
    @JsonKey(name: 'exec_at') required this.execAt,
    @JsonKey(name: 'fee_crypt_id') this.feeCryptId,
    @JsonKey(name: 'fee_amount') this.feeAmount,
    this.memo,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$TransferImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'from_account_id')
  final String fromAccountId;
  @override
  @JsonKey(name: 'to_account_id')
  final String toAccountId;
  @override
  @JsonKey(name: 'crypt_id')
  final String cryptId;
  @override
  final double amount;
  @override
  @JsonKey(name: 'exec_at')
  final DateTime execAt;
  @override
  @JsonKey(name: 'fee_crypt_id')
  final String? feeCryptId;
  @override
  @JsonKey(name: 'fee_amount')
  final double? feeAmount;
  @override
  final String? memo;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Transfer(id: $id, userId: $userId, fromAccountId: $fromAccountId, toAccountId: $toAccountId, cryptId: $cryptId, amount: $amount, execAt: $execAt, feeCryptId: $feeCryptId, feeAmount: $feeAmount, memo: $memo, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fromAccountId, fromAccountId) ||
                other.fromAccountId == fromAccountId) &&
            (identical(other.toAccountId, toAccountId) ||
                other.toAccountId == toAccountId) &&
            (identical(other.cryptId, cryptId) || other.cryptId == cryptId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.execAt, execAt) || other.execAt == execAt) &&
            (identical(other.feeCryptId, feeCryptId) ||
                other.feeCryptId == feeCryptId) &&
            (identical(other.feeAmount, feeAmount) ||
                other.feeAmount == feeAmount) &&
            (identical(other.memo, memo) || other.memo == memo) &&
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
    userId,
    fromAccountId,
    toAccountId,
    cryptId,
    amount,
    execAt,
    feeCryptId,
    feeAmount,
    memo,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Transfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferImplCopyWith<_$TransferImpl> get copyWith =>
      __$$TransferImplCopyWithImpl<_$TransferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferImplToJson(this);
  }
}

abstract class _Transfer implements Transfer {
  const factory _Transfer({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'from_account_id') required final String fromAccountId,
    @JsonKey(name: 'to_account_id') required final String toAccountId,
    @JsonKey(name: 'crypt_id') required final String cryptId,
    required final double amount,
    @JsonKey(name: 'exec_at') required final DateTime execAt,
    @JsonKey(name: 'fee_crypt_id') final String? feeCryptId,
    @JsonKey(name: 'fee_amount') final double? feeAmount,
    final String? memo,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$TransferImpl;

  factory _Transfer.fromJson(Map<String, dynamic> json) =
      _$TransferImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'from_account_id')
  String get fromAccountId;
  @override
  @JsonKey(name: 'to_account_id')
  String get toAccountId;
  @override
  @JsonKey(name: 'crypt_id')
  String get cryptId;
  @override
  double get amount;
  @override
  @JsonKey(name: 'exec_at')
  DateTime get execAt;
  @override
  @JsonKey(name: 'fee_crypt_id')
  String? get feeCryptId;
  @override
  @JsonKey(name: 'fee_amount')
  double? get feeAmount;
  @override
  String? get memo;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Transfer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferImplCopyWith<_$TransferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
