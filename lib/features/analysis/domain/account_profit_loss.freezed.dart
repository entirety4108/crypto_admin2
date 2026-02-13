// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_profit_loss.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AccountProfitLoss _$AccountProfitLossFromJson(Map<String, dynamic> json) {
  return _AccountProfitLoss.fromJson(json);
}

/// @nodoc
mixin _$AccountProfitLoss {
  @JsonKey(name: 'account_id')
  String get accountId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'realized_pnl')
  double get realizedPnl => throw _privateConstructorUsedError;
  @JsonKey(name: 'unrealized_pnl')
  double get unrealizedPnl => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pnl')
  double get totalPnl => throw _privateConstructorUsedError;

  /// Serializes this AccountProfitLoss to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountProfitLossCopyWith<AccountProfitLoss> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountProfitLossCopyWith<$Res> {
  factory $AccountProfitLossCopyWith(
    AccountProfitLoss value,
    $Res Function(AccountProfitLoss) then,
  ) = _$AccountProfitLossCopyWithImpl<$Res, AccountProfitLoss>;
  @useResult
  $Res call({
    @JsonKey(name: 'account_id') String accountId,
    String name,
    @JsonKey(name: 'realized_pnl') double realizedPnl,
    @JsonKey(name: 'unrealized_pnl') double unrealizedPnl,
    @JsonKey(name: 'total_pnl') double totalPnl,
  });
}

/// @nodoc
class _$AccountProfitLossCopyWithImpl<$Res, $Val extends AccountProfitLoss>
    implements $AccountProfitLossCopyWith<$Res> {
  _$AccountProfitLossCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? name = null,
    Object? realizedPnl = null,
    Object? unrealizedPnl = null,
    Object? totalPnl = null,
  }) {
    return _then(
      _value.copyWith(
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            realizedPnl: null == realizedPnl
                ? _value.realizedPnl
                : realizedPnl // ignore: cast_nullable_to_non_nullable
                      as double,
            unrealizedPnl: null == unrealizedPnl
                ? _value.unrealizedPnl
                : unrealizedPnl // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPnl: null == totalPnl
                ? _value.totalPnl
                : totalPnl // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountProfitLossImplCopyWith<$Res>
    implements $AccountProfitLossCopyWith<$Res> {
  factory _$$AccountProfitLossImplCopyWith(
    _$AccountProfitLossImpl value,
    $Res Function(_$AccountProfitLossImpl) then,
  ) = __$$AccountProfitLossImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'account_id') String accountId,
    String name,
    @JsonKey(name: 'realized_pnl') double realizedPnl,
    @JsonKey(name: 'unrealized_pnl') double unrealizedPnl,
    @JsonKey(name: 'total_pnl') double totalPnl,
  });
}

/// @nodoc
class __$$AccountProfitLossImplCopyWithImpl<$Res>
    extends _$AccountProfitLossCopyWithImpl<$Res, _$AccountProfitLossImpl>
    implements _$$AccountProfitLossImplCopyWith<$Res> {
  __$$AccountProfitLossImplCopyWithImpl(
    _$AccountProfitLossImpl _value,
    $Res Function(_$AccountProfitLossImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? name = null,
    Object? realizedPnl = null,
    Object? unrealizedPnl = null,
    Object? totalPnl = null,
  }) {
    return _then(
      _$AccountProfitLossImpl(
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        realizedPnl: null == realizedPnl
            ? _value.realizedPnl
            : realizedPnl // ignore: cast_nullable_to_non_nullable
                  as double,
        unrealizedPnl: null == unrealizedPnl
            ? _value.unrealizedPnl
            : unrealizedPnl // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPnl: null == totalPnl
            ? _value.totalPnl
            : totalPnl // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountProfitLossImpl implements _AccountProfitLoss {
  const _$AccountProfitLossImpl({
    @JsonKey(name: 'account_id') required this.accountId,
    required this.name,
    @JsonKey(name: 'realized_pnl') required this.realizedPnl,
    @JsonKey(name: 'unrealized_pnl') required this.unrealizedPnl,
    @JsonKey(name: 'total_pnl') required this.totalPnl,
  });

  factory _$AccountProfitLossImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountProfitLossImplFromJson(json);

  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  final String name;
  @override
  @JsonKey(name: 'realized_pnl')
  final double realizedPnl;
  @override
  @JsonKey(name: 'unrealized_pnl')
  final double unrealizedPnl;
  @override
  @JsonKey(name: 'total_pnl')
  final double totalPnl;

  @override
  String toString() {
    return 'AccountProfitLoss(accountId: $accountId, name: $name, realizedPnl: $realizedPnl, unrealizedPnl: $unrealizedPnl, totalPnl: $totalPnl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountProfitLossImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.realizedPnl, realizedPnl) ||
                other.realizedPnl == realizedPnl) &&
            (identical(other.unrealizedPnl, unrealizedPnl) ||
                other.unrealizedPnl == unrealizedPnl) &&
            (identical(other.totalPnl, totalPnl) ||
                other.totalPnl == totalPnl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accountId,
    name,
    realizedPnl,
    unrealizedPnl,
    totalPnl,
  );

  /// Create a copy of AccountProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountProfitLossImplCopyWith<_$AccountProfitLossImpl> get copyWith =>
      __$$AccountProfitLossImplCopyWithImpl<_$AccountProfitLossImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountProfitLossImplToJson(this);
  }
}

abstract class _AccountProfitLoss implements AccountProfitLoss {
  const factory _AccountProfitLoss({
    @JsonKey(name: 'account_id') required final String accountId,
    required final String name,
    @JsonKey(name: 'realized_pnl') required final double realizedPnl,
    @JsonKey(name: 'unrealized_pnl') required final double unrealizedPnl,
    @JsonKey(name: 'total_pnl') required final double totalPnl,
  }) = _$AccountProfitLossImpl;

  factory _AccountProfitLoss.fromJson(Map<String, dynamic> json) =
      _$AccountProfitLossImpl.fromJson;

  @override
  @JsonKey(name: 'account_id')
  String get accountId;
  @override
  String get name;
  @override
  @JsonKey(name: 'realized_pnl')
  double get realizedPnl;
  @override
  @JsonKey(name: 'unrealized_pnl')
  double get unrealizedPnl;
  @override
  @JsonKey(name: 'total_pnl')
  double get totalPnl;

  /// Create a copy of AccountProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountProfitLossImplCopyWith<_$AccountProfitLossImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
