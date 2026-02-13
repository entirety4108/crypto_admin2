import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/portfolio_repository.dart';
import '../../domain/portfolio_summary.dart';
import '../../domain/crypt_holding.dart';
import '../../domain/account_holding.dart';

part 'portfolio_provider.g.dart';

/// Portfolio repository provider
@riverpod
PortfolioRepository portfolioRepository(PortfolioRepositoryRef ref) {
  return PortfolioRepository();
}

/// Portfolio summary provider
@riverpod
Future<PortfolioSummary> portfolioSummary(PortfolioSummaryRef ref) async {
  final repository = ref.watch(portfolioRepositoryProvider);
  return repository.getPortfolioSummary();
}

/// Crypto holdings provider
@riverpod
Future<List<CryptHolding>> cryptHoldings(CryptHoldingsRef ref) async {
  final repository = ref.watch(portfolioRepositoryProvider);
  return repository.getCryptHoldings();
}

/// Account holdings provider
@riverpod
Future<List<AccountHolding>> accountHoldings(AccountHoldingsRef ref) async {
  final repository = ref.watch(portfolioRepositoryProvider);
  return repository.getAccountHoldings();
}
