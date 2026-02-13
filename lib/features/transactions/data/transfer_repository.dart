import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/transfer.dart';

class TransferRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Get transfers with optional filters
  Future<List<Transfer>> getTransfers({
    String? fromAccountId,
    String? toAccountId,
    String? cryptId,
  }) async {
    try {
      var query = _client.from('transfers').select();

      if (fromAccountId != null) {
        query = query.eq('from_account_id', fromAccountId);
      }
      if (toAccountId != null) {
        query = query.eq('to_account_id', toAccountId);
      }
      if (cryptId != null) {
        query = query.eq('crypt_id', cryptId);
      }

      final response = await query.order('exec_at', ascending: false);
      return (response as List)
          .map((json) => Transfer.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get transfers: $e');
    }
  }

  /// Get single transfer by ID
  Future<Transfer?> getTransferById(String id) async {
    try {
      final response = await _client
          .from('transfers')
          .select()
          .eq('id', id)
          .maybeSingle();

      return response != null
          ? Transfer.fromJson(response as Map<String, dynamic>)
          : null;
    } catch (e) {
      throw Exception('Failed to get transfer: $e');
    }
  }

  /// Create transfer
  Future<Transfer> createTransfer({
    required String fromAccountId,
    required String toAccountId,
    required String cryptId,
    required DateTime execAt,
    required double amount,
    String? feeCryptId,
    double? feeAmount,
    String? memo,
  }) async {
    try {
      final data = {
        'from_account_id': fromAccountId,
        'to_account_id': toAccountId,
        'crypt_id': cryptId,
        'exec_at': execAt.toIso8601String(),
        'amount': amount,
        'fee_crypt_id': feeCryptId,
        'fee_amount': feeAmount,
        'memo': memo,
      };

      final response = await _client
          .from('transfers')
          .insert(data)
          .select()
          .single();

      return Transfer.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create transfer: $e');
    }
  }

  /// Update transfer
  Future<Transfer> updateTransfer(
    String id, {
    String? fromAccountId,
    String? toAccountId,
    String? cryptId,
    DateTime? execAt,
    double? amount,
    String? feeCryptId,
    double? feeAmount,
    String? memo,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (fromAccountId != null) {
        data['from_account_id'] = fromAccountId;
      }
      if (toAccountId != null) {
        data['to_account_id'] = toAccountId;
      }
      if (cryptId != null) {
        data['crypt_id'] = cryptId;
      }
      if (execAt != null) {
        data['exec_at'] = execAt.toIso8601String();
      }
      if (amount != null) {
        data['amount'] = amount;
      }
      if (feeAmount != null || feeCryptId != null) {
        data['fee_amount'] = feeAmount;
        data['fee_crypt_id'] = feeCryptId;
      }
      if (memo != null) {
        data['memo'] = memo;
      }

      final response = await _client
          .from('transfers')
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return Transfer.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update transfer: $e');
    }
  }

  /// Delete transfer
  Future<void> deleteTransfer(String id) async {
    try {
      await _client.from('transfers').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete transfer: $e');
    }
  }
}
