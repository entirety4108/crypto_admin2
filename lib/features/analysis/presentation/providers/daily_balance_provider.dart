import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/daily_balance_repository.dart';
import '../../domain/daily_balance.dart';

part 'daily_balance_provider.g.dart';

@riverpod
DailyBalanceRepository dailyBalanceRepository(DailyBalanceRepositoryRef ref) {
  return DailyBalanceRepository(Supabase.instance.client);
}

@riverpod
Future<List<DailyBalance>> dailyBalances(
  DailyBalancesRef ref, {
  String? cryptId,
  String? accountId,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final repository = ref.watch(dailyBalanceRepositoryProvider);
  return repository.getDailyBalances(
    cryptId: cryptId,
    accountId: accountId,
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Future<Map<DateTime, double>> aggregatedBalances(
  AggregatedBalancesRef ref, {
  String? cryptId,
  String? accountId,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final repository = ref.watch(dailyBalanceRepositoryProvider);
  return repository.getAggregatedBalances(
    cryptId: cryptId,
    accountId: accountId,
    startDate: startDate,
    endDate: endDate,
  );
}
