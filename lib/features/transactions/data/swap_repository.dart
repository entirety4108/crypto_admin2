import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/purchase.dart';
import '../domain/sell.dart';
import '../domain/swap.dart';

class SwapRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<SwapWithDetails> createSwap({
    required String accountId,
    required String sellCryptId,
    required double sellAmount,
    required double sellUnitYen,
    required String buyCryptId,
    required double buyAmount,
    required double buyUnitYen,
    required DateTime execAt,
    double? sellFee,
    double? buyFee,
    String? memo,
  }) async {
    try {
      if (sellCryptId == buyCryptId) {
        throw Exception('sellCryptId and buyCryptId must be different.');
      }

      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not authenticated.');
      }

      final sellFeeValue = sellFee ?? 0.0;
      final buyFeeValue = buyFee ?? 0.0;

      final costBasisData = await _client
          .from('cost_basis_history')
          .select('total_qty, total_cost, wac')
          .eq('account_id', accountId)
          .eq('crypt_id', sellCryptId)
          .order('occurred_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (costBasisData == null) {
        throw Exception('No cost basis found for sell crypt.');
      }

      final currentQty = (costBasisData['total_qty'] as num).toDouble();
      final currentWac = (costBasisData['wac'] as num).toDouble();

      if (sellAmount > currentQty) {
        throw Exception(
          'Insufficient quantity. available=$currentQty requested=$sellAmount',
        );
      }

      final sellYen = sellUnitYen * sellAmount;
      final sellCost = sellAmount * currentWac;
      final sellProfit = sellYen - sellCost - sellFeeValue;

      final sellResponse = await _client
          .from('sells')
          .insert({
            'account_id': accountId,
            'crypt_id': sellCryptId,
            'type': 'w',
            'exec_at': execAt.toIso8601String(),
            'unit_yen': sellUnitYen,
            'amount': sellAmount,
            'yen': sellYen,
            'profit': sellProfit,
          })
          .select()
          .single();
      final sell = Sell.fromJson(Map<String, dynamic>.from(sellResponse));

      final buyTotalYen = buyUnitYen * buyAmount + buyFeeValue;
      final buyResponse = await _client
          .from('purchases')
          .insert({
            'account_id': accountId,
            'crypt_id': buyCryptId,
            'type': 's',
            'exec_at': execAt.toIso8601String(),
            'unit_yen': buyUnitYen,
            'amount': buyAmount,
            'deposit_yen': buyTotalYen,
            'purchase_yen': buyTotalYen,
          })
          .select()
          .single();
      final buy = Purchase.fromJson(Map<String, dynamic>.from(buyResponse));

      final swapRow = await _insertSwapRow(
        sellId: sell.id,
        buyId: buy.id,
        execAt: execAt,
        memo: memo,
        userId: userId,
      );
      final swap = _parseSwap(swapRow);

      return SwapWithDetails(swap: swap, sell: sell, buy: buy);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create swap: $e');
    }
  }

  Future<List<SwapWithDetails>> listSwaps() async {
    try {
      final swapRows = await _loadSwapRows();
      if (swapRows.isEmpty) {
        return const <SwapWithDetails>[];
      }

      final sellIds = swapRows
          .map((row) => _resolveSellId(row))
          .whereType<String>()
          .toSet()
          .toList();
      final buyIds = swapRows
          .map((row) => _resolveBuyId(row))
          .whereType<String>()
          .toSet()
          .toList();

      final sellResponse =
          await _client.from('sells').select().inFilter('id', sellIds);
      final buyResponse =
          await _client.from('purchases').select().inFilter('id', buyIds);

      final sells = (sellResponse as List)
          .map((e) => Sell.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      final buys = (buyResponse as List)
          .map((e) => Purchase.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      final sellMap = {for (final item in sells) item.id: item};
      final buyMap = {for (final item in buys) item.id: item};

      final result = <SwapWithDetails>[];
      for (final row in swapRows) {
        final sellId = _resolveSellId(row);
        final buyId = _resolveBuyId(row);
        if (sellId == null || buyId == null) {
          continue;
        }
        final sell = sellMap[sellId];
        final buy = buyMap[buyId];
        if (sell == null || buy == null) {
          continue;
        }
        result.add(
          SwapWithDetails(
            swap: _parseSwap(row),
            sell: sell,
            buy: buy,
          ),
        );
      }

      result.sort((a, b) => b.execAt.compareTo(a.execAt));
      return result;
    } catch (e) {
      throw Exception('Failed to list swaps: $e');
    }
  }

  Future<SwapWithDetails?> getSwap(String id) async {
    try {
      final row = await _client.from('swaps').select().eq('id', id).maybeSingle();
      if (row == null) {
        return null;
      }
      final rowMap = Map<String, dynamic>.from(row as Map);
      final sellId = _resolveSellId(rowMap);
      final buyId = _resolveBuyId(rowMap);
      if (sellId == null || buyId == null) {
        return null;
      }

      final sellRow =
          await _client.from('sells').select().eq('id', sellId).maybeSingle();
      final buyRow = await _client
          .from('purchases')
          .select()
          .eq('id', buyId)
          .maybeSingle();
      if (sellRow == null || buyRow == null) {
        return null;
      }

      return SwapWithDetails(
        swap: _parseSwap(rowMap),
        sell: Sell.fromJson(Map<String, dynamic>.from(sellRow as Map)),
        buy: Purchase.fromJson(Map<String, dynamic>.from(buyRow as Map)),
      );
    } catch (e) {
      throw Exception('Failed to get swap: $e');
    }
  }

  Future<void> deleteSwap(String id) async {
    try {
      final detail = await getSwap(id);
      await _client.from('swaps').delete().eq('id', id);
      if (detail == null) {
        return;
      }
      await _client.from('sells').delete().eq('id', detail.sell.id);
      await _client.from('purchases').delete().eq('id', detail.buy.id);
    } catch (e) {
      throw Exception('Failed to delete swap: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _loadSwapRows() async {
    try {
      final response =
          await _client.from('swaps').select().order('exec_at', ascending: false);
      return (response as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } on PostgrestException {
      final response = await _client
          .from('swaps')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
  }

  Future<Map<String, dynamic>> _insertSwapRow({
    required String sellId,
    required String buyId,
    required DateTime execAt,
    String? memo,
    required String userId,
  }) async {
    final candidates = <Map<String, dynamic>>[
      {
        'sell_id': sellId,
        'buy_id': buyId,
        'exec_at': execAt.toIso8601String(),
        'memo': memo,
        'user_id': userId,
      },
      {
        'sell_id': sellId,
        'buy_id': buyId,
        'exec_at': execAt.toIso8601String(),
        'memo': memo,
      },
      {
        'sell_tx_id': sellId,
        'buy_tx_id': buyId,
        'exec_at': execAt.toIso8601String(),
        'memo': memo,
        'user_id': userId,
      },
      {
        'sell_tx_id': sellId,
        'buy_tx_id': buyId,
        'exec_at': execAt.toIso8601String(),
        'memo': memo,
      },
    ];

    PostgrestException? lastError;
    for (final data in candidates) {
      try {
        final response = await _client.from('swaps').insert(data).select().single();
        return Map<String, dynamic>.from(response as Map);
      } on PostgrestException catch (e) {
        lastError = e;
      }
    }
    throw Exception('Failed to insert swap row: ${lastError?.message}');
  }

  Swap _parseSwap(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);
    normalized['sell_id'] ??= normalized['sell_tx_id'];
    normalized['buy_id'] ??= normalized['buy_tx_id'];
    normalized['exec_at'] ??= normalized['created_at'];
    return Swap.fromJson(normalized);
  }

  String? _resolveSellId(Map<String, dynamic> row) =>
      (row['sell_id'] ?? row['sell_tx_id']) as String?;

  String? _resolveBuyId(Map<String, dynamic> row) =>
      (row['buy_id'] ?? row['buy_tx_id']) as String?;
}
