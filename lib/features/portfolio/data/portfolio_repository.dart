import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/portfolio_summary.dart';
import '../domain/crypt_holding.dart';
import '../domain/account_holding.dart';

class PortfolioRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Get portfolio summary with total value and P&L
  Future<PortfolioSummary> getPortfolioSummary() async {
    try {
      final holdings = await getCryptHoldings();

      double totalValue = 0.0;
      double totalCostBasis = 0.0;

      for (final holding in holdings) {
        totalValue += holding.valueJpy;
        totalCostBasis += holding.avgCostBasisJpy * holding.amount;
      }

      final totalProfitLoss = totalValue - totalCostBasis;
      final profitLossPercentage =
          totalCostBasis > 0 ? (totalProfitLoss / totalCostBasis) * 100 : 0.0;

      return PortfolioSummary(
        totalValueJpy: totalValue,
        totalCostBasisJpy: totalCostBasis,
        totalProfitLossJpy: totalProfitLoss,
        profitLossPercentage: profitLossPercentage,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get portfolio summary: $e');
    }
  }

  /// Get holdings grouped by crypto with current prices
  Future<List<CryptHolding>> getCryptHoldings() async {
    try {
      // Get all purchases and sells grouped by crypto
      final purchases = await _client
          .from('purchases')
          .select('crypt_id, amount, purchase_yen')
          .order('exec_at');

      final sells = await _client
          .from('sells')
          .select('crypt_id, amount')
          .order('exec_at');

      // Calculate holdings using WAC method
      final Map<String, _HoldingCalculation> holdingsMap = {};

      // Process purchases
      for (final purchase in purchases as List) {
        final cryptId = purchase['crypt_id'] as String;
        final amount = (purchase['amount'] as num).toDouble();
        final purchaseYen = (purchase['purchase_yen'] as num).toDouble();

        if (!holdingsMap.containsKey(cryptId)) {
          holdingsMap[cryptId] = _HoldingCalculation(
            cryptId: cryptId,
            totalAmount: 0.0,
            totalCost: 0.0,
          );
        }

        final holding = holdingsMap[cryptId]!;
        holding.totalAmount += amount;
        holding.totalCost += purchaseYen;
      }

      // Process sells (reduce holdings)
      for (final sell in sells as List) {
        final cryptId = sell['crypt_id'] as String;
        final amount = (sell['amount'] as num).toDouble();

        if (holdingsMap.containsKey(cryptId)) {
          holdingsMap[cryptId]!.totalAmount -= amount;
        }
      }

      // Get crypto details and current prices
      final List<CryptHolding> cryptHoldings = [];

      for (final entry in holdingsMap.entries) {
        final cryptId = entry.key;
        final holding = entry.value;

        // Skip if no holdings remaining
        if (holding.totalAmount <= 0) continue;

        // Get crypto details
        final cryptData = await _client
            .from('crypts')
            .select('symbol, project_name, icon_url, color')
            .eq('id', cryptId)
            .maybeSingle();

        if (cryptData == null) continue;

        // Get latest price
        final priceData = await _client
            .from('prices')
            .select('unit_yen')
            .eq('crypt_id', cryptId)
            .order('exec_at', ascending: false)
            .limit(1)
            .maybeSingle();

        final currentPrice =
            priceData != null ? (priceData['unit_yen'] as num).toDouble() : 0.0;

        final avgCostBasis = holding.totalAmount > 0
            ? holding.totalCost / holding.totalAmount
            : 0.0;
        final valueJpy = holding.totalAmount * currentPrice;
        final profitLossJpy = valueJpy - (holding.totalAmount * avgCostBasis);
        final profitLossPercentage =
            avgCostBasis > 0 ? (profitLossJpy / (holding.totalAmount * avgCostBasis)) * 100 : 0.0;

        cryptHoldings.add(CryptHolding(
          cryptId: cryptId,
          symbol: cryptData['symbol'] as String,
          name: cryptData['project_name'] as String? ?? cryptData['symbol'] as String,
          amount: holding.totalAmount,
          avgCostBasisJpy: avgCostBasis,
          currentPriceJpy: currentPrice,
          valueJpy: valueJpy,
          profitLossJpy: profitLossJpy,
          profitLossPercentage: profitLossPercentage,
          iconUrl: cryptData['icon_url'] as String?,
          color: cryptData['color'] as String?,
        ));
      }

      // Sort by value descending
      cryptHoldings.sort((a, b) => b.valueJpy.compareTo(a.valueJpy));

      return cryptHoldings;
    } catch (e) {
      throw Exception('Failed to get crypt holdings: $e');
    }
  }

  /// Get holdings grouped by account
  Future<List<AccountHolding>> getAccountHoldings() async {
    try {
      // Get all accounts
      final accounts = await _client.from('accounts').select();

      final List<AccountHolding> accountHoldings = [];

      for (final account in accounts as List) {
        final accountId = account['id'] as String;
        final accountName = account['name'] as String;
        final iconUrl = account['icon_url'] as String?;

        // Get holdings for this account
        final holdings = await _getAccountCryptHoldings(accountId);

        if (holdings.isEmpty) continue;

        double totalValue = 0.0;
        double totalProfitLoss = 0.0;

        for (final holding in holdings) {
          totalValue += holding.valueJpy;
          totalProfitLoss += holding.profitLossJpy;
        }

        accountHoldings.add(AccountHolding(
          accountId: accountId,
          name: accountName,
          holdings: holdings,
          totalValueJpy: totalValue,
          totalProfitLossJpy: totalProfitLoss,
          iconUrl: iconUrl,
        ));
      }

      // Sort by value descending
      accountHoldings.sort((a, b) => b.totalValueJpy.compareTo(a.totalValueJpy));

      return accountHoldings;
    } catch (e) {
      throw Exception('Failed to get account holdings: $e');
    }
  }

  /// Helper: Get holdings for a specific account
  Future<List<CryptHolding>> _getAccountCryptHoldings(String accountId) async {
    // Get purchases and sells for this account
    final purchases = await _client
        .from('purchases')
        .select('crypt_id, amount, purchase_yen')
        .eq('account_id', accountId)
        .order('exec_at');

    final sells = await _client
        .from('sells')
        .select('crypt_id, amount')
        .eq('account_id', accountId)
        .order('exec_at');

    // Calculate holdings
    final Map<String, _HoldingCalculation> holdingsMap = {};

    for (final purchase in purchases as List) {
      final cryptId = purchase['crypt_id'] as String;
      final amount = (purchase['amount'] as num).toDouble();
      final purchaseYen = (purchase['purchase_yen'] as num).toDouble();

      if (!holdingsMap.containsKey(cryptId)) {
        holdingsMap[cryptId] = _HoldingCalculation(
          cryptId: cryptId,
          totalAmount: 0.0,
          totalCost: 0.0,
        );
      }

      final holding = holdingsMap[cryptId]!;
      holding.totalAmount += amount;
      holding.totalCost += purchaseYen;
    }

    for (final sell in sells as List) {
      final cryptId = sell['crypt_id'] as String;
      final amount = (sell['amount'] as num).toDouble();

      if (holdingsMap.containsKey(cryptId)) {
        holdingsMap[cryptId]!.totalAmount -= amount;
      }
    }

    // Build holdings list
    final List<CryptHolding> holdings = [];

    for (final entry in holdingsMap.entries) {
      final cryptId = entry.key;
      final holding = entry.value;

      if (holding.totalAmount <= 0) continue;

      // Get crypto details
      final cryptData = await _client
          .from('crypts')
          .select('symbol, project_name, icon_url, color')
          .eq('id', cryptId)
          .maybeSingle();

      if (cryptData == null) continue;

      // Get latest price
      final priceData = await _client
          .from('prices')
          .select('unit_yen')
          .eq('crypt_id', cryptId)
          .order('exec_at', ascending: false)
          .limit(1)
          .maybeSingle();

      final currentPrice =
          priceData != null ? (priceData['unit_yen'] as num).toDouble() : 0.0;

      final avgCostBasis =
          holding.totalAmount > 0 ? holding.totalCost / holding.totalAmount : 0.0;
      final valueJpy = holding.totalAmount * currentPrice;
      final profitLossJpy = valueJpy - (holding.totalAmount * avgCostBasis);
      final profitLossPercentage =
          avgCostBasis > 0 ? (profitLossJpy / (holding.totalAmount * avgCostBasis)) * 100 : 0.0;

      holdings.add(CryptHolding(
        cryptId: cryptId,
        symbol: cryptData['symbol'] as String,
        name: cryptData['project_name'] as String? ?? cryptData['symbol'] as String,
        amount: holding.totalAmount,
        avgCostBasisJpy: avgCostBasis,
        currentPriceJpy: currentPrice,
        valueJpy: valueJpy,
        profitLossJpy: profitLossJpy,
        profitLossPercentage: profitLossPercentage,
        iconUrl: cryptData['icon_url'] as String?,
        color: cryptData['color'] as String?,
      ));
    }

    holdings.sort((a, b) => b.valueJpy.compareTo(a.valueJpy));

    return holdings;
  }

  /// Helper: Calculate current value for crypto
  Future<double> calculateCurrentValue(String cryptId, double amount) async {
    try {
      final priceData = await _client
          .from('prices')
          .select('unit_yen')
          .eq('crypt_id', cryptId)
          .order('exec_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (priceData == null) return 0.0;

      final currentPrice = (priceData['unit_yen'] as num).toDouble();
      return amount * currentPrice;
    } catch (e) {
      throw Exception('Failed to calculate current value: $e');
    }
  }
}

/// Helper class for holding calculations
class _HoldingCalculation {
  final String cryptId;
  double totalAmount;
  double totalCost;

  _HoldingCalculation({
    required this.cryptId,
    required this.totalAmount,
    required this.totalCost,
  });
}
