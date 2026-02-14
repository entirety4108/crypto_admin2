// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_balance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyBalanceRepositoryHash() =>
    r'7d3cc0ce75a74fa98e422fba104432a925b35df2';

/// See also [dailyBalanceRepository].
@ProviderFor(dailyBalanceRepository)
final dailyBalanceRepositoryProvider =
    AutoDisposeProvider<DailyBalanceRepository>.internal(
      dailyBalanceRepository,
      name: r'dailyBalanceRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyBalanceRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyBalanceRepositoryRef =
    AutoDisposeProviderRef<DailyBalanceRepository>;
String _$dailyBalancesHash() => r'3fab5d13f068cba3d5805db95eaaf9f62ab0d6a2';

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

/// See also [dailyBalances].
@ProviderFor(dailyBalances)
const dailyBalancesProvider = DailyBalancesFamily();

/// See also [dailyBalances].
class DailyBalancesFamily extends Family<AsyncValue<List<DailyBalance>>> {
  /// See also [dailyBalances].
  const DailyBalancesFamily();

  /// See also [dailyBalances].
  DailyBalancesProvider call({
    String? cryptId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DailyBalancesProvider(
      cryptId: cryptId,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  DailyBalancesProvider getProviderOverride(
    covariant DailyBalancesProvider provider,
  ) {
    return call(
      cryptId: provider.cryptId,
      accountId: provider.accountId,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyBalancesProvider';
}

/// See also [dailyBalances].
class DailyBalancesProvider
    extends AutoDisposeFutureProvider<List<DailyBalance>> {
  /// See also [dailyBalances].
  DailyBalancesProvider({
    String? cryptId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
         (ref) => dailyBalances(
           ref as DailyBalancesRef,
           cryptId: cryptId,
           accountId: accountId,
           startDate: startDate,
           endDate: endDate,
         ),
         from: dailyBalancesProvider,
         name: r'dailyBalancesProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$dailyBalancesHash,
         dependencies: DailyBalancesFamily._dependencies,
         allTransitiveDependencies:
             DailyBalancesFamily._allTransitiveDependencies,
         cryptId: cryptId,
         accountId: accountId,
         startDate: startDate,
         endDate: endDate,
       );

  DailyBalancesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cryptId,
    required this.accountId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String? cryptId;
  final String? accountId;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    FutureOr<List<DailyBalance>> Function(DailyBalancesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyBalancesProvider._internal(
        (ref) => create(ref as DailyBalancesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cryptId: cryptId,
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DailyBalance>> createElement() {
    return _DailyBalancesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyBalancesProvider &&
        other.cryptId == cryptId &&
        other.accountId == accountId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cryptId.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyBalancesRef on AutoDisposeFutureProviderRef<List<DailyBalance>> {
  /// The parameter `cryptId` of this provider.
  String? get cryptId;

  /// The parameter `accountId` of this provider.
  String? get accountId;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _DailyBalancesProviderElement
    extends AutoDisposeFutureProviderElement<List<DailyBalance>>
    with DailyBalancesRef {
  _DailyBalancesProviderElement(super.provider);

  @override
  String? get cryptId => (origin as DailyBalancesProvider).cryptId;
  @override
  String? get accountId => (origin as DailyBalancesProvider).accountId;
  @override
  DateTime? get startDate => (origin as DailyBalancesProvider).startDate;
  @override
  DateTime? get endDate => (origin as DailyBalancesProvider).endDate;
}

String _$aggregatedBalancesHash() =>
    r'9c2201ee0eedabb93c88a77e068c8e85db78d311';

/// See also [aggregatedBalances].
@ProviderFor(aggregatedBalances)
const aggregatedBalancesProvider = AggregatedBalancesFamily();

/// See also [aggregatedBalances].
class AggregatedBalancesFamily
    extends Family<AsyncValue<Map<DateTime, double>>> {
  /// See also [aggregatedBalances].
  const AggregatedBalancesFamily();

  /// See also [aggregatedBalances].
  AggregatedBalancesProvider call({
    String? cryptId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AggregatedBalancesProvider(
      cryptId: cryptId,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  AggregatedBalancesProvider getProviderOverride(
    covariant AggregatedBalancesProvider provider,
  ) {
    return call(
      cryptId: provider.cryptId,
      accountId: provider.accountId,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'aggregatedBalancesProvider';
}

/// See also [aggregatedBalances].
class AggregatedBalancesProvider
    extends AutoDisposeFutureProvider<Map<DateTime, double>> {
  /// See also [aggregatedBalances].
  AggregatedBalancesProvider({
    String? cryptId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
         (ref) => aggregatedBalances(
           ref as AggregatedBalancesRef,
           cryptId: cryptId,
           accountId: accountId,
           startDate: startDate,
           endDate: endDate,
         ),
         from: aggregatedBalancesProvider,
         name: r'aggregatedBalancesProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$aggregatedBalancesHash,
         dependencies: AggregatedBalancesFamily._dependencies,
         allTransitiveDependencies:
             AggregatedBalancesFamily._allTransitiveDependencies,
         cryptId: cryptId,
         accountId: accountId,
         startDate: startDate,
         endDate: endDate,
       );

  AggregatedBalancesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cryptId,
    required this.accountId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String? cryptId;
  final String? accountId;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    FutureOr<Map<DateTime, double>> Function(AggregatedBalancesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AggregatedBalancesProvider._internal(
        (ref) => create(ref as AggregatedBalancesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cryptId: cryptId,
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<DateTime, double>> createElement() {
    return _AggregatedBalancesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AggregatedBalancesProvider &&
        other.cryptId == cryptId &&
        other.accountId == accountId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cryptId.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AggregatedBalancesRef
    on AutoDisposeFutureProviderRef<Map<DateTime, double>> {
  /// The parameter `cryptId` of this provider.
  String? get cryptId;

  /// The parameter `accountId` of this provider.
  String? get accountId;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _AggregatedBalancesProviderElement
    extends AutoDisposeFutureProviderElement<Map<DateTime, double>>
    with AggregatedBalancesRef {
  _AggregatedBalancesProviderElement(super.provider);

  @override
  String? get cryptId => (origin as AggregatedBalancesProvider).cryptId;
  @override
  String? get accountId => (origin as AggregatedBalancesProvider).accountId;
  @override
  DateTime? get startDate => (origin as AggregatedBalancesProvider).startDate;
  @override
  DateTime? get endDate => (origin as AggregatedBalancesProvider).endDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
