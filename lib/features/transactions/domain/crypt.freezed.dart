// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crypt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Crypt _$CryptFromJson(Map<String, dynamic> json) {
  return _Crypt.fromJson(json);
}

/// @nodoc
mixin _$Crypt {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_name')
  String? get projectName => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'coingecko_id')
  String? get coingeckoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Crypt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Crypt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CryptCopyWith<Crypt> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CryptCopyWith<$Res> {
  factory $CryptCopyWith(Crypt value, $Res Function(Crypt) then) =
      _$CryptCopyWithImpl<$Res, Crypt>;
  @useResult
  $Res call({
    String id,
    String symbol,
    @JsonKey(name: 'project_name') String? projectName,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? color,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'coingecko_id') String? coingeckoId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$CryptCopyWithImpl<$Res, $Val extends Crypt>
    implements $CryptCopyWith<$Res> {
  _$CryptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Crypt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? projectName = freezed,
    Object? iconUrl = freezed,
    Object? color = freezed,
    Object? isActive = null,
    Object? coingeckoId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            symbol: null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                      as String,
            projectName: freezed == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String?,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            coingeckoId: freezed == coingeckoId
                ? _value.coingeckoId
                : coingeckoId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CryptImplCopyWith<$Res> implements $CryptCopyWith<$Res> {
  factory _$$CryptImplCopyWith(
    _$CryptImpl value,
    $Res Function(_$CryptImpl) then,
  ) = __$$CryptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String symbol,
    @JsonKey(name: 'project_name') String? projectName,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? color,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'coingecko_id') String? coingeckoId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$CryptImplCopyWithImpl<$Res>
    extends _$CryptCopyWithImpl<$Res, _$CryptImpl>
    implements _$$CryptImplCopyWith<$Res> {
  __$$CryptImplCopyWithImpl(
    _$CryptImpl _value,
    $Res Function(_$CryptImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Crypt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? projectName = freezed,
    Object? iconUrl = freezed,
    Object? color = freezed,
    Object? isActive = null,
    Object? coingeckoId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$CryptImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        symbol: null == symbol
            ? _value.symbol
            : symbol // ignore: cast_nullable_to_non_nullable
                  as String,
        projectName: freezed == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String?,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        coingeckoId: freezed == coingeckoId
            ? _value.coingeckoId
            : coingeckoId // ignore: cast_nullable_to_non_nullable
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
class _$CryptImpl implements _Crypt {
  const _$CryptImpl({
    required this.id,
    required this.symbol,
    @JsonKey(name: 'project_name') this.projectName,
    @JsonKey(name: 'icon_url') this.iconUrl,
    this.color,
    @JsonKey(name: 'is_active') required this.isActive,
    @JsonKey(name: 'coingecko_id') this.coingeckoId,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$CryptImpl.fromJson(Map<String, dynamic> json) =>
      _$$CryptImplFromJson(json);

  @override
  final String id;
  @override
  final String symbol;
  @override
  @JsonKey(name: 'project_name')
  final String? projectName;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String? color;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'coingecko_id')
  final String? coingeckoId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Crypt(id: $id, symbol: $symbol, projectName: $projectName, iconUrl: $iconUrl, color: $color, isActive: $isActive, coingeckoId: $coingeckoId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CryptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.coingeckoId, coingeckoId) ||
                other.coingeckoId == coingeckoId) &&
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
    symbol,
    projectName,
    iconUrl,
    color,
    isActive,
    coingeckoId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Crypt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CryptImplCopyWith<_$CryptImpl> get copyWith =>
      __$$CryptImplCopyWithImpl<_$CryptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CryptImplToJson(this);
  }
}

abstract class _Crypt implements Crypt {
  const factory _Crypt({
    required final String id,
    required final String symbol,
    @JsonKey(name: 'project_name') final String? projectName,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    final String? color,
    @JsonKey(name: 'is_active') required final bool isActive,
    @JsonKey(name: 'coingecko_id') final String? coingeckoId,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$CryptImpl;

  factory _Crypt.fromJson(Map<String, dynamic> json) = _$CryptImpl.fromJson;

  @override
  String get id;
  @override
  String get symbol;
  @override
  @JsonKey(name: 'project_name')
  String? get projectName;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String? get color;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'coingecko_id')
  String? get coingeckoId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Crypt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CryptImplCopyWith<_$CryptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
