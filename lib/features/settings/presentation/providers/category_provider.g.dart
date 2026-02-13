// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryRepositoryHash() =>
    r'2c639f6980a7270515ebbdc08e1c3a4bf104027f';

/// See also [categoryRepository].
@ProviderFor(categoryRepository)
final categoryRepositoryProvider =
    AutoDisposeProvider<CategoryRepository>.internal(
      categoryRepository,
      name: r'categoryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryRepositoryRef = AutoDisposeProviderRef<CategoryRepository>;
String _$categoryWithCryptsHash() =>
    r'a958d6cb8504efb2c177598149429e3dcedad5bb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [categoryWithCrypts].
@ProviderFor(categoryWithCrypts)
const categoryWithCryptsProvider = CategoryWithCryptsFamily();

/// See also [categoryWithCrypts].
class CategoryWithCryptsFamily extends Family<AsyncValue<CategoryWithCrypts>> {
  /// See also [categoryWithCrypts].
  const CategoryWithCryptsFamily();

  /// See also [categoryWithCrypts].
  CategoryWithCryptsProvider call(String categoryId) {
    return CategoryWithCryptsProvider(categoryId);
  }

  @override
  CategoryWithCryptsProvider getProviderOverride(
    covariant CategoryWithCryptsProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryWithCryptsProvider';
}

/// See also [categoryWithCrypts].
class CategoryWithCryptsProvider
    extends AutoDisposeFutureProvider<CategoryWithCrypts> {
  /// See also [categoryWithCrypts].
  CategoryWithCryptsProvider(String categoryId)
    : this._internal(
        (ref) => categoryWithCrypts(ref as CategoryWithCryptsRef, categoryId),
        from: categoryWithCryptsProvider,
        name: r'categoryWithCryptsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryWithCryptsHash,
        dependencies: CategoryWithCryptsFamily._dependencies,
        allTransitiveDependencies:
            CategoryWithCryptsFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  CategoryWithCryptsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<CategoryWithCrypts> Function(CategoryWithCryptsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryWithCryptsProvider._internal(
        (ref) => create(ref as CategoryWithCryptsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CategoryWithCrypts> createElement() {
    return _CategoryWithCryptsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryWithCryptsProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryWithCryptsRef
    on AutoDisposeFutureProviderRef<CategoryWithCrypts> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryWithCryptsProviderElement
    extends AutoDisposeFutureProviderElement<CategoryWithCrypts>
    with CategoryWithCryptsRef {
  _CategoryWithCryptsProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryWithCryptsProvider).categoryId;
}

String _$categoryCryptCountHash() =>
    r'dec08de9f8fab4e155dea8497875731ed0d7a570';

/// See also [categoryCryptCount].
@ProviderFor(categoryCryptCount)
const categoryCryptCountProvider = CategoryCryptCountFamily();

/// See also [categoryCryptCount].
class CategoryCryptCountFamily extends Family<AsyncValue<int>> {
  /// See also [categoryCryptCount].
  const CategoryCryptCountFamily();

  /// See also [categoryCryptCount].
  CategoryCryptCountProvider call(String categoryId) {
    return CategoryCryptCountProvider(categoryId);
  }

  @override
  CategoryCryptCountProvider getProviderOverride(
    covariant CategoryCryptCountProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryCryptCountProvider';
}

/// See also [categoryCryptCount].
class CategoryCryptCountProvider extends AutoDisposeFutureProvider<int> {
  /// See also [categoryCryptCount].
  CategoryCryptCountProvider(String categoryId)
    : this._internal(
        (ref) => categoryCryptCount(ref as CategoryCryptCountRef, categoryId),
        from: categoryCryptCountProvider,
        name: r'categoryCryptCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryCryptCountHash,
        dependencies: CategoryCryptCountFamily._dependencies,
        allTransitiveDependencies:
            CategoryCryptCountFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  CategoryCryptCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<int> Function(CategoryCryptCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryCryptCountProvider._internal(
        (ref) => create(ref as CategoryCryptCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _CategoryCryptCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryCryptCountProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryCryptCountRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryCryptCountProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with CategoryCryptCountRef {
  _CategoryCryptCountProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryCryptCountProvider).categoryId;
}

String _$categoriesNotifierHash() =>
    r'5852d0a977475bce95f7be5f12c1d127a3da9e4c';

/// See also [CategoriesNotifier].
@ProviderFor(CategoriesNotifier)
final categoriesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      CategoriesNotifier,
      List<CryptCategory>
    >.internal(
      CategoriesNotifier.new,
      name: r'categoriesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CategoriesNotifier = AutoDisposeAsyncNotifier<List<CryptCategory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
