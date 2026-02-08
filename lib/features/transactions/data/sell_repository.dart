import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/sell.dart';

class SellRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Get sells with optional filters
  Future<List<Sell>> getSells({
    String? accountId,
    String? cryptId,
  }) async {
    try {
      var query = _client.from('sells').select();

      if (accountId != null) {
        query = query.eq('account_id', accountId);
      }
      if (cryptId != null) {
        query = query.eq('crypt_id', cryptId);
      }

      final response = await query.order('exec_at', ascending: false);
      return (response as List)
          .map((json) => Sell.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get sells: $e');
    }
  }

  /// Get single sell by ID
  Future<Sell?> getSellById(String id) async {
    try {
      final response = await _client
          .from('sells')
          .select()
          .eq('id', id)
          .maybeSingle();

      return response != null
          ? Sell.fromJson(response as Map<String, dynamic>)
          : null;
    } catch (e) {
      throw Exception('Failed to get sell: $e');
    }
  }

  /// Create sell transaction with WAC profit calculation
  Future<Sell> createSell({
    required String accountId,
    required String cryptId,
    required DateTime execAt,
    required double unitYen,
    required double amount,
    String? commissionId,
  }) async {
    try {
      // Step 1: Get commission amount if provided
      double commission = 0.0;
      if (commissionId != null) {
        final commData = await _client
            .from('commissions')
            .select('amount')
            .eq('id', commissionId)
            .maybeSingle();

        if (commData != null) {
          commission = (commData['amount'] as num).toDouble();
        }
      }

      // Step 2: Get current WAC from cost_basis_history
      final costBasisData = await _client
          .from('cost_basis_history')
          .select('total_qty, total_cost, wac')
          .eq('account_id', accountId)
          .eq('crypt_id', cryptId)
          .order('occurred_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (costBasisData == null) {
        throw Exception(
            'No cost basis found. Cannot sell without prior purchases.');
      }

      final currentQty = (costBasisData['total_qty'] as num).toDouble();
      final currentTotalCost =
          (costBasisData['total_cost'] as num).toDouble();
      final currentWac = (costBasisData['wac'] as num).toDouble();

      // Step 3: Validate quantity available
      if (currentQty < amount) {
        throw Exception(
            'Insufficient quantity. Available: $currentQty, Requested: $amount');
      }

      // Step 4: Calculate profit
      final costOfSale = amount * currentWac;
      final sellProceeds = unitYen * amount;
      final profit = sellProceeds - costOfSale - commission;
      final yen = sellProceeds;

      // Step 5: Insert sell transaction
      final sellData = {
        'account_id': accountId,
        'crypt_id': cryptId,
        'type': 's',
        'exec_at': execAt.toIso8601String(),
        'unit_yen': unitYen,
        'amount': amount,
        'yen': yen,
        'commission_id': commissionId,
        'profit': profit,
      };

      final sellResponse = await _client
          .from('sells')
          .insert(sellData)
          .select()
          .single();

      final newSell = Sell.fromJson(sellResponse as Map<String, dynamic>);

      // Step 6: Update cost_basis_history
      final newTotalQty = currentQty - amount;
      final newTotalCost = currentTotalCost - costOfSale;
      final newWac = newTotalQty > 0 ? newTotalCost / newTotalQty : 0.0;

      final costBasisHistoryData = {
        'user_id': _client.auth.currentUser!.id,
        'account_id': accountId,
        'crypt_id': cryptId,
        'transaction_id': newSell.id,
        'transaction_type': 'sell',
        'occurred_at': execAt.toIso8601String(),
        'total_qty': newTotalQty,
        'total_cost': newTotalCost,
        'wac': newWac,
        'realized_pnl': profit,
      };

      await _client.from('cost_basis_history').insert(costBasisHistoryData);

      return newSell;
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create sell: $e');
    }
  }

  /// Update sell
  Future<Sell> updateSell(
    String id, {
    DateTime? execAt,
    double? unitYen,
    double? amount,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (execAt != null) {
        data['exec_at'] = execAt.toIso8601String();
      }
      if (unitYen != null) {
        data['unit_yen'] = unitYen;
      }
      if (amount != null) {
        data['amount'] = amount;
      }

      // Note: Updating a sell transaction requires recalculating cost_basis_history
      // This is a simplified version. Full implementation should:
      // 1. Delete all cost_basis_history records after this transaction
      // 2. Replay all transactions from this point forward
      // For now, we just update the record

      final response = await _client
          .from('sells')
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return Sell.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update sell: $e');
    }
  }

  /// Delete sell
  Future<void> deleteSell(String id) async {
    try {
      // Note: Deleting a sell transaction requires recalculating cost_basis_history
      // This is a simplified version. Full implementation should:
      // 1. Delete the sell record
      // 2. Delete cost_basis_history record for this transaction
      // 3. Recalculate all subsequent cost_basis_history records
      // For now, we just delete the record

      await _client.from('sells').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete sell: $e');
    }
  }
}
