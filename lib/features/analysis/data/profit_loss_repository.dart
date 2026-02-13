import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/profit_loss_summary.dart';
import '../domain/crypt_profit_loss.dart';
import '../domain/account_profit_loss.dart';

class ProfitLossRepository {
  final SupabaseClient _supabase;

  ProfitLossRepository(this._supabase);

  /// Get overall profit/loss summary
  Future<ProfitLossSummary> getProfitLossSummary({int? year}) async {
    final results = await Future.wait([
      _getRealized(year: year),
      _getUnrealized(),
    ]);

    final realizedPnl = results[0];
    final unrealizedPnl = results[1];

    return ProfitLossSummary(
      totalRealizedPnl: realizedPnl,
      totalUnrealizedPnl: unrealizedPnl,
      totalPnl: realizedPnl + unrealizedPnl,
      year: year,
    );
  }

  /// Get profit/loss by cryptocurrency
  Future<List<CryptProfitLoss>> getCryptProfitLossList({int? year}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Get realized P&L by crypt
    final realizedQuery = _supabase
        .from('sells')
        .select('crypt_id, profit')
        .eq('user_id', userId);

    if (year != null) {
      final startDate = DateTime(year, 1, 1).toIso8601String();
      final endDate = DateTime(year, 12, 31, 23, 59, 59).toIso8601String();
      realizedQuery
          .gte('exec_at', startDate)
          .lte('exec_at', endDate);
    }

    final realizedData = await realizedQuery as List<dynamic>;

    // Group by crypt_id and sum profit
    final realizedMap = <String, double>{};
    for (final row in realizedData) {
      final cryptId = row['crypt_id'] as String;
      final profit = (row['profit'] as num?)?.toDouble() ?? 0.0;
      realizedMap[cryptId] = (realizedMap[cryptId] ?? 0.0) + profit;
    }

    // Get unrealized P&L by crypt (current holdings)
    final unrealizedMap = await _getUnrealizedByCrypt();

    // Get crypt details
    final cryptIds = {...realizedMap.keys, ...unrealizedMap.keys};
    if (cryptIds.isEmpty) return [];

    final cryptsData = await _supabase
        .from('crypts')
        .select('id, symbol, icon_url')
        .filter('id', 'in', '(${cryptIds.join(',')})');

    final cryptsMap = <String, Map<String, dynamic>>{};
    for (final row in cryptsData as List<dynamic>) {
      cryptsMap[row['id'] as String] = row as Map<String, dynamic>;
    }

    // Combine results
    final results = <CryptProfitLoss>[];
    for (final cryptId in cryptIds) {
      final crypt = cryptsMap[cryptId];
      if (crypt == null) continue;

      final realized = realizedMap[cryptId] ?? 0.0;
      final unrealized = unrealizedMap[cryptId] ?? 0.0;

      results.add(CryptProfitLoss(
        cryptId: cryptId,
        symbol: crypt['symbol'] as String,
        iconUrl: crypt['icon_url'] as String?,
        realizedPnl: realized,
        unrealizedPnl: unrealized,
        totalPnl: realized + unrealized,
      ));
    }

    return results;
  }

  /// Get profit/loss by account
  Future<List<AccountProfitLoss>> getAccountProfitLossList({int? year}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Get realized P&L by account
    final realizedQuery = _supabase
        .from('sells')
        .select('account_id, profit')
        .eq('user_id', userId);

    if (year != null) {
      final startDate = DateTime(year, 1, 1).toIso8601String();
      final endDate = DateTime(year, 12, 31, 23, 59, 59).toIso8601String();
      realizedQuery
          .gte('exec_at', startDate)
          .lte('exec_at', endDate);
    }

    final realizedData = await realizedQuery as List<dynamic>;

    // Group by account_id and sum profit
    final realizedMap = <String, double>{};
    for (final row in realizedData) {
      final accountId = row['account_id'] as String;
      final profit = (row['profit'] as num?)?.toDouble() ?? 0.0;
      realizedMap[accountId] = (realizedMap[accountId] ?? 0.0) + profit;
    }

    // Get unrealized P&L by account (current holdings)
    final unrealizedMap = await _getUnrealizedByAccount();

    // Get account details
    final accountIds = {...realizedMap.keys, ...unrealizedMap.keys};
    if (accountIds.isEmpty) return [];

    final accountsData = await _supabase
        .from('accounts')
        .select('id, name')
        .filter('id', 'in', '(${accountIds.join(',')})');

    final accountsMap = <String, Map<String, dynamic>>{};
    for (final row in accountsData as List<dynamic>) {
      accountsMap[row['id'] as String] = row as Map<String, dynamic>;
    }

    // Combine results
    final results = <AccountProfitLoss>[];
    for (final accountId in accountIds) {
      final account = accountsMap[accountId];
      if (account == null) continue;

      final realized = realizedMap[accountId] ?? 0.0;
      final unrealized = unrealizedMap[accountId] ?? 0.0;

      results.add(AccountProfitLoss(
        accountId: accountId,
        name: account['name'] as String,
        realizedPnl: realized,
        unrealizedPnl: unrealized,
        totalPnl: realized + unrealized,
      ));
    }

    return results;
  }

  /// Get total realized P&L
  Future<double> _getRealized({int? year}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final query = _supabase
        .from('sells')
        .select('profit')
        .eq('user_id', userId);

    if (year != null) {
      final startDate = DateTime(year, 1, 1).toIso8601String();
      final endDate = DateTime(year, 12, 31, 23, 59, 59).toIso8601String();
      query.gte('exec_at', startDate).lte('exec_at', endDate);
    }

    final data = await query as List<dynamic>;

    double total = 0.0;
    for (final row in data) {
      final profit = (row['profit'] as num?)?.toDouble() ?? 0.0;
      total += profit;
    }

    return total;
  }

  /// Get total unrealized P&L
  Future<double> _getUnrealized() async {
    final Map<String, double> byCrypt = await _getUnrealizedByCrypt();
    return byCrypt.values.fold<double>(0.0, (sum, value) => sum + value);
  }

  /// Get unrealized P&L by crypt
  Future<Map<String, double>> _getUnrealizedByCrypt() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Get current holdings from portfolio view or calculate manually
    // For now, use simplified calculation: purchases - sells - transfers
    final purchases = await _supabase
        .from('purchases')
        .select('crypt_id, amount, purchase_yen, deposit_yen')
        .eq('user_id', userId) as List<dynamic>;

    final sells = await _supabase
        .from('sells')
        .select('crypt_id, amount')
        .eq('user_id', userId) as List<dynamic>;

    // Calculate holdings
    final holdings = <String, double>{};
    final costBasis = <String, double>{};

    for (final row in purchases) {
      final cryptId = row['crypt_id'] as String;
      final amount = (row['amount'] as num).toDouble();
      final cost = (row['purchase_yen'] as num?)?.toDouble() ??
          (row['deposit_yen'] as num?)?.toDouble() ??
          0.0;
      holdings[cryptId] = (holdings[cryptId] ?? 0.0) + amount;
      costBasis[cryptId] = (costBasis[cryptId] ?? 0.0) + cost;
    }

    for (final row in sells) {
      final cryptId = row['crypt_id'] as String;
      final amount = (row['amount'] as num).toDouble();
      holdings[cryptId] = (holdings[cryptId] ?? 0.0) - amount;
    }

    // Get latest prices
    final pricesData = await _supabase
        .from('prices')
        .select('crypt_id, price_jpy')
        .order('fetched_at', ascending: false)
        .limit(100) as List<dynamic>;

    final latestPrices = <String, double>{};
    for (final row in pricesData) {
      final cryptId = row['crypt_id'] as String;
      if (!latestPrices.containsKey(cryptId)) {
        latestPrices[cryptId] = (row['price_jpy'] as num).toDouble();
      }
    }

    // Calculate unrealized P&L
    final unrealized = <String, double>{};
    for (final cryptId in holdings.keys) {
      final qty = holdings[cryptId] ?? 0.0;
      if (qty <= 0) continue;

      final price = latestPrices[cryptId] ?? 0.0;
      final cost = costBasis[cryptId] ?? 0.0;
      final currentValue = qty * price;
      unrealized[cryptId] = currentValue - cost;
    }

    return unrealized;
  }

  /// Get unrealized P&L by account
  Future<Map<String, double>> _getUnrealizedByAccount() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Calculate holdings per account
    final purchases = await _supabase
        .from('purchases')
        .select('account_id, crypt_id, amount, purchase_yen, deposit_yen')
        .eq('user_id', userId) as List<dynamic>;

    final sells = await _supabase
        .from('sells')
        .select('account_id, crypt_id, amount')
        .eq('user_id', userId) as List<dynamic>;

    // Holdings per account+crypt
    final holdings = <String, Map<String, double>>{};
    final costBasis = <String, Map<String, double>>{};

    for (final row in purchases) {
      final accountId = row['account_id'] as String;
      final cryptId = row['crypt_id'] as String;
      final amount = (row['amount'] as num).toDouble();
      final cost = (row['purchase_yen'] as num?)?.toDouble() ??
          (row['deposit_yen'] as num?)?.toDouble() ??
          0.0;

      holdings[accountId] ??= {};
      costBasis[accountId] ??= {};
      holdings[accountId]![cryptId] =
          (holdings[accountId]![cryptId] ?? 0.0) + amount;
      costBasis[accountId]![cryptId] =
          (costBasis[accountId]![cryptId] ?? 0.0) + cost;
    }

    for (final row in sells) {
      final accountId = row['account_id'] as String;
      final cryptId = row['crypt_id'] as String;
      final amount = (row['amount'] as num).toDouble();

      holdings[accountId] ??= {};
      holdings[accountId]![cryptId] =
          (holdings[accountId]![cryptId] ?? 0.0) - amount;
    }

    // Get latest prices
    final pricesData = await _supabase
        .from('prices')
        .select('crypt_id, price_jpy')
        .order('fetched_at', ascending: false)
        .limit(100) as List<dynamic>;

    final latestPrices = <String, double>{};
    for (final row in pricesData) {
      final cryptId = row['crypt_id'] as String;
      if (!latestPrices.containsKey(cryptId)) {
        latestPrices[cryptId] = (row['price_jpy'] as num).toDouble();
      }
    }

    // Calculate unrealized P&L per account
    final unrealized = <String, double>{};
    for (final accountId in holdings.keys) {
      double accountTotal = 0.0;
      for (final cryptId in holdings[accountId]!.keys) {
        final qty = holdings[accountId]![cryptId] ?? 0.0;
        if (qty <= 0) continue;

        final price = latestPrices[cryptId] ?? 0.0;
        final cost = costBasis[accountId]?[cryptId] ?? 0.0;
        final currentValue = qty * price;
        accountTotal += currentValue - cost;
      }
      unrealized[accountId] = accountTotal;
    }

    return unrealized;
  }
}
