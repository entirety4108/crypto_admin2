import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/transfer_repository.dart';
import '../../domain/transfer.dart';

part 'transfer_provider.g.dart';

@riverpod
TransferRepository transferRepository(TransferRepositoryRef ref) {
  return TransferRepository();
}

@riverpod
class TransfersNotifier extends _$TransfersNotifier {
  @override
  Future<List<Transfer>> build() async {
    final repository = ref.read(transferRepositoryProvider);
    try {
      final transfers = await repository.getTransfers();
      return _sortByExecAt(transfers);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> refresh({
    String? fromAccountId,
    String? toAccountId,
    String? cryptId,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(transferRepositoryProvider);
    try {
      final transfers = await repository.getTransfers(
        fromAccountId: fromAccountId,
        toAccountId: toAccountId,
        cryptId: cryptId,
      );
      state = AsyncValue.data(_sortByExecAt(transfers));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

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
    state = const AsyncValue.loading();
    final repository = ref.read(transferRepositoryProvider);
    try {
      final created = await repository.createTransfer(
        fromAccountId: fromAccountId,
        toAccountId: toAccountId,
        cryptId: cryptId,
        execAt: execAt,
        amount: amount,
        feeCryptId: feeCryptId,
        feeAmount: feeAmount,
        memo: memo,
      );
      final current = state.valueOrNull ?? const <Transfer>[];
      final next = _sortByExecAt([...current, created]);
      state = AsyncValue.data(next);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

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
    state = const AsyncValue.loading();
    final repository = ref.read(transferRepositoryProvider);
    try {
      final updated = await repository.updateTransfer(
        id,
        fromAccountId: fromAccountId,
        toAccountId: toAccountId,
        cryptId: cryptId,
        execAt: execAt,
        amount: amount,
        feeCryptId: feeCryptId,
        feeAmount: feeAmount,
        memo: memo,
      );
      final current = state.valueOrNull ?? const <Transfer>[];
      final next =
          current.map((transfer) => transfer.id == id ? updated : transfer).toList();
      state = AsyncValue.data(_sortByExecAt(next));
      return updated;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(transferRepositoryProvider);
    try {
      await repository.deleteTransfer(id);
      final current = state.valueOrNull ?? const <Transfer>[];
      final next = current.where((transfer) => transfer.id != id).toList();
      state = AsyncValue.data(next);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

List<Transfer> _sortByExecAt(List<Transfer> transfers) {
  final next = [...transfers];
  next.sort((a, b) => b.execAt.compareTo(a.execAt));
  return next;
}

final transfersListProvider = transfersNotifierProvider;
