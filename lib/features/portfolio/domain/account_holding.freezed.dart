// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_holding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AccountHolding _$AccountHoldingFromJson(Map<String, dynamic> json) {
  return _AccountHolding.fromJson(json);
}

/// @nodoc
mixin _$AccountHolding {
  @JsonKey(name: 'account_id')
  String get accountId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<CryptHolding> get holdings => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_value_jpy')
  double get totalValueJpy => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_profit_loss_jpy')
  double get totalProfitLossJpy => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;

  /// Serializes this AccountHolding to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountHolding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountHoldingCopyWith<AccountHolding> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountHoldingCopyWith<$Res> {
  factory $AccountHoldingCopyWith(
    AccountHolding value,
    $Res Function(AccountHolding) then,
  ) = _$AccountHoldingCopyWithImpl<$Res, AccountHolding>;
  @useResult
  $Res call({
    @JsonKey(name: 'account_id') String accountId,
    String name,
    List<CryptHolding> holdings,
    @JsonKey(name: 'total_value_jpy') double totalValueJpy,
    @JsonKey(name: 'total_profit_loss_jpy') double totalProfitLossJpy,
    @JsonKey(name: 'icon_url') String? iconUrl,
  });
}

/// @nodoc
class _$AccountHoldingCopyWithImpl<$Res, $Val extends AccountHolding>
    implements $AccountHoldingCopyWith<$Res> {
  _$AccountHoldingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountHolding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? name = null,
    Object? holdings = null,
    Object? totalValueJpy = null,
    Object? totalProfitLossJpy = null,
    Object? iconUrl = freezed,
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
            holdings: null == holdings
                ? _value.holdings
                : holdings // ignore: cast_nullable_to_non_nullable
                      as List<CryptHolding>,
            totalValueJpy: null == totalValueJpy
                ? _value.totalValueJpy
                : totalValueJpy // ignore: cast_nullable_to_non_nullable
                      as double,
            totalProfitLossJpy: null == totalProfitLossJpy
                ? _value.totalProfitLossJpy
                : totalProfitLossJpy // ignore: cast_nullable_to_non_nullable
                      as double,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountHoldingImplCopyWith<$Res>
    implements $AccountHoldingCopyWith<$Res> {
  factory _$$AccountHoldingImplCopyWith(
    _$AccountHoldingImpl value,
    $Res Function(_$AccountHoldingImpl) then,
  ) = __$$AccountHoldingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'account_id') String accountId,
    String name,
    List<CryptHolding> holdings,
    @JsonKey(name: 'total_value_jpy') double totalValueJpy,
    @JsonKey(name: 'total_profit_loss_jpy') double totalProfitLossJpy,
    @JsonKey(name: 'icon_url') String? iconUrl,
  });
}

/// @nodoc
class __$$AccountHoldingImplCopyWithImpl<$Res>
    extends _$AccountHoldingCopyWithImpl<$Res, _$AccountHoldingImpl>
    implements _$$AccountHoldingImplCopyWith<$Res> {
  __$$AccountHoldingImplCopyWithImpl(
    _$AccountHoldingImpl _value,
    $Res Function(_$AccountHoldingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountHolding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? name = null,
    Object? holdings = null,
    Object? totalValueJpy = null,
    Object? totalProfitLossJpy = null,
    Object? iconUrl = freezed,
  }) {
    return _then(
      _$AccountHoldingImpl(
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        holdings: null == holdings
            ? _value._holdings
            : holdings // ignore: cast_nullable_to_non_nullable
                  as List<CryptHolding>,
        totalValueJpy: null == totalValueJpy
            ? _value.totalValueJpy
            : totalValueJpy // ignore: cast_nullable_to_non_nullable
                  as double,
        totalProfitLossJpy: null == totalProfitLossJpy
            ? _value.totalProfitLossJpy
            : totalProfitLossJpy // ignore: cast_nullable_to_non_nullable
                  as double,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountHoldingImpl implements _AccountHolding {
  const _$AccountHoldingImpl({
    @JsonKey(name: 'account_id') required this.accountId,
    required this.name,
    required final List<CryptHolding> holdings,
    @JsonKey(name: 'total_value_jpy') required this.totalValueJpy,
    @JsonKey(name: 'total_profit_loss_jpy') required this.totalProfitLossJpy,
    @JsonKey(name: 'icon_url') this.iconUrl,
  }) : _holdings = holdings;

  factory _$AccountHoldingImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountHoldingImplFromJson(json);

  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  final String name;
  final List<CryptHolding> _holdings;
  @override
  List<CryptHolding> get holdings {
    if (_holdings is EqualUnmodifiableListView) return _holdings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_holdings);
  }

  @override
  @JsonKey(name: 'total_value_jpy')
  final double totalValueJpy;
  @override
  @JsonKey(name: 'total_profit_loss_jpy')
  final double totalProfitLossJpy;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  @override
  String toString() {
    return 'AccountHolding(accountId: $accountId, name: $name, holdings: $holdings, totalValueJpy: $totalValueJpy, totalProfitLossJpy: $totalProfitLossJpy, iconUrl: $iconUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountHoldingImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._holdings, _holdings) &&
            (identical(other.totalValueJpy, totalValueJpy) ||
                other.totalValueJpy == totalValueJpy) &&
            (identical(other.totalProfitLossJpy, totalProfitLossJpy) ||
                other.totalProfitLossJpy == totalProfitLossJpy) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accountId,
    name,
    const DeepCollectionEquality().hash(_holdings),
    totalValueJpy,
    totalProfitLossJpy,
    iconUrl,
  );

  /// Create a copy of AccountHolding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountHoldingImplCopyWith<_$AccountHoldingImpl> get copyWith =>
      __$$AccountHoldingImplCopyWithImpl<_$AccountHoldingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountHoldingImplToJson(this);
  }
}

abstract class _AccountHolding implements AccountHolding {
  const factory _AccountHolding({
    @JsonKey(name: 'account_id') required final String accountId,
    required final String name,
    required final List<CryptHolding> holdings,
    @JsonKey(name: 'total_value_jpy') required final double totalValueJpy,
    @JsonKey(name: 'total_profit_loss_jpy')
    required final double totalProfitLossJpy,
    @JsonKey(name: 'icon_url') final String? iconUrl,
  }) = _$AccountHoldingImpl;

  factory _AccountHolding.fromJson(Map<String, dynamic> json) =
      _$AccountHoldingImpl.fromJson;

  @override
  @JsonKey(name: 'account_id')
  String get accountId;
  @override
  String get name;
  @override
  List<CryptHolding> get holdings;
  @override
  @JsonKey(name: 'total_value_jpy')
  double get totalValueJpy;
  @override
  @JsonKey(name: 'total_profit_loss_jpy')
  double get totalProfitLossJpy;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;

  /// Create a copy of AccountHolding
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountHoldingImplCopyWith<_$AccountHoldingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
