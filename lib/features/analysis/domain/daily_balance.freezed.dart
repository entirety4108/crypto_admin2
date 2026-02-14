// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyBalance _$DailyBalanceFromJson(Map<String, dynamic> json) {
  return _DailyBalance.fromJson(json);
}

/// @nodoc
mixin _$DailyBalance {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_id')
  String get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'crypt_id')
  String get cryptId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  double get valuation => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DailyBalance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyBalanceCopyWith<DailyBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyBalanceCopyWith<$Res> {
  factory $DailyBalanceCopyWith(
    DailyBalance value,
    $Res Function(DailyBalance) then,
  ) = _$DailyBalanceCopyWithImpl<$Res, DailyBalance>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'crypt_id') String cryptId,
    DateTime date,
    double amount,
    @JsonKey(name: 'unit_price') double unitPrice,
    double valuation,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$DailyBalanceCopyWithImpl<$Res, $Val extends DailyBalance>
    implements $DailyBalanceCopyWith<$Res> {
  _$DailyBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? accountId = null,
    Object? cryptId = null,
    Object? date = null,
    Object? amount = null,
    Object? unitPrice = null,
    Object? valuation = null,
    Object? createdAt = null,
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
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String,
            cryptId: null == cryptId
                ? _value.cryptId
                : cryptId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            valuation: null == valuation
                ? _value.valuation
                : valuation // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyBalanceImplCopyWith<$Res>
    implements $DailyBalanceCopyWith<$Res> {
  factory _$$DailyBalanceImplCopyWith(
    _$DailyBalanceImpl value,
    $Res Function(_$DailyBalanceImpl) then,
  ) = __$$DailyBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'crypt_id') String cryptId,
    DateTime date,
    double amount,
    @JsonKey(name: 'unit_price') double unitPrice,
    double valuation,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$DailyBalanceImplCopyWithImpl<$Res>
    extends _$DailyBalanceCopyWithImpl<$Res, _$DailyBalanceImpl>
    implements _$$DailyBalanceImplCopyWith<$Res> {
  __$$DailyBalanceImplCopyWithImpl(
    _$DailyBalanceImpl _value,
    $Res Function(_$DailyBalanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? accountId = null,
    Object? cryptId = null,
    Object? date = null,
    Object? amount = null,
    Object? unitPrice = null,
    Object? valuation = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$DailyBalanceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        cryptId: null == cryptId
            ? _value.cryptId
            : cryptId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        valuation: null == valuation
            ? _value.valuation
            : valuation // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyBalanceImpl implements _DailyBalance {
  const _$DailyBalanceImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'account_id') required this.accountId,
    @JsonKey(name: 'crypt_id') required this.cryptId,
    required this.date,
    required this.amount,
    @JsonKey(name: 'unit_price') required this.unitPrice,
    required this.valuation,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$DailyBalanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyBalanceImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  @JsonKey(name: 'crypt_id')
  final String cryptId;
  @override
  final DateTime date;
  @override
  final double amount;
  @override
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  final double valuation;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'DailyBalance(id: $id, userId: $userId, accountId: $accountId, cryptId: $cryptId, date: $date, amount: $amount, unitPrice: $unitPrice, valuation: $valuation, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyBalanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.cryptId, cryptId) || other.cryptId == cryptId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.valuation, valuation) ||
                other.valuation == valuation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    accountId,
    cryptId,
    date,
    amount,
    unitPrice,
    valuation,
    createdAt,
  );

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyBalanceImplCopyWith<_$DailyBalanceImpl> get copyWith =>
      __$$DailyBalanceImplCopyWithImpl<_$DailyBalanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyBalanceImplToJson(this);
  }
}

abstract class _DailyBalance implements DailyBalance {
  const factory _DailyBalance({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'account_id') required final String accountId,
    @JsonKey(name: 'crypt_id') required final String cryptId,
    required final DateTime date,
    required final double amount,
    @JsonKey(name: 'unit_price') required final double unitPrice,
    required final double valuation,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$DailyBalanceImpl;

  factory _DailyBalance.fromJson(Map<String, dynamic> json) =
      _$DailyBalanceImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'account_id')
  String get accountId;
  @override
  @JsonKey(name: 'crypt_id')
  String get cryptId;
  @override
  DateTime get date;
  @override
  double get amount;
  @override
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  double get valuation;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyBalanceImplCopyWith<_$DailyBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
