// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$purchaseRepositoryHash() =>
    r'd93c14972c540cd0fc8d93959a5f6ce808649397';

/// See also [purchaseRepository].
@ProviderFor(purchaseRepository)
final purchaseRepositoryProvider =
    AutoDisposeProvider<PurchaseRepository>.internal(
      purchaseRepository,
      name: r'purchaseRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$purchaseRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PurchaseRepositoryRef = AutoDisposeProviderRef<PurchaseRepository>;
String _$cryptRepositoryHash() => r'6bbe5ecb61ccb9ab4984bc320199166bcb64582e';

/// See also [cryptRepository].
@ProviderFor(cryptRepository)
final cryptRepositoryProvider = AutoDisposeProvider<CryptRepository>.internal(
  cryptRepository,
  name: r'cryptRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cryptRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CryptRepositoryRef = AutoDisposeProviderRef<CryptRepository>;
String _$cryptsListHash() => r'8b38bf8735ec1f86c13a80b411e8498f62b5fc1e';

/// See also [cryptsList].
@ProviderFor(cryptsList)
final cryptsListProvider = AutoDisposeFutureProvider<List<Crypt>>.internal(
  cryptsList,
  name: r'cryptsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cryptsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CryptsListRef = AutoDisposeFutureProviderRef<List<Crypt>>;
String _$purchasesNotifierHash() => r'4414976847a6836fa99200b6b2f3e82c2bd7613e';

/// See also [PurchasesNotifier].
@ProviderFor(PurchasesNotifier)
final purchasesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      PurchasesNotifier,
      List<Purchase>
    >.internal(
      PurchasesNotifier.new,
      name: r'purchasesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$purchasesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PurchasesNotifier = AutoDisposeAsyncNotifier<List<Purchase>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
