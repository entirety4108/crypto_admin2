import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/address.dart';

class AddressRepository {
  final _table = Supabase.instance.client.from('addresses');

  Future<List<Address>> getAddressesByAccount(String accountId) async {
    try {
      final data = await _table.select().eq('account_id', accountId);
      return (data as List<dynamic>)
          .map((item) => Address.fromJson(item as Map<String, dynamic>))
          .toList();
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Address> createAddress({
    required String accountId,
    required String address,
    String? label,
  }) async {
    try {
      final payload = <String, dynamic>{
        'account_id': accountId,
        'address': address,
        if (label != null) 'label': label,
      };

      final data = await _table.insert(payload).select().single();
      return Address.fromJson(data as Map<String, dynamic>);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Address> updateAddress(
    String id, {
    String? address,
    String? label,
  }) async {
    try {
      final payload = <String, dynamic>{
        if (address != null) 'address': address,
        if (label != null) 'label': label,
      };

      if (payload.isEmpty) {
        throw ArgumentError('No fields to update.');
      }

      final data = await _table.update(payload).eq('id', id).select().single();
      return Address.fromJson(data as Map<String, dynamic>);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _table.delete().eq('id', id);
    } on PostgrestException {
      rethrow;
    }
  }
}
