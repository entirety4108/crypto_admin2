// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transferRepositoryHash() =>
    r'dca683b539c36b96473fbda0878dcc0573874185';

/// See also [transferRepository].
@ProviderFor(transferRepository)
final transferRepositoryProvider =
    AutoDisposeProvider<TransferRepository>.internal(
      transferRepository,
      name: r'transferRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transferRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransferRepositoryRef = AutoDisposeProviderRef<TransferRepository>;
String _$transfersNotifierHash() => r'a9908b5ff24a6197cfe8c3d6fcd1ac3dfab4f683';

/// See also [TransfersNotifier].
@ProviderFor(TransfersNotifier)
final transfersNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      TransfersNotifier,
      List<Transfer>
    >.internal(
      TransfersNotifier.new,
      name: r'transfersNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transfersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TransfersNotifier = AutoDisposeAsyncNotifier<List<Transfer>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
