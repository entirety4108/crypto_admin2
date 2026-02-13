// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PortfolioSummary _$PortfolioSummaryFromJson(Map<String, dynamic> json) {
  return _PortfolioSummary.fromJson(json);
}

/// @nodoc
mixin _$PortfolioSummary {
  @JsonKey(name: 'total_value_jpy')
  double get totalValueJpy => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cost_basis_jpy')
  double get totalCostBasisJpy => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_profit_loss_jpy')
  double get totalProfitLossJpy => throw _privateConstructorUsedError;
  @JsonKey(name: 'profit_loss_percentage')
  double get profitLossPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated')
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this PortfolioSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortfolioSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortfolioSummaryCopyWith<PortfolioSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioSummaryCopyWith<$Res> {
  factory $PortfolioSummaryCopyWith(
    PortfolioSummary value,
    $Res Function(PortfolioSummary) then,
  ) = _$PortfolioSummaryCopyWithImpl<$Res, PortfolioSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_value_jpy') double totalValueJpy,
    @JsonKey(name: 'total_cost_basis_jpy') double totalCostBasisJpy,
    @JsonKey(name: 'total_profit_loss_jpy') double totalProfitLossJpy,
    @JsonKey(name: 'profit_loss_percentage') double profitLossPercentage,
    @JsonKey(name: 'last_updated') DateTime lastUpdated,
  });
}

/// @nodoc
class _$PortfolioSummaryCopyWithImpl<$Res, $Val extends PortfolioSummary>
    implements $PortfolioSummaryCopyWith<$Res> {
  _$PortfolioSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PortfolioSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalValueJpy = null,
    Object? totalCostBasisJpy = null,
    Object? totalProfitLossJpy = null,
    Object? profitLossPercentage = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            totalValueJpy: null == totalValueJpy
                ? _value.totalValueJpy
                : totalValueJpy // ignore: cast_nullable_to_non_nullable
                      as double,
            totalCostBasisJpy: null == totalCostBasisJpy
                ? _value.totalCostBasisJpy
                : totalCostBasisJpy // ignore: cast_nullable_to_non_nullable
                      as double,
            totalProfitLossJpy: null == totalProfitLossJpy
                ? _value.totalProfitLossJpy
                : totalProfitLossJpy // ignore: cast_nullable_to_non_nullable
                      as double,
            profitLossPercentage: null == profitLossPercentage
                ? _value.profitLossPercentage
                : profitLossPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PortfolioSummaryImplCopyWith<$Res>
    implements $PortfolioSummaryCopyWith<$Res> {
  factory _$$PortfolioSummaryImplCopyWith(
    _$PortfolioSummaryImpl value,
    $Res Function(_$PortfolioSummaryImpl) then,
  ) = __$$PortfolioSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_value_jpy') double totalValueJpy,
    @JsonKey(name: 'total_cost_basis_jpy') double totalCostBasisJpy,
    @JsonKey(name: 'total_profit_loss_jpy') double totalProfitLossJpy,
    @JsonKey(name: 'profit_loss_percentage') double profitLossPercentage,
    @JsonKey(name: 'last_updated') DateTime lastUpdated,
  });
}

/// @nodoc
class __$$PortfolioSummaryImplCopyWithImpl<$Res>
    extends _$PortfolioSummaryCopyWithImpl<$Res, _$PortfolioSummaryImpl>
    implements _$$PortfolioSummaryImplCopyWith<$Res> {
  __$$PortfolioSummaryImplCopyWithImpl(
    _$PortfolioSummaryImpl _value,
    $Res Function(_$PortfolioSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PortfolioSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalValueJpy = null,
    Object? totalCostBasisJpy = null,
    Object? totalProfitLossJpy = null,
    Object? profitLossPercentage = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$PortfolioSummaryImpl(
        totalValueJpy: null == totalValueJpy
            ? _value.totalValueJpy
            : totalValueJpy // ignore: cast_nullable_to_non_nullable
                  as double,
        totalCostBasisJpy: null == totalCostBasisJpy
            ? _value.totalCostBasisJpy
            : totalCostBasisJpy // ignore: cast_nullable_to_non_nullable
                  as double,
        totalProfitLossJpy: null == totalProfitLossJpy
            ? _value.totalProfitLossJpy
            : totalProfitLossJpy // ignore: cast_nullable_to_non_nullable
                  as double,
        profitLossPercentage: null == profitLossPercentage
            ? _value.profitLossPercentage
            : profitLossPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioSummaryImpl implements _PortfolioSummary {
  const _$PortfolioSummaryImpl({
    @JsonKey(name: 'total_value_jpy') required this.totalValueJpy,
    @JsonKey(name: 'total_cost_basis_jpy') required this.totalCostBasisJpy,
    @JsonKey(name: 'total_profit_loss_jpy') required this.totalProfitLossJpy,
    @JsonKey(name: 'profit_loss_percentage') required this.profitLossPercentage,
    @JsonKey(name: 'last_updated') required this.lastUpdated,
  });

  factory _$PortfolioSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_value_jpy')
  final double totalValueJpy;
  @override
  @JsonKey(name: 'total_cost_basis_jpy')
  final double totalCostBasisJpy;
  @override
  @JsonKey(name: 'total_profit_loss_jpy')
  final double totalProfitLossJpy;
  @override
  @JsonKey(name: 'profit_loss_percentage')
  final double profitLossPercentage;
  @override
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'PortfolioSummary(totalValueJpy: $totalValueJpy, totalCostBasisJpy: $totalCostBasisJpy, totalProfitLossJpy: $totalProfitLossJpy, profitLossPercentage: $profitLossPercentage, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioSummaryImpl &&
            (identical(other.totalValueJpy, totalValueJpy) ||
                other.totalValueJpy == totalValueJpy) &&
            (identical(other.totalCostBasisJpy, totalCostBasisJpy) ||
                other.totalCostBasisJpy == totalCostBasisJpy) &&
            (identical(other.totalProfitLossJpy, totalProfitLossJpy) ||
                other.totalProfitLossJpy == totalProfitLossJpy) &&
            (identical(other.profitLossPercentage, profitLossPercentage) ||
                other.profitLossPercentage == profitLossPercentage) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalValueJpy,
    totalCostBasisJpy,
    totalProfitLossJpy,
    profitLossPercentage,
    lastUpdated,
  );

  /// Create a copy of PortfolioSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioSummaryImplCopyWith<_$PortfolioSummaryImpl> get copyWith =>
      __$$PortfolioSummaryImplCopyWithImpl<_$PortfolioSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioSummaryImplToJson(this);
  }
}

abstract class _PortfolioSummary implements PortfolioSummary {
  const factory _PortfolioSummary({
    @JsonKey(name: 'total_value_jpy') required final double totalValueJpy,
    @JsonKey(name: 'total_cost_basis_jpy')
    required final double totalCostBasisJpy,
    @JsonKey(name: 'total_profit_loss_jpy')
    required final double totalProfitLossJpy,
    @JsonKey(name: 'profit_loss_percentage')
    required final double profitLossPercentage,
    @JsonKey(name: 'last_updated') required final DateTime lastUpdated,
  }) = _$PortfolioSummaryImpl;

  factory _PortfolioSummary.fromJson(Map<String, dynamic> json) =
      _$PortfolioSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_value_jpy')
  double get totalValueJpy;
  @override
  @JsonKey(name: 'total_cost_basis_jpy')
  double get totalCostBasisJpy;
  @override
  @JsonKey(name: 'total_profit_loss_jpy')
  double get totalProfitLossJpy;
  @override
  @JsonKey(name: 'profit_loss_percentage')
  double get profitLossPercentage;
  @override
  @JsonKey(name: 'last_updated')
  DateTime get lastUpdated;

  /// Create a copy of PortfolioSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortfolioSummaryImplCopyWith<_$PortfolioSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
