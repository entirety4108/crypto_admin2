// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sell_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sellRepositoryHash() => r'76d2d037e8b7e69cfd416efbac101f11315aa5a7';

/// See also [sellRepository].
@ProviderFor(sellRepository)
final sellRepositoryProvider = AutoDisposeProvider<SellRepository>.internal(
  sellRepository,
  name: r'sellRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sellRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SellRepositoryRef = AutoDisposeProviderRef<SellRepository>;
String _$sellsNotifierHash() => r'f021686256a73104754114fc6746e2c9748b693d';

/// See also [SellsNotifier].
@ProviderFor(SellsNotifier)
final sellsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SellsNotifier, List<Sell>>.internal(
      SellsNotifier.new,
      name: r'sellsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sellsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SellsNotifier = AutoDisposeAsyncNotifier<List<Sell>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
