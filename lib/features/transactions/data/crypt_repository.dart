import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/crypt.dart';

class CryptRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Get all active cryptocurrencies
  Future<List<Crypt>> getCrypts() async {
    try {
      final response = await _client
          .from('crypts')
          .select()
          .eq('status', 'a')
          .order('symbol');

      return (response as List)
          .map((json) => Crypt.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get crypts: $e');
    }
  }

  /// Get single crypt by ID
  Future<Crypt?> getCryptById(String id) async {
    try {
      final response = await _client
          .from('crypts')
          .select()
          .eq('id', id)
          .maybeSingle();

      return response != null
          ? Crypt.fromJson(response as Map<String, dynamic>)
          : null;
    } catch (e) {
      throw Exception('Failed to get crypt: $e');
    }
  }

  /// Get crypt by symbol (e.g., 'BTC', 'ETH')
  Future<Crypt?> getCryptBySymbol(String symbol) async {
    try {
      final response = await _client
          .from('crypts')
          .select()
          .eq('symbol', symbol)
          .maybeSingle();

      return response != null
          ? Crypt.fromJson(response as Map<String, dynamic>)
          : null;
    } catch (e) {
      throw Exception('Failed to get crypt by symbol: $e');
    }
  }
}
