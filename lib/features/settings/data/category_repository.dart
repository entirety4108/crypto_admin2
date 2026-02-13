import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/services/supabase_service.dart';
import '../../transactions/domain/crypt.dart';
import '../domain/crypt_category.dart';
import '../domain/user_crypt_category.dart';
import '../domain/category_with_crypts.dart';

class CategoryRepository {
  final SupabaseClient _client = SupabaseService.client;

  String _requireUserId() {
    final user = SupabaseService.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.id;
  }

  Future<List<CryptCategory>> getCategories() async {
    try {
      final userId = _requireUserId();
      final data = await _client
          .from('crypt_categories')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (data as List<dynamic>)
          .map((item) => CryptCategory.fromJson(item as Map<String, dynamic>))
          .toList();
    } on PostgrestException {
      rethrow;
    }
  }

  Future<CategoryWithCrypts> getCategoryWithCrypts(String categoryId) async {
    try {
      final userId = _requireUserId();

      final categoryData = await _client
          .from('crypt_categories')
          .select()
          .eq('id', categoryId)
          .eq('user_id', userId)
          .maybeSingle();

      if (categoryData == null) {
        throw Exception('Category not found');
      }

      final category =
          CryptCategory.fromJson(categoryData as Map<String, dynamic>);

      final linkData = await _client
          .from('user_crypt_categories')
          .select('crypt_id')
          .eq('user_id', userId)
          .eq('category_id', categoryId);

      final cryptIds = (linkData as List<dynamic>)
          .map((item) => item['crypt_id'] as String)
          .toList();

      if (cryptIds.isEmpty) {
        return CategoryWithCrypts(category: category, crypts: const []);
      }

      final cryptData = await _client
          .from('crypts')
          .select()
          .in_('id', cryptIds)
          .order('symbol');

      final crypts = (cryptData as List<dynamic>)
          .map((item) => Crypt.fromJson(item as Map<String, dynamic>))
          .toList();

      return CategoryWithCrypts(category: category, crypts: crypts);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<CryptCategory> createCategory({
    required String name,
    required String color,
    String? iconUrl,
  }) async {
    try {
      final userId = _requireUserId();
      final payload = <String, dynamic>{
        'user_id': userId,
        'name': name,
        'color': color,
        if (iconUrl != null) 'icon_url': iconUrl,
      };

      final data = await _client
          .from('crypt_categories')
          .insert(payload)
          .select()
          .single();

      return CryptCategory.fromJson(data as Map<String, dynamic>);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<CryptCategory> updateCategory(
    String id, {
    String? name,
    String? color,
    String? iconUrl,
  }) async {
    try {
      final userId = _requireUserId();
      final payload = <String, dynamic>{
        if (name != null) 'name': name,
        if (color != null) 'color': color,
        if (iconUrl != null) 'icon_url': iconUrl,
      };

      if (payload.isEmpty) {
        throw ArgumentError('No fields to update.');
      }

      final data = await _client
          .from('crypt_categories')
          .update(payload)
          .eq('id', id)
          .eq('user_id', userId)
          .select()
          .single();

      return CryptCategory.fromJson(data as Map<String, dynamic>);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final userId = _requireUserId();
      await _client
          .from('user_crypt_categories')
          .delete()
          .eq('user_id', userId)
          .eq('category_id', id);

      await _client
          .from('crypt_categories')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<UserCryptCategory> assignCryptToCategory({
    required String cryptId,
    required String categoryId,
  }) async {
    try {
      final userId = _requireUserId();
      final payload = <String, dynamic>{
        'user_id': userId,
        'category_id': categoryId,
        'crypt_id': cryptId,
      };

      final data = await _client
          .from('user_crypt_categories')
          .insert(payload)
          .select()
          .single();

      return UserCryptCategory.fromJson(data as Map<String, dynamic>);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<void> unassignCryptFromCategory({
    required String cryptId,
    required String categoryId,
  }) async {
    try {
      final userId = _requireUserId();
      await _client
          .from('user_crypt_categories')
          .delete()
          .eq('user_id', userId)
          .eq('category_id', categoryId)
          .eq('crypt_id', cryptId);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<List<CryptCategory>> getCategoriesForCrypt(String cryptId) async {
    try {
      final userId = _requireUserId();
      final linkData = await _client
          .from('user_crypt_categories')
          .select('category_id')
          .eq('user_id', userId)
          .eq('crypt_id', cryptId);

      final categoryIds = (linkData as List<dynamic>)
          .map((item) => item['category_id'] as String)
          .toList();

      if (categoryIds.isEmpty) {
        return const <CryptCategory>[];
      }

      final data = await _client
          .from('crypt_categories')
          .select()
          .in_('id', categoryIds)
          .order('created_at', ascending: false);

      return (data as List<dynamic>)
          .map((item) => CryptCategory.fromJson(item as Map<String, dynamic>))
          .toList();
    } on PostgrestException {
      rethrow;
    }
  }

  Future<int> getCryptCountForCategory(String categoryId) async {
    try {
      final userId = _requireUserId();
      final data = await _client
          .from('user_crypt_categories')
          .select('id')
          .eq('user_id', userId)
          .eq('category_id', categoryId);

      return (data as List<dynamic>).length;
    } on PostgrestException {
      rethrow;
    }
  }
}
