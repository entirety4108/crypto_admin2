import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/category_repository.dart';
import '../../domain/crypt_category.dart';
import '../../domain/category_with_crypts.dart';

part 'category_provider.g.dart';

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return CategoryRepository();
}

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  Future<List<CryptCategory>> build() async {
    final repository = ref.read(categoryRepositoryProvider);
    try {
      return await repository.getCategories();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repository = ref.read(categoryRepositoryProvider);
    try {
      final categories = await repository.getCategories();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<CryptCategory> create({
    required String name,
    required String color,
    String? iconUrl,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(categoryRepositoryProvider);
    try {
      final created = await repository.createCategory(
        name: name,
        color: color,
        iconUrl: iconUrl,
      );
      final current = state.valueOrNull ?? const <CryptCategory>[];
      state = AsyncValue.data([created, ...current]);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<CryptCategory> update(
    String id, {
    String? name,
    String? color,
    String? iconUrl,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(categoryRepositoryProvider);
    try {
      final updated = await repository.updateCategory(
        id,
        name: name,
        color: color,
        iconUrl: iconUrl,
      );
      final current = state.valueOrNull ?? const <CryptCategory>[];
      final next = current
          .map((category) => category.id == id ? updated : category)
          .toList();
      state = AsyncValue.data(next);
      return updated;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(categoryRepositoryProvider);
    try {
      await repository.deleteCategory(id);
      final current = state.valueOrNull ?? const <CryptCategory>[];
      final next = current.where((category) => category.id != id).toList();
      state = AsyncValue.data(next);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> assignCrypt({
    required String cryptId,
    required String categoryId,
  }) async {
    final repository = ref.read(categoryRepositoryProvider);
    try {
      await repository.assignCryptToCategory(
        cryptId: cryptId,
        categoryId: categoryId,
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> unassignCrypt({
    required String cryptId,
    required String categoryId,
  }) async {
    final repository = ref.read(categoryRepositoryProvider);
    try {
      await repository.unassignCryptFromCategory(
        cryptId: cryptId,
        categoryId: categoryId,
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final categoriesListProvider = categoriesNotifierProvider;

@riverpod
Future<CategoryWithCrypts> categoryWithCrypts(
  CategoryWithCryptsRef ref,
  String categoryId,
) async {
  final repository = ref.read(categoryRepositoryProvider);
  return repository.getCategoryWithCrypts(categoryId);
}

@riverpod
Future<int> categoryCryptCount(
  CategoryCryptCountRef ref,
  String categoryId,
) async {
  final repository = ref.read(categoryRepositoryProvider);
  return repository.getCryptCountForCategory(categoryId);
}
