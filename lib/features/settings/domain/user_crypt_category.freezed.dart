// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_crypt_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserCryptCategory _$UserCryptCategoryFromJson(Map<String, dynamic> json) {
  return _UserCryptCategory.fromJson(json);
}

/// @nodoc
mixin _$UserCryptCategory {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'crypt_id')
  String get cryptId => throw _privateConstructorUsedError;

  /// Serializes this UserCryptCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserCryptCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCryptCategoryCopyWith<UserCryptCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCryptCategoryCopyWith<$Res> {
  factory $UserCryptCategoryCopyWith(
    UserCryptCategory value,
    $Res Function(UserCryptCategory) then,
  ) = _$UserCryptCategoryCopyWithImpl<$Res, UserCryptCategory>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'category_id') String categoryId,
    @JsonKey(name: 'crypt_id') String cryptId,
  });
}

/// @nodoc
class _$UserCryptCategoryCopyWithImpl<$Res, $Val extends UserCryptCategory>
    implements $UserCryptCategoryCopyWith<$Res> {
  _$UserCryptCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserCryptCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? categoryId = null,
    Object? cryptId = null,
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
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            cryptId: null == cryptId
                ? _value.cryptId
                : cryptId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserCryptCategoryImplCopyWith<$Res>
    implements $UserCryptCategoryCopyWith<$Res> {
  factory _$$UserCryptCategoryImplCopyWith(
    _$UserCryptCategoryImpl value,
    $Res Function(_$UserCryptCategoryImpl) then,
  ) = __$$UserCryptCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'category_id') String categoryId,
    @JsonKey(name: 'crypt_id') String cryptId,
  });
}

/// @nodoc
class __$$UserCryptCategoryImplCopyWithImpl<$Res>
    extends _$UserCryptCategoryCopyWithImpl<$Res, _$UserCryptCategoryImpl>
    implements _$$UserCryptCategoryImplCopyWith<$Res> {
  __$$UserCryptCategoryImplCopyWithImpl(
    _$UserCryptCategoryImpl _value,
    $Res Function(_$UserCryptCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserCryptCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? categoryId = null,
    Object? cryptId = null,
  }) {
    return _then(
      _$UserCryptCategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        cryptId: null == cryptId
            ? _value.cryptId
            : cryptId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserCryptCategoryImpl implements _UserCryptCategory {
  const _$UserCryptCategoryImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'category_id') required this.categoryId,
    @JsonKey(name: 'crypt_id') required this.cryptId,
  });

  factory _$UserCryptCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCryptCategoryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  @JsonKey(name: 'crypt_id')
  final String cryptId;

  @override
  String toString() {
    return 'UserCryptCategory(id: $id, userId: $userId, categoryId: $categoryId, cryptId: $cryptId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCryptCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.cryptId, cryptId) || other.cryptId == cryptId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, categoryId, cryptId);

  /// Create a copy of UserCryptCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCryptCategoryImplCopyWith<_$UserCryptCategoryImpl> get copyWith =>
      __$$UserCryptCategoryImplCopyWithImpl<_$UserCryptCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCryptCategoryImplToJson(this);
  }
}

abstract class _UserCryptCategory implements UserCryptCategory {
  const factory _UserCryptCategory({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'category_id') required final String categoryId,
    @JsonKey(name: 'crypt_id') required final String cryptId,
  }) = _$UserCryptCategoryImpl;

  factory _UserCryptCategory.fromJson(Map<String, dynamic> json) =
      _$UserCryptCategoryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  @JsonKey(name: 'crypt_id')
  String get cryptId;

  /// Create a copy of UserCryptCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserCryptCategoryImplCopyWith<_$UserCryptCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
