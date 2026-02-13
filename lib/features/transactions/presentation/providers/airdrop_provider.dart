import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/airdrop_repository.dart';
import '../../domain/purchase.dart';

part 'airdrop_provider.g.dart';

@riverpod
AirdropRepository airdropRepository(AirdropRepositoryRef ref) {
  return AirdropRepository();
}

@riverpod
class AirdropsNotifier extends _$AirdropsNotifier {
  @override
  Future<List<Purchase>> build() async {
    final repository = ref.read(airdropRepositoryProvider);
    try {
      final airdrops = await repository.getAirdrops();
      return _sortByExecAt(airdrops);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> refresh({
    String? accountId,
    String? cryptId,
    int? airdropType,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(airdropRepositoryProvider);
    try {
      final airdrops = await repository.getAirdrops(
        accountId: accountId,
        cryptId: cryptId,
        airdropType: airdropType,
      );
      state = AsyncValue.data(_sortByExecAt(airdrops));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Purchase> create({
    required String accountId,
    required String cryptId,
    required DateTime execAt,
    required double unitYen,
    required double amount,
    required int airdropType,
    required double airdropProfit,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(airdropRepositoryProvider);
    try {
      final created = await repository.createAirdrop(
        accountId: accountId,
        cryptId: cryptId,
        execAt: execAt,
        unitYen: unitYen,
        amount: amount,
        airdropType: airdropType,
        airdropProfit: airdropProfit,
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

  Future<Purchase> update(
    String id, {
    DateTime? execAt,
    double? unitYen,
    double? amount,
    int? airdropType,
    double? airdropProfit,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(airdropRepositoryProvider);
    try {
      final updated = await repository.updateAirdrop(
        id,
        execAt: execAt,
        unitYen: unitYen,
        amount: amount,
        airdropType: airdropType,
        airdropProfit: airdropProfit,
      );
      final current = state.valueOrNull ?? const <Purchase>[];
      final next =
          current.map((purchase) => purchase.id == id ? updated : purchase).toList();
      state = AsyncValue.data(_sortByExecAt(next));
      return updated;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(airdropRepositoryProvider);
    try {
      await repository.deleteAirdrop(id);
      final current = state.valueOrNull ?? const <Purchase>[];
      final next = current.where((purchase) => purchase.id != id).toList();
      state = AsyncValue.data(next);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

List<Purchase> _sortByExecAt(List<Purchase> airdrops) {
  final next = [...airdrops];
  next.sort((a, b) => b.execAt.compareTo(a.execAt));
  return next;
}

final airdropsListProvider = airdropsNotifierProvider;
