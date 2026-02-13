// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$portfolioRepositoryHash() =>
    r'35ef4a2d46a16d7d1ac7e950f1bef6a1cdfc6c16';

/// Portfolio repository provider
///
/// Copied from [portfolioRepository].
@ProviderFor(portfolioRepository)
final portfolioRepositoryProvider =
    AutoDisposeProvider<PortfolioRepository>.internal(
      portfolioRepository,
      name: r'portfolioRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$portfolioRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PortfolioRepositoryRef = AutoDisposeProviderRef<PortfolioRepository>;
String _$portfolioSummaryHash() => r'e222f3455341e0cb6371c2046d33cfc6c8a58683';

/// Portfolio summary provider
///
/// Copied from [portfolioSummary].
@ProviderFor(portfolioSummary)
final portfolioSummaryProvider =
    AutoDisposeFutureProvider<PortfolioSummary>.internal(
      portfolioSummary,
      name: r'portfolioSummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$portfolioSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PortfolioSummaryRef = AutoDisposeFutureProviderRef<PortfolioSummary>;
String _$cryptHoldingsHash() => r'89abd5ed7da4cf992c7233c29d1146498935a67d';

/// Crypto holdings provider
///
/// Copied from [cryptHoldings].
@ProviderFor(cryptHoldings)
final cryptHoldingsProvider =
    AutoDisposeFutureProvider<List<CryptHolding>>.internal(
      cryptHoldings,
      name: r'cryptHoldingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cryptHoldingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CryptHoldingsRef = AutoDisposeFutureProviderRef<List<CryptHolding>>;
String _$accountHoldingsHash() => r'a32d75ebc5cf16d43448f6618e860aecee364774';

/// Account holdings provider
///
/// Copied from [accountHoldings].
@ProviderFor(accountHoldings)
final accountHoldingsProvider =
    AutoDisposeFutureProvider<List<AccountHolding>>.internal(
      accountHoldings,
      name: r'accountHoldingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountHoldingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountHoldingsRef = AutoDisposeFutureProviderRef<List<AccountHolding>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
