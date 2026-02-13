import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/purchase.dart';

class AirdropRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Get airdrops (type='a') with optional filters
  Future<List<Purchase>> getAirdrops({
    String? accountId,
    String? cryptId,
    int? airdropType,
  }) async {
    try {
      var query = _client.from('purchases').select().eq('type', 'a');

      if (accountId != null) {
        query = query.eq('account_id', accountId);
      }
      if (cryptId != null) {
        query = query.eq('crypt_id', cryptId);
      }
      if (airdropType != null) {
        query = query.eq('airdrop_type', airdropType);
      }

      final response = await query.order('exec_at', ascending: false);
      return (response as List)
          .map((json) => Purchase.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get airdrops: $e');
    }
  }

  /// Get single airdrop by ID
  Future<Purchase?> getAirdropById(String id) async {
    try {
      final response = await _client
          .from('purchases')
          .select()
          .eq('id', id)
          .eq('type', 'a')
          .maybeSingle();

      return response != null
          ? Purchase.fromJson(response as Map<String, dynamic>)
          : null;
    } catch (e) {
      throw Exception('Failed to get airdrop: $e');
    }
  }

  /// Create airdrop transaction (type='a')
  Future<Purchase> createAirdrop({
    required String accountId,
    required String cryptId,
    required DateTime execAt,
    required double unitYen,
    required double amount,
    required int airdropType,
    required double airdropProfit,
    String? commissionId,
  }) async {
    try {
      final data = {
        'account_id': accountId,
        'crypt_id': cryptId,
        'type': 'a',
        'exec_at': execAt.toIso8601String(),
        'unit_yen': unitYen,
        'amount': amount,
        'deposit_yen': airdropProfit,
        'purchase_yen': airdropProfit,
        'airdrop_type': airdropType,
        'airdrop_profit': airdropProfit,
        'commission_id': commissionId,
      };

      final response = await _client
          .from('purchases')
          .insert(data)
          .select()
          .single();

      return Purchase.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create airdrop: $e');
    }
  }

  /// Update airdrop
  Future<Purchase> updateAirdrop(
    String id, {
    DateTime? execAt,
    double? unitYen,
    double? amount,
    int? airdropType,
    double? airdropProfit,
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
      if (airdropType != null) {
        data['airdrop_type'] = airdropType;
      }
      if (airdropProfit != null) {
        data['airdrop_profit'] = airdropProfit;
        data['deposit_yen'] = airdropProfit;
        data['purchase_yen'] = airdropProfit;
      }

      final response = await _client
          .from('purchases')
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return Purchase.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update airdrop: $e');
    }
  }

  /// Delete airdrop
  Future<void> deleteAirdrop(String id) async {
    try {
      await _client.from('purchases').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete airdrop: $e');
    }
  }
}
