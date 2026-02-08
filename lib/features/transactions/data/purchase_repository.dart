import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/purchase.dart';

class PurchaseRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Get purchases with optional filters
  Future<List<Purchase>> getPurchases({
    String? accountId,
    String? cryptId,
  }) async {
    try {
      var query = _client.from('purchases').select();

      if (accountId != null) {
        query = query.eq('account_id', accountId);
      }
      if (cryptId != null) {
        query = query.eq('crypt_id', cryptId);
      }

      final response = await query.order('exec_at', ascending: false);
      return (response as List)
          .map((json) => Purchase.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get purchases: $e');
    }
  }

  /// Get single purchase by ID
  Future<Purchase?> getPurchaseById(String id) async {
    try {
      final response = await _client
          .from('purchases')
          .select()
          .eq('id', id)
          .maybeSingle();

      return response != null
          ? Purchase.fromJson(response as Map<String, dynamic>)
          : null;
    } catch (e) {
      throw Exception('Failed to get purchase: $e');
    }
  }

  /// Create deposit transaction (type='d')
  Future<Purchase> createDeposit({
    required String accountId,
    required String cryptId,
    required DateTime execAt,
    required double unitYen,
    required double amount,
    required double depositYen,
    String? commissionId,
  }) async {
    try {
      double commission = 0.0;

      // Get commission amount if commissionId is provided
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

      final purchaseYen = depositYen - commission;

      final data = {
        'account_id': accountId,
        'crypt_id': cryptId,
        'type': 'd',
        'exec_at': execAt.toIso8601String(),
        'unit_yen': unitYen,
        'amount': amount,
        'purchase_yen': purchaseYen,
        'deposit_yen': depositYen,
        'commission_id': commissionId,
      };

      final response = await _client
          .from('purchases')
          .insert(data)
          .select()
          .single();

      return Purchase.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create deposit: $e');
    }
  }

  /// Update purchase
  Future<Purchase> updatePurchase(
    String id, {
    DateTime? execAt,
    double? unitYen,
    double? amount,
    double? depositYen,
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
      if (depositYen != null) {
        data['deposit_yen'] = depositYen;
      }

      final response = await _client
          .from('purchases')
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return Purchase.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update purchase: $e');
    }
  }

  /// Delete purchase
  Future<void> deletePurchase(String id) async {
    try {
      await _client.from('purchases').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete purchase: $e');
    }
  }
}
