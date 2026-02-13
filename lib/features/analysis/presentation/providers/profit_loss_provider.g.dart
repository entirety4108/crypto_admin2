// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_loss_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profitLossRepositoryHash() =>
    r'f2d31dd6d30fc48645a1c64ba0a993be4cbb682a';

/// See also [profitLossRepository].
@ProviderFor(profitLossRepository)
final profitLossRepositoryProvider =
    AutoDisposeProvider<ProfitLossRepository>.internal(
      profitLossRepository,
      name: r'profitLossRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profitLossRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfitLossRepositoryRef = AutoDisposeProviderRef<ProfitLossRepository>;
String _$profitLossSummaryHash() => r'def9c5d58fcb86152934c19783f3ca5803d30039';

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

/// See also [profitLossSummary].
@ProviderFor(profitLossSummary)
const profitLossSummaryProvider = ProfitLossSummaryFamily();

/// See also [profitLossSummary].
class ProfitLossSummaryFamily extends Family<AsyncValue<ProfitLossSummary>> {
  /// See also [profitLossSummary].
  const ProfitLossSummaryFamily();

  /// See also [profitLossSummary].
  ProfitLossSummaryProvider call(int? year) {
    return ProfitLossSummaryProvider(year);
  }

  @override
  ProfitLossSummaryProvider getProviderOverride(
    covariant ProfitLossSummaryProvider provider,
  ) {
    return call(provider.year);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'profitLossSummaryProvider';
}

/// See also [profitLossSummary].
class ProfitLossSummaryProvider
    extends AutoDisposeFutureProvider<ProfitLossSummary> {
  /// See also [profitLossSummary].
  ProfitLossSummaryProvider(int? year)
    : this._internal(
        (ref) => profitLossSummary(ref as ProfitLossSummaryRef, year),
        from: profitLossSummaryProvider,
        name: r'profitLossSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$profitLossSummaryHash,
        dependencies: ProfitLossSummaryFamily._dependencies,
        allTransitiveDependencies:
            ProfitLossSummaryFamily._allTransitiveDependencies,
        year: year,
      );

  ProfitLossSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
  }) : super.internal();

  final int? year;

  @override
  Override overrideWith(
    FutureOr<ProfitLossSummary> Function(ProfitLossSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProfitLossSummaryProvider._internal(
        (ref) => create(ref as ProfitLossSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProfitLossSummary> createElement() {
    return _ProfitLossSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfitLossSummaryProvider && other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProfitLossSummaryRef on AutoDisposeFutureProviderRef<ProfitLossSummary> {
  /// The parameter `year` of this provider.
  int? get year;
}

class _ProfitLossSummaryProviderElement
    extends AutoDisposeFutureProviderElement<ProfitLossSummary>
    with ProfitLossSummaryRef {
  _ProfitLossSummaryProviderElement(super.provider);

  @override
  int? get year => (origin as ProfitLossSummaryProvider).year;
}

String _$cryptProfitLossListHash() =>
    r'be16a284b164520365b24c98bdb7b2b92935d1a8';

/// See also [cryptProfitLossList].
@ProviderFor(cryptProfitLossList)
const cryptProfitLossListProvider = CryptProfitLossListFamily();

/// See also [cryptProfitLossList].
class CryptProfitLossListFamily
    extends Family<AsyncValue<List<CryptProfitLoss>>> {
  /// See also [cryptProfitLossList].
  const CryptProfitLossListFamily();

  /// See also [cryptProfitLossList].
  CryptProfitLossListProvider call(int? year) {
    return CryptProfitLossListProvider(year);
  }

  @override
  CryptProfitLossListProvider getProviderOverride(
    covariant CryptProfitLossListProvider provider,
  ) {
    return call(provider.year);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cryptProfitLossListProvider';
}

/// See also [cryptProfitLossList].
class CryptProfitLossListProvider
    extends AutoDisposeFutureProvider<List<CryptProfitLoss>> {
  /// See also [cryptProfitLossList].
  CryptProfitLossListProvider(int? year)
    : this._internal(
        (ref) => cryptProfitLossList(ref as CryptProfitLossListRef, year),
        from: cryptProfitLossListProvider,
        name: r'cryptProfitLossListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$cryptProfitLossListHash,
        dependencies: CryptProfitLossListFamily._dependencies,
        allTransitiveDependencies:
            CryptProfitLossListFamily._allTransitiveDependencies,
        year: year,
      );

  CryptProfitLossListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
  }) : super.internal();

  final int? year;

  @override
  Override overrideWith(
    FutureOr<List<CryptProfitLoss>> Function(CryptProfitLossListRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CryptProfitLossListProvider._internal(
        (ref) => create(ref as CryptProfitLossListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CryptProfitLoss>> createElement() {
    return _CryptProfitLossListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CryptProfitLossListProvider && other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CryptProfitLossListRef
    on AutoDisposeFutureProviderRef<List<CryptProfitLoss>> {
  /// The parameter `year` of this provider.
  int? get year;
}

class _CryptProfitLossListProviderElement
    extends AutoDisposeFutureProviderElement<List<CryptProfitLoss>>
    with CryptProfitLossListRef {
  _CryptProfitLossListProviderElement(super.provider);

  @override
  int? get year => (origin as CryptProfitLossListProvider).year;
}

String _$accountProfitLossListHash() =>
    r'b4ac95b62372f2d856dbffe06cc7121a2567640c';

/// See also [accountProfitLossList].
@ProviderFor(accountProfitLossList)
const accountProfitLossListProvider = AccountProfitLossListFamily();

/// See also [accountProfitLossList].
class AccountProfitLossListFamily
    extends Family<AsyncValue<List<AccountProfitLoss>>> {
  /// See also [accountProfitLossList].
  const AccountProfitLossListFamily();

  /// See also [accountProfitLossList].
  AccountProfitLossListProvider call(int? year) {
    return AccountProfitLossListProvider(year);
  }

  @override
  AccountProfitLossListProvider getProviderOverride(
    covariant AccountProfitLossListProvider provider,
  ) {
    return call(provider.year);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountProfitLossListProvider';
}

/// See also [accountProfitLossList].
class AccountProfitLossListProvider
    extends AutoDisposeFutureProvider<List<AccountProfitLoss>> {
  /// See also [accountProfitLossList].
  AccountProfitLossListProvider(int? year)
    : this._internal(
        (ref) => accountProfitLossList(ref as AccountProfitLossListRef, year),
        from: accountProfitLossListProvider,
        name: r'accountProfitLossListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$accountProfitLossListHash,
        dependencies: AccountProfitLossListFamily._dependencies,
        allTransitiveDependencies:
            AccountProfitLossListFamily._allTransitiveDependencies,
        year: year,
      );

  AccountProfitLossListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
  }) : super.internal();

  final int? year;

  @override
  Override overrideWith(
    FutureOr<List<AccountProfitLoss>> Function(
      AccountProfitLossListRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountProfitLossListProvider._internal(
        (ref) => create(ref as AccountProfitLossListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AccountProfitLoss>> createElement() {
    return _AccountProfitLossListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountProfitLossListProvider && other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountProfitLossListRef
    on AutoDisposeFutureProviderRef<List<AccountProfitLoss>> {
  /// The parameter `year` of this provider.
  int? get year;
}

class _AccountProfitLossListProviderElement
    extends AutoDisposeFutureProviderElement<List<AccountProfitLoss>>
    with AccountProfitLossListRef {
  _AccountProfitLossListProviderElement(super.provider);

  @override
  int? get year => (origin as AccountProfitLossListProvider).year;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
