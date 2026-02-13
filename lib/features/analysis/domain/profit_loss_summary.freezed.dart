// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profit_loss_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfitLossSummary _$ProfitLossSummaryFromJson(Map<String, dynamic> json) {
  return _ProfitLossSummary.fromJson(json);
}

/// @nodoc
mixin _$ProfitLossSummary {
  @JsonKey(name: 'total_realized_pnl')
  double get totalRealizedPnl => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_unrealized_pnl')
  double get totalUnrealizedPnl => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pnl')
  double get totalPnl => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;

  /// Serializes this ProfitLossSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfitLossSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfitLossSummaryCopyWith<ProfitLossSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfitLossSummaryCopyWith<$Res> {
  factory $ProfitLossSummaryCopyWith(
    ProfitLossSummary value,
    $Res Function(ProfitLossSummary) then,
  ) = _$ProfitLossSummaryCopyWithImpl<$Res, ProfitLossSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_realized_pnl') double totalRealizedPnl,
    @JsonKey(name: 'total_unrealized_pnl') double totalUnrealizedPnl,
    @JsonKey(name: 'total_pnl') double totalPnl,
    int? year,
  });
}

/// @nodoc
class _$ProfitLossSummaryCopyWithImpl<$Res, $Val extends ProfitLossSummary>
    implements $ProfitLossSummaryCopyWith<$Res> {
  _$ProfitLossSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfitLossSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRealizedPnl = null,
    Object? totalUnrealizedPnl = null,
    Object? totalPnl = null,
    Object? year = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalRealizedPnl: null == totalRealizedPnl
                ? _value.totalRealizedPnl
                : totalRealizedPnl // ignore: cast_nullable_to_non_nullable
                      as double,
            totalUnrealizedPnl: null == totalUnrealizedPnl
                ? _value.totalUnrealizedPnl
                : totalUnrealizedPnl // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPnl: null == totalPnl
                ? _value.totalPnl
                : totalPnl // ignore: cast_nullable_to_non_nullable
                      as double,
            year: freezed == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfitLossSummaryImplCopyWith<$Res>
    implements $ProfitLossSummaryCopyWith<$Res> {
  factory _$$ProfitLossSummaryImplCopyWith(
    _$ProfitLossSummaryImpl value,
    $Res Function(_$ProfitLossSummaryImpl) then,
  ) = __$$ProfitLossSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_realized_pnl') double totalRealizedPnl,
    @JsonKey(name: 'total_unrealized_pnl') double totalUnrealizedPnl,
    @JsonKey(name: 'total_pnl') double totalPnl,
    int? year,
  });
}

/// @nodoc
class __$$ProfitLossSummaryImplCopyWithImpl<$Res>
    extends _$ProfitLossSummaryCopyWithImpl<$Res, _$ProfitLossSummaryImpl>
    implements _$$ProfitLossSummaryImplCopyWith<$Res> {
  __$$ProfitLossSummaryImplCopyWithImpl(
    _$ProfitLossSummaryImpl _value,
    $Res Function(_$ProfitLossSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfitLossSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRealizedPnl = null,
    Object? totalUnrealizedPnl = null,
    Object? totalPnl = null,
    Object? year = freezed,
  }) {
    return _then(
      _$ProfitLossSummaryImpl(
        totalRealizedPnl: null == totalRealizedPnl
            ? _value.totalRealizedPnl
            : totalRealizedPnl // ignore: cast_nullable_to_non_nullable
                  as double,
        totalUnrealizedPnl: null == totalUnrealizedPnl
            ? _value.totalUnrealizedPnl
            : totalUnrealizedPnl // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPnl: null == totalPnl
            ? _value.totalPnl
            : totalPnl // ignore: cast_nullable_to_non_nullable
                  as double,
        year: freezed == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfitLossSummaryImpl implements _ProfitLossSummary {
  const _$ProfitLossSummaryImpl({
    @JsonKey(name: 'total_realized_pnl') required this.totalRealizedPnl,
    @JsonKey(name: 'total_unrealized_pnl') required this.totalUnrealizedPnl,
    @JsonKey(name: 'total_pnl') required this.totalPnl,
    this.year,
  });

  factory _$ProfitLossSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfitLossSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_realized_pnl')
  final double totalRealizedPnl;
  @override
  @JsonKey(name: 'total_unrealized_pnl')
  final double totalUnrealizedPnl;
  @override
  @JsonKey(name: 'total_pnl')
  final double totalPnl;
  @override
  final int? year;

  @override
  String toString() {
    return 'ProfitLossSummary(totalRealizedPnl: $totalRealizedPnl, totalUnrealizedPnl: $totalUnrealizedPnl, totalPnl: $totalPnl, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfitLossSummaryImpl &&
            (identical(other.totalRealizedPnl, totalRealizedPnl) ||
                other.totalRealizedPnl == totalRealizedPnl) &&
            (identical(other.totalUnrealizedPnl, totalUnrealizedPnl) ||
                other.totalUnrealizedPnl == totalUnrealizedPnl) &&
            (identical(other.totalPnl, totalPnl) ||
                other.totalPnl == totalPnl) &&
            (identical(other.year, year) || other.year == year));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalRealizedPnl,
    totalUnrealizedPnl,
    totalPnl,
    year,
  );

  /// Create a copy of ProfitLossSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfitLossSummaryImplCopyWith<_$ProfitLossSummaryImpl> get copyWith =>
      __$$ProfitLossSummaryImplCopyWithImpl<_$ProfitLossSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfitLossSummaryImplToJson(this);
  }
}

abstract class _ProfitLossSummary implements ProfitLossSummary {
  const factory _ProfitLossSummary({
    @JsonKey(name: 'total_realized_pnl') required final double totalRealizedPnl,
    @JsonKey(name: 'total_unrealized_pnl')
    required final double totalUnrealizedPnl,
    @JsonKey(name: 'total_pnl') required final double totalPnl,
    final int? year,
  }) = _$ProfitLossSummaryImpl;

  factory _ProfitLossSummary.fromJson(Map<String, dynamic> json) =
      _$ProfitLossSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_realized_pnl')
  double get totalRealizedPnl;
  @override
  @JsonKey(name: 'total_unrealized_pnl')
  double get totalUnrealizedPnl;
  @override
  @JsonKey(name: 'total_pnl')
  double get totalPnl;
  @override
  int? get year;

  /// Create a copy of ProfitLossSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfitLossSummaryImplCopyWith<_$ProfitLossSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
