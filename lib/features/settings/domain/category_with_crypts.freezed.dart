// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_with_crypts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoryWithCrypts _$CategoryWithCryptsFromJson(Map<String, dynamic> json) {
  return _CategoryWithCrypts.fromJson(json);
}

/// @nodoc
mixin _$CategoryWithCrypts {
  CryptCategory get category => throw _privateConstructorUsedError;
  List<Crypt> get crypts => throw _privateConstructorUsedError;

  /// Serializes this CategoryWithCrypts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryWithCrypts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryWithCryptsCopyWith<CategoryWithCrypts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryWithCryptsCopyWith<$Res> {
  factory $CategoryWithCryptsCopyWith(
    CategoryWithCrypts value,
    $Res Function(CategoryWithCrypts) then,
  ) = _$CategoryWithCryptsCopyWithImpl<$Res, CategoryWithCrypts>;
  @useResult
  $Res call({CryptCategory category, List<Crypt> crypts});

  $CryptCategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$CategoryWithCryptsCopyWithImpl<$Res, $Val extends CategoryWithCrypts>
    implements $CategoryWithCryptsCopyWith<$Res> {
  _$CategoryWithCryptsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryWithCrypts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? crypts = null}) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as CryptCategory,
            crypts: null == crypts
                ? _value.crypts
                : crypts // ignore: cast_nullable_to_non_nullable
                      as List<Crypt>,
          )
          as $Val,
    );
  }

  /// Create a copy of CategoryWithCrypts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CryptCategoryCopyWith<$Res> get category {
    return $CryptCategoryCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryWithCryptsImplCopyWith<$Res>
    implements $CategoryWithCryptsCopyWith<$Res> {
  factory _$$CategoryWithCryptsImplCopyWith(
    _$CategoryWithCryptsImpl value,
    $Res Function(_$CategoryWithCryptsImpl) then,
  ) = __$$CategoryWithCryptsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CryptCategory category, List<Crypt> crypts});

  @override
  $CryptCategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$$CategoryWithCryptsImplCopyWithImpl<$Res>
    extends _$CategoryWithCryptsCopyWithImpl<$Res, _$CategoryWithCryptsImpl>
    implements _$$CategoryWithCryptsImplCopyWith<$Res> {
  __$$CategoryWithCryptsImplCopyWithImpl(
    _$CategoryWithCryptsImpl _value,
    $Res Function(_$CategoryWithCryptsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryWithCrypts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? crypts = null}) {
    return _then(
      _$CategoryWithCryptsImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as CryptCategory,
        crypts: null == crypts
            ? _value._crypts
            : crypts // ignore: cast_nullable_to_non_nullable
                  as List<Crypt>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryWithCryptsImpl implements _CategoryWithCrypts {
  const _$CategoryWithCryptsImpl({
    required this.category,
    required final List<Crypt> crypts,
  }) : _crypts = crypts;

  factory _$CategoryWithCryptsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryWithCryptsImplFromJson(json);

  @override
  final CryptCategory category;
  final List<Crypt> _crypts;
  @override
  List<Crypt> get crypts {
    if (_crypts is EqualUnmodifiableListView) return _crypts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_crypts);
  }

  @override
  String toString() {
    return 'CategoryWithCrypts(category: $category, crypts: $crypts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryWithCryptsImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._crypts, _crypts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    category,
    const DeepCollectionEquality().hash(_crypts),
  );

  /// Create a copy of CategoryWithCrypts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryWithCryptsImplCopyWith<_$CategoryWithCryptsImpl> get copyWith =>
      __$$CategoryWithCryptsImplCopyWithImpl<_$CategoryWithCryptsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryWithCryptsImplToJson(this);
  }
}

abstract class _CategoryWithCrypts implements CategoryWithCrypts {
  const factory _CategoryWithCrypts({
    required final CryptCategory category,
    required final List<Crypt> crypts,
  }) = _$CategoryWithCryptsImpl;

  factory _CategoryWithCrypts.fromJson(Map<String, dynamic> json) =
      _$CategoryWithCryptsImpl.fromJson;

  @override
  CryptCategory get category;
  @override
  List<Crypt> get crypts;

  /// Create a copy of CategoryWithCrypts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryWithCryptsImplCopyWith<_$CategoryWithCryptsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
