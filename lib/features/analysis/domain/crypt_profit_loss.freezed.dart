// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crypt_profit_loss.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CryptProfitLoss _$CryptProfitLossFromJson(Map<String, dynamic> json) {
  return _CryptProfitLoss.fromJson(json);
}

/// @nodoc
mixin _$CryptProfitLoss {
  @JsonKey(name: 'crypt_id')
  String get cryptId => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'realized_pnl')
  double get realizedPnl => throw _privateConstructorUsedError;
  @JsonKey(name: 'unrealized_pnl')
  double get unrealizedPnl => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pnl')
  double get totalPnl => throw _privateConstructorUsedError;

  /// Serializes this CryptProfitLoss to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CryptProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CryptProfitLossCopyWith<CryptProfitLoss> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CryptProfitLossCopyWith<$Res> {
  factory $CryptProfitLossCopyWith(
    CryptProfitLoss value,
    $Res Function(CryptProfitLoss) then,
  ) = _$CryptProfitLossCopyWithImpl<$Res, CryptProfitLoss>;
  @useResult
  $Res call({
    @JsonKey(name: 'crypt_id') String cryptId,
    String symbol,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'realized_pnl') double realizedPnl,
    @JsonKey(name: 'unrealized_pnl') double unrealizedPnl,
    @JsonKey(name: 'total_pnl') double totalPnl,
  });
}

/// @nodoc
class _$CryptProfitLossCopyWithImpl<$Res, $Val extends CryptProfitLoss>
    implements $CryptProfitLossCopyWith<$Res> {
  _$CryptProfitLossCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CryptProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cryptId = null,
    Object? symbol = null,
    Object? iconUrl = freezed,
    Object? realizedPnl = null,
    Object? unrealizedPnl = null,
    Object? totalPnl = null,
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
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$CryptProfitLossImplCopyWith<$Res>
    implements $CryptProfitLossCopyWith<$Res> {
  factory _$$CryptProfitLossImplCopyWith(
    _$CryptProfitLossImpl value,
    $Res Function(_$CryptProfitLossImpl) then,
  ) = __$$CryptProfitLossImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'crypt_id') String cryptId,
    String symbol,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'realized_pnl') double realizedPnl,
    @JsonKey(name: 'unrealized_pnl') double unrealizedPnl,
    @JsonKey(name: 'total_pnl') double totalPnl,
  });
}

/// @nodoc
class __$$CryptProfitLossImplCopyWithImpl<$Res>
    extends _$CryptProfitLossCopyWithImpl<$Res, _$CryptProfitLossImpl>
    implements _$$CryptProfitLossImplCopyWith<$Res> {
  __$$CryptProfitLossImplCopyWithImpl(
    _$CryptProfitLossImpl _value,
    $Res Function(_$CryptProfitLossImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CryptProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cryptId = null,
    Object? symbol = null,
    Object? iconUrl = freezed,
    Object? realizedPnl = null,
    Object? unrealizedPnl = null,
    Object? totalPnl = null,
  }) {
    return _then(
      _$CryptProfitLossImpl(
        cryptId: null == cryptId
            ? _value.cryptId
            : cryptId // ignore: cast_nullable_to_non_nullable
                  as String,
        symbol: null == symbol
            ? _value.symbol
            : symbol // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$CryptProfitLossImpl implements _CryptProfitLoss {
  const _$CryptProfitLossImpl({
    @JsonKey(name: 'crypt_id') required this.cryptId,
    required this.symbol,
    @JsonKey(name: 'icon_url') this.iconUrl,
    @JsonKey(name: 'realized_pnl') required this.realizedPnl,
    @JsonKey(name: 'unrealized_pnl') required this.unrealizedPnl,
    @JsonKey(name: 'total_pnl') required this.totalPnl,
  });

  factory _$CryptProfitLossImpl.fromJson(Map<String, dynamic> json) =>
      _$$CryptProfitLossImplFromJson(json);

  @override
  @JsonKey(name: 'crypt_id')
  final String cryptId;
  @override
  final String symbol;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
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
    return 'CryptProfitLoss(cryptId: $cryptId, symbol: $symbol, iconUrl: $iconUrl, realizedPnl: $realizedPnl, unrealizedPnl: $unrealizedPnl, totalPnl: $totalPnl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CryptProfitLossImpl &&
            (identical(other.cryptId, cryptId) || other.cryptId == cryptId) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
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
    cryptId,
    symbol,
    iconUrl,
    realizedPnl,
    unrealizedPnl,
    totalPnl,
  );

  /// Create a copy of CryptProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CryptProfitLossImplCopyWith<_$CryptProfitLossImpl> get copyWith =>
      __$$CryptProfitLossImplCopyWithImpl<_$CryptProfitLossImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CryptProfitLossImplToJson(this);
  }
}

abstract class _CryptProfitLoss implements CryptProfitLoss {
  const factory _CryptProfitLoss({
    @JsonKey(name: 'crypt_id') required final String cryptId,
    required final String symbol,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    @JsonKey(name: 'realized_pnl') required final double realizedPnl,
    @JsonKey(name: 'unrealized_pnl') required final double unrealizedPnl,
    @JsonKey(name: 'total_pnl') required final double totalPnl,
  }) = _$CryptProfitLossImpl;

  factory _CryptProfitLoss.fromJson(Map<String, dynamic> json) =
      _$CryptProfitLossImpl.fromJson;

  @override
  @JsonKey(name: 'crypt_id')
  String get cryptId;
  @override
  String get symbol;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(name: 'realized_pnl')
  double get realizedPnl;
  @override
  @JsonKey(name: 'unrealized_pnl')
  double get unrealizedPnl;
  @override
  @JsonKey(name: 'total_pnl')
  double get totalPnl;

  /// Create a copy of CryptProfitLoss
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CryptProfitLossImplCopyWith<_$CryptProfitLossImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
