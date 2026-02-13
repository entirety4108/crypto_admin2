// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airdrop_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$airdropRepositoryHash() => r'fc2fce5693b2c9e042db61832652b7a501408e4e';

/// See also [airdropRepository].
@ProviderFor(airdropRepository)
final airdropRepositoryProvider =
    AutoDisposeProvider<AirdropRepository>.internal(
      airdropRepository,
      name: r'airdropRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$airdropRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AirdropRepositoryRef = AutoDisposeProviderRef<AirdropRepository>;
String _$airdropsNotifierHash() => r'974d21cbe8b042937eae562645f8976e01157710';

/// See also [AirdropsNotifier].
@ProviderFor(AirdropsNotifier)
final airdropsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AirdropsNotifier, List<Purchase>>.internal(
      AirdropsNotifier.new,
      name: r'airdropsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$airdropsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AirdropsNotifier = AutoDisposeAsyncNotifier<List<Purchase>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
