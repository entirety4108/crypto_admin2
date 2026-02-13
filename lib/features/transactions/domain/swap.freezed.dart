// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Swap _$SwapFromJson(Map<String, dynamic> json) {
  return _Swap.fromJson(json);
}

/// @nodoc
mixin _$Swap {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'sell_id')
  String get sellId => throw _privateConstructorUsedError;
  @JsonKey(name: 'buy_id')
  String get buyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'exec_at')
  DateTime get execAt => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Swap to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Swap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapCopyWith<Swap> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapCopyWith<$Res> {
  factory $SwapCopyWith(Swap value, $Res Function(Swap) then) =
      _$SwapCopyWithImpl<$Res, Swap>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'sell_id') String sellId,
    @JsonKey(name: 'buy_id') String buyId,
    @JsonKey(name: 'exec_at') DateTime execAt,
    String? memo,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$SwapCopyWithImpl<$Res, $Val extends Swap>
    implements $SwapCopyWith<$Res> {
  _$SwapCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Swap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellId = null,
    Object? buyId = null,
    Object? execAt = null,
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
            sellId: null == sellId
                ? _value.sellId
                : sellId // ignore: cast_nullable_to_non_nullable
                      as String,
            buyId: null == buyId
                ? _value.buyId
                : buyId // ignore: cast_nullable_to_non_nullable
                      as String,
            execAt: null == execAt
                ? _value.execAt
                : execAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
abstract class _$$SwapImplCopyWith<$Res> implements $SwapCopyWith<$Res> {
  factory _$$SwapImplCopyWith(
    _$SwapImpl value,
    $Res Function(_$SwapImpl) then,
  ) = __$$SwapImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'sell_id') String sellId,
    @JsonKey(name: 'buy_id') String buyId,
    @JsonKey(name: 'exec_at') DateTime execAt,
    String? memo,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$SwapImplCopyWithImpl<$Res>
    extends _$SwapCopyWithImpl<$Res, _$SwapImpl>
    implements _$$SwapImplCopyWith<$Res> {
  __$$SwapImplCopyWithImpl(_$SwapImpl _value, $Res Function(_$SwapImpl) _then)
    : super(_value, _then);

  /// Create a copy of Swap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellId = null,
    Object? buyId = null,
    Object? execAt = null,
    Object? memo = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SwapImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sellId: null == sellId
            ? _value.sellId
            : sellId // ignore: cast_nullable_to_non_nullable
                  as String,
        buyId: null == buyId
            ? _value.buyId
            : buyId // ignore: cast_nullable_to_non_nullable
                  as String,
        execAt: null == execAt
            ? _value.execAt
            : execAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$SwapImpl implements _Swap {
  const _$SwapImpl({
    required this.id,
    @JsonKey(name: 'sell_id') required this.sellId,
    @JsonKey(name: 'buy_id') required this.buyId,
    @JsonKey(name: 'exec_at') required this.execAt,
    this.memo,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$SwapImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwapImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'sell_id')
  final String sellId;
  @override
  @JsonKey(name: 'buy_id')
  final String buyId;
  @override
  @JsonKey(name: 'exec_at')
  final DateTime execAt;
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
    return 'Swap(id: $id, sellId: $sellId, buyId: $buyId, execAt: $execAt, memo: $memo, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sellId, sellId) || other.sellId == sellId) &&
            (identical(other.buyId, buyId) || other.buyId == buyId) &&
            (identical(other.execAt, execAt) || other.execAt == execAt) &&
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
    sellId,
    buyId,
    execAt,
    memo,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Swap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapImplCopyWith<_$SwapImpl> get copyWith =>
      __$$SwapImplCopyWithImpl<_$SwapImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwapImplToJson(this);
  }
}

abstract class _Swap implements Swap {
  const factory _Swap({
    required final String id,
    @JsonKey(name: 'sell_id') required final String sellId,
    @JsonKey(name: 'buy_id') required final String buyId,
    @JsonKey(name: 'exec_at') required final DateTime execAt,
    final String? memo,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$SwapImpl;

  factory _Swap.fromJson(Map<String, dynamic> json) = _$SwapImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'sell_id')
  String get sellId;
  @override
  @JsonKey(name: 'buy_id')
  String get buyId;
  @override
  @JsonKey(name: 'exec_at')
  DateTime get execAt;
  @override
  String? get memo;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Swap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapImplCopyWith<_$SwapImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
