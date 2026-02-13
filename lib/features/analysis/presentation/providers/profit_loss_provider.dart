import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/profit_loss_repository.dart';
import '../../domain/profit_loss_summary.dart';
import '../../domain/crypt_profit_loss.dart';
import '../../domain/account_profit_loss.dart';

part 'profit_loss_provider.g.dart';

@riverpod
ProfitLossRepository profitLossRepository(ProfitLossRepositoryRef ref) {
  return ProfitLossRepository(Supabase.instance.client);
}

@riverpod
Future<ProfitLossSummary> profitLossSummary(
  ProfitLossSummaryRef ref,
  int? year,
) async {
  final repository = ref.watch(profitLossRepositoryProvider);
  return repository.getProfitLossSummary(year: year);
}

@riverpod
Future<List<CryptProfitLoss>> cryptProfitLossList(
  CryptProfitLossListRef ref,
  int? year,
) async {
  final repository = ref.watch(profitLossRepositoryProvider);
  return repository.getCryptProfitLossList(year: year);
}

@riverpod
Future<List<AccountProfitLoss>> accountProfitLossList(
  AccountProfitLossListRef ref,
  int? year,
) async {
  final repository = ref.watch(profitLossRepositoryProvider);
  return repository.getAccountProfitLossList(year: year);
}
