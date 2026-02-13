import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/sell_repository.dart';
import '../../domain/sell.dart';

part 'sell_provider.g.dart';

@riverpod
SellRepository sellRepository(SellRepositoryRef ref) {
  return SellRepository();
}

@riverpod
class SellsNotifier extends _$SellsNotifier {
  @override
  Future<List<Sell>> build() async {
    final repository = ref.read(sellRepositoryProvider);
    try {
      final sells = await repository.getSells();
      return _sortByExecAt(sells);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> refresh({String? accountId, String? cryptId}) async {
    state = const AsyncValue.loading();
    final repository = ref.read(sellRepositoryProvider);
    try {
      final sells = await repository.getSells(
        accountId: accountId,
        cryptId: cryptId,
      );
      state = AsyncValue.data(_sortByExecAt(sells));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Sell> createSale({
    required String accountId,
    required String cryptId,
    required DateTime execAt,
    required double unitYen,
    required double amount,
    String? commissionId,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(sellRepositoryProvider);
    try {
      final created = await repository.createSell(
        accountId: accountId,
        cryptId: cryptId,
        execAt: execAt,
        unitYen: unitYen,
        amount: amount,
        commissionId: commissionId,
      );
      final current = state.valueOrNull ?? const <Sell>[];
      final next = _sortByExecAt([...current, created]);
      state = AsyncValue.data(next);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<Sell> updateSell(
    String id, {
    DateTime? execAt,
    double? unitYen,
    double? amount,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(sellRepositoryProvider);
    try {
      final updated = await repository.updateSell(
        id,
        execAt: execAt,
        unitYen: unitYen,
        amount: amount,
      );
      final current = state.valueOrNull ?? const <Sell>[];
      final next =
          current.map((sell) => sell.id == id ? updated : sell).toList();
      state = AsyncValue.data(_sortByExecAt(next));
      return updated;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(sellRepositoryProvider);
    try {
      await repository.deleteSell(id);
      final current = state.valueOrNull ?? const <Sell>[];
      final next = current.where((sell) => sell.id != id).toList();
      state = AsyncValue.data(next);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

List<Sell> _sortByExecAt(List<Sell> sells) {
  final next = [...sells];
  next.sort((a, b) => b.execAt.compareTo(a.execAt));
  return next;
}

final sellsListProvider = sellsNotifierProvider;
