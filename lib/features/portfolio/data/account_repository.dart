import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/account.dart';

class AccountRepository {
  final _table = Supabase.instance.client.from('accounts');

  Future<List<Account>> getAccounts() async {
    try {
      final data = await _table.select();
      return (data as List<dynamic>)
          .map((item) => Account.fromJson(item as Map<String, dynamic>))
          .toList();
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Account?> getAccountById(String id) async {
    try {
      final data = await _table.select().eq('id', id).maybeSingle();
      if (data == null) {
        return null;
      }
      return Account.fromJson(data as Map<String, dynamic>);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Account> createAccount({
    required String name,
    required bool isLocked,
    String? iconUrl,
    String? memo,
  }) async {
    try {
      final payload = <String, dynamic>{
        'name': name,
        'is_locked': isLocked,
        if (iconUrl != null) 'icon_url': iconUrl,
        if (memo != null) 'memo': memo,
      };

      final data = await _table.insert(payload).select().single();
      return Account.fromJson(data as Map<String, dynamic>);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<Account> updateAccount(
    String id, {
    String? name,
    bool? isLocked,
    String? iconUrl,
    String? memo,
  }) async {
    try {
      final payload = <String, dynamic>{
        if (name != null) 'name': name,
        if (isLocked != null) 'is_locked': isLocked,
        if (iconUrl != null) 'icon_url': iconUrl,
        if (memo != null) 'memo': memo,
      };

      if (payload.isEmpty) {
        throw ArgumentError('No fields to update.');
      }

      final data = await _table.update(payload).eq('id', id).select().single();
      return Account.fromJson(data as Map<String, dynamic>);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      await _table.delete().eq('id', id);
    } on PostgrestException {
      rethrow;
    }
  }
}
