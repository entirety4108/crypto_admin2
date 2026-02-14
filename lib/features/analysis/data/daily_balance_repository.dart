import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/daily_balance.dart';

class DailyBalanceRepository {
  final SupabaseClient _supabase;

  DailyBalanceRepository(this._supabase);

  /// Get daily balances with optional filters
  Future<List<DailyBalance>> getDailyBalances({
    String? cryptId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    var query = _supabase
        .from('daily_balances')
        .select()
        .eq('user_id', userId);

    if (cryptId != null) {
      query = query.eq('crypt_id', cryptId);
    }

    if (accountId != null) {
      query = query.eq('account_id', accountId);
    }

    if (startDate != null) {
      query = query.gte('date', startDate.toIso8601String().split('T')[0]);
    }

    if (endDate != null) {
      query = query.lte('date', endDate.toIso8601String().split('T')[0]);
    }

    final data = await query.order('date', ascending: true) as List<dynamic>;

    return data
        .map((json) => DailyBalance.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get aggregated daily balances (sum by date and crypt)
  Future<Map<DateTime, double>> getAggregatedBalances({
    String? cryptId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final balances = await getDailyBalances(
      cryptId: cryptId,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
    );

    final aggregated = <DateTime, double>{};

    for (final balance in balances) {
      final date = DateTime(balance.date.year, balance.date.month, balance.date.day);
      aggregated[date] = (aggregated[date] ?? 0.0) + balance.valuation;
    }

    return aggregated;
  }

  /// Trigger daily balance update (call Edge Function)
  Future<void> triggerUpdate() async {
    final response = await _supabase.functions.invoke('update-daily-balances');

    if (response.status != 200) {
      throw Exception('Failed to trigger balance update: ${response.data}');
    }
  }
}
