import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/purchase_repository.dart';
import '../../data/crypt_repository.dart';
import '../../domain/purchase.dart';
import '../../domain/crypt.dart';

part 'purchase_provider.g.dart';

@riverpod
PurchaseRepository purchaseRepository(PurchaseRepositoryRef ref) {
  return PurchaseRepository();
}

@riverpod
CryptRepository cryptRepository(CryptRepositoryRef ref) {
  return CryptRepository();
}

@riverpod
class PurchasesNotifier extends _$PurchasesNotifier {
  @override
  Future<List<Purchase>> build() async {
    final repository = ref.read(purchaseRepositoryProvider);
    try {
      final purchases = await repository.getPurchases();
      return _sortByExecAt(purchases);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> refresh({String? accountId, String? cryptId}) async {
    state = const AsyncValue.loading();
    final repository = ref.read(purchaseRepositoryProvider);
    try {
      final purchases = await repository.getPurchases(
        accountId: accountId,
        cryptId: cryptId,
      );
      state = AsyncValue.data(_sortByExecAt(purchases));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Purchase> createDeposit({
    required String accountId,
    required String cryptId,
    required DateTime execAt,
    required double unitYen,
    required double amount,
    required double depositYen,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(purchaseRepositoryProvider);
    try {
      final created = await repository.createDeposit(
        accountId: accountId,
        cryptId: cryptId,
        execAt: execAt,
        unitYen: unitYen,
        amount: amount,
        depositYen: depositYen,
      );
      final current = state.valueOrNull ?? const <Purchase>[];
      final next = _sortByExecAt([...current, created]);
      state = AsyncValue.data(next);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<Purchase> updatePurchase(
    String id, {
    DateTime? execAt,
    double? unitYen,
    double? amount,
    double? depositYen,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(purchaseRepositoryProvider);
    try {
      final updated = await repository.updatePurchase(
        id,
        execAt: execAt,
        unitYen: unitYen,
        amount: amount,
        depositYen: depositYen,
      );
      final current = state.valueOrNull ?? const <Purchase>[];
      final next = current
          .map((purchase) => purchase.id == id ? updated : purchase)
          .toList();
      state = AsyncValue.data(_sortByExecAt(next));
      return updated;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(purchaseRepositoryProvider);
    try {
      await repository.deletePurchase(id);
      final current = state.valueOrNull ?? const <Purchase>[];
      final next = current.where((purchase) => purchase.id != id).toList();
      state = AsyncValue.data(next);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

List<Purchase> _sortByExecAt(List<Purchase> purchases) {
  final next = [...purchases];
  next.sort((a, b) => b.execAt.compareTo(a.execAt));
  return next;
}

final purchasesListProvider = purchasesNotifierProvider;

@riverpod
Future<List<Crypt>> cryptsList(CryptsListRef ref) async {
  final repository = ref.read(cryptRepositoryProvider);
  return repository.getCrypts();
}
