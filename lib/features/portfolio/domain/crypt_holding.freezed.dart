// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crypt_holding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CryptHolding _$CryptHoldingFromJson(Map<String, dynamic> json) {
  return _CryptHolding.fromJson(json);
}

/// @nodoc
mixin _$CryptHolding {
  @JsonKey(name: 'crypt_id')
  String get cryptId => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_cost_basis_jpy')
  double get avgCostBasisJpy => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_price_jpy')
  double get currentPriceJpy => throw _privateConstructorUsedError;
  @JsonKey(name: 'value_jpy')
  double get valueJpy => throw _privateConstructorUsedError;
  @JsonKey(name: 'profit_loss_jpy')
  double get profitLossJpy => throw _privateConstructorUsedError;
  @JsonKey(name: 'profit_loss_percentage')
  double get profitLossPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this CryptHolding to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CryptHolding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CryptHoldingCopyWith<CryptHolding> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CryptHoldingCopyWith<$Res> {
  factory $CryptHoldingCopyWith(
    CryptHolding value,
    $Res Function(CryptHolding) then,
  ) = _$CryptHoldingCopyWithImpl<$Res, CryptHolding>;
  @useResult
  $Res call({
    @JsonKey(name: 'crypt_id') String cryptId,
    String symbol,
    String name,
    double amount,
    @JsonKey(name: 'avg_cost_basis_jpy') double avgCostBasisJpy,
    @JsonKey(name: 'current_price_jpy') double currentPriceJpy,
    @JsonKey(name: 'value_jpy') double valueJpy,
    @JsonKey(name: 'profit_loss_jpy') double profitLossJpy,
    @JsonKey(name: 'profit_loss_percentage') double profitLossPercentage,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? color,
  });
}

/// @nodoc
class _$CryptHoldingCopyWithImpl<$Res, $Val extends CryptHolding>
    implements $CryptHoldingCopyWith<$Res> {
  _$CryptHoldingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CryptHolding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cryptId = null,
    Object? symbol = null,
    Object? name = null,
    Object? amount = null,
    Object? avgCostBasisJpy = null,
    Object? currentPriceJpy = null,
    Object? valueJpy = null,
    Object? profitLossJpy = null,
    Object? profitLossPercentage = null,
    Object? iconUrl = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _value.copyWith(
            cryptId: null == cryptId
                ? _value.cryptId
                : cryptId // ignore: cast_nullable_to_non_nullable
                      as String,
            symbol: null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            avgCostBasisJpy: null == avgCostBasisJpy
                ? _value.avgCostBasisJpy
                : avgCostBasisJpy // ignore: cast_nullable_to_non_nullable
                      as double,
            currentPriceJpy: null == currentPriceJpy
                ? _value.currentPriceJpy
                : currentPriceJpy // ignore: cast_nullable_to_non_nullable
                      as double,
            valueJpy: null == valueJpy
                ? _value.valueJpy
                : valueJpy // ignore: cast_nullable_to_non_nullable
                      as double,
            profitLossJpy: null == profitLossJpy
                ? _value.profitLossJpy
                : profitLossJpy // ignore: cast_nullable_to_non_nullable
                      as double,
            profitLossPercentage: null == profitLossPercentage
                ? _value.profitLossPercentage
                : profitLossPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CryptHoldingImplCopyWith<$Res>
    implements $CryptHoldingCopyWith<$Res> {
  factory _$$CryptHoldingImplCopyWith(
    _$CryptHoldingImpl value,
    $Res Function(_$CryptHoldingImpl) then,
  ) = __$$CryptHoldingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'crypt_id') String cryptId,
    String symbol,
    String name,
    double amount,
    @JsonKey(name: 'avg_cost_basis_jpy') double avgCostBasisJpy,
    @JsonKey(name: 'current_price_jpy') double currentPriceJpy,
    @JsonKey(name: 'value_jpy') double valueJpy,
    @JsonKey(name: 'profit_loss_jpy') double profitLossJpy,
    @JsonKey(name: 'profit_loss_percentage') double profitLossPercentage,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? color,
  });
}

/// @nodoc
class __$$CryptHoldingImplCopyWithImpl<$Res>
    extends _$CryptHoldingCopyWithImpl<$Res, _$CryptHoldingImpl>
    implements _$$CryptHoldingImplCopyWith<$Res> {
  __$$CryptHoldingImplCopyWithImpl(
    _$CryptHoldingImpl _value,
    $Res Function(_$CryptHoldingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CryptHolding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cryptId = null,
    Object? symbol = null,
    Object? name = null,
    Object? amount = null,
    Object? avgCostBasisJpy = null,
    Object? currentPriceJpy = null,
    Object? valueJpy = null,
    Object? profitLossJpy = null,
    Object? profitLossPercentage = null,
    Object? iconUrl = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _$CryptHoldingImpl(
        cryptId: null == cryptId
            ? _value.cryptId
            : cryptId // ignore: cast_nullable_to_non_nullable
                  as String,
        symbol: null == symbol
            ? _value.symbol
            : symbol // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        avgCostBasisJpy: null == avgCostBasisJpy
            ? _value.avgCostBasisJpy
            : avgCostBasisJpy // ignore: cast_nullable_to_non_nullable
                  as double,
        currentPriceJpy: null == currentPriceJpy
            ? _value.currentPriceJpy
            : currentPriceJpy // ignore: cast_nullable_to_non_nullable
                  as double,
        valueJpy: null == valueJpy
            ? _value.valueJpy
            : valueJpy // ignore: cast_nullable_to_non_nullable
                  as double,
        profitLossJpy: null == profitLossJpy
            ? _value.profitLossJpy
            : profitLossJpy // ignore: cast_nullable_to_non_nullable
                  as double,
        profitLossPercentage: null == profitLossPercentage
            ? _value.profitLossPercentage
            : profitLossPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CryptHoldingImpl implements _CryptHolding {
  const _$CryptHoldingImpl({
    @JsonKey(name: 'crypt_id') required this.cryptId,
    required this.symbol,
    required this.name,
    required this.amount,
    @JsonKey(name: 'avg_cost_basis_jpy') required this.avgCostBasisJpy,
    @JsonKey(name: 'current_price_jpy') required this.currentPriceJpy,
    @JsonKey(name: 'value_jpy') required this.valueJpy,
    @JsonKey(name: 'profit_loss_jpy') required this.profitLossJpy,
    @JsonKey(name: 'profit_loss_percentage') required this.profitLossPercentage,
    @JsonKey(name: 'icon_url') this.iconUrl,
    this.color,
  });

  factory _$CryptHoldingImpl.fromJson(Map<String, dynamic> json) =>
      _$$CryptHoldingImplFromJson(json);

  @override
  @JsonKey(name: 'crypt_id')
  final String cryptId;
  @override
  final String symbol;
  @override
  final String name;
  @override
  final double amount;
  @override
  @JsonKey(name: 'avg_cost_basis_jpy')
  final double avgCostBasisJpy;
  @override
  @JsonKey(name: 'current_price_jpy')
  final double currentPriceJpy;
  @override
  @JsonKey(name: 'value_jpy')
  final double valueJpy;
  @override
  @JsonKey(name: 'profit_loss_jpy')
  final double profitLossJpy;
  @override
  @JsonKey(name: 'profit_loss_percentage')
  final double profitLossPercentage;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String? color;

  @override
  String toString() {
    return 'CryptHolding(cryptId: $cryptId, symbol: $symbol, name: $name, amount: $amount, avgCostBasisJpy: $avgCostBasisJpy, currentPriceJpy: $currentPriceJpy, valueJpy: $valueJpy, profitLossJpy: $profitLossJpy, profitLossPercentage: $profitLossPercentage, iconUrl: $iconUrl, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CryptHoldingImpl &&
            (identical(other.cryptId, cryptId) || other.cryptId == cryptId) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.avgCostBasisJpy, avgCostBasisJpy) ||
                other.avgCostBasisJpy == avgCostBasisJpy) &&
            (identical(other.currentPriceJpy, currentPriceJpy) ||
                other.currentPriceJpy == currentPriceJpy) &&
            (identical(other.valueJpy, valueJpy) ||
                other.valueJpy == valueJpy) &&
            (identical(other.profitLossJpy, profitLossJpy) ||
                other.profitLossJpy == profitLossJpy) &&
            (identical(other.profitLossPercentage, profitLossPercentage) ||
                other.profitLossPercentage == profitLossPercentage) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cryptId,
    symbol,
    name,
    amount,
    avgCostBasisJpy,
    currentPriceJpy,
    valueJpy,
    profitLossJpy,
    profitLossPercentage,
    iconUrl,
    color,
  );

  /// Create a copy of CryptHolding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CryptHoldingImplCopyWith<_$CryptHoldingImpl> get copyWith =>
      __$$CryptHoldingImplCopyWithImpl<_$CryptHoldingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CryptHoldingImplToJson(this);
  }
}

abstract class _CryptHolding implements CryptHolding {
  const factory _CryptHolding({
    @JsonKey(name: 'crypt_id') required final String cryptId,
    required final String symbol,
    required final String name,
    required final double amount,
    @JsonKey(name: 'avg_cost_basis_jpy') required final double avgCostBasisJpy,
    @JsonKey(name: 'current_price_jpy') required final double currentPriceJpy,
    @JsonKey(name: 'value_jpy') required final double valueJpy,
    @JsonKey(name: 'profit_loss_jpy') required final double profitLossJpy,
    @JsonKey(name: 'profit_loss_percentage')
    required final double profitLossPercentage,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    final String? color,
  }) = _$CryptHoldingImpl;

  factory _CryptHolding.fromJson(Map<String, dynamic> json) =
      _$CryptHoldingImpl.fromJson;

  @override
  @JsonKey(name: 'crypt_id')
  String get cryptId;
  @override
  String get symbol;
  @override
  String get name;
  @override
  double get amount;
  @override
  @JsonKey(name: 'avg_cost_basis_jpy')
  double get avgCostBasisJpy;
  @override
  @JsonKey(name: 'current_price_jpy')
  double get currentPriceJpy;
  @override
  @JsonKey(name: 'value_jpy')
  double get valueJpy;
  @override
  @JsonKey(name: 'profit_loss_jpy')
  double get profitLossJpy;
  @override
  @JsonKey(name: 'profit_loss_percentage')
  double get profitLossPercentage;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String? get color;

  /// Create a copy of CryptHolding
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CryptHoldingImplCopyWith<_$CryptHoldingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
