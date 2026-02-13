import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/swap_repository.dart';
import '../../domain/swap.dart';

final swapRepositoryProvider = Provider<SwapRepository>((ref) {
  return SwapRepository();
});

class SwapsListNotifier extends AsyncNotifier<List<SwapWithDetails>> {
  @override
  Future<List<SwapWithDetails>> build() async {
    final repository = ref.read(swapRepositoryProvider);
    return repository.listSwaps();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repository = ref.read(swapRepositoryProvider);
    state = await AsyncValue.guard(repository.listSwaps);
  }

  Future<SwapWithDetails> createSwap({
    required String accountId,
    required String sellCryptId,
    required double sellAmount,
    required double sellUnitYen,
    required String buyCryptId,
    required double buyAmount,
    required double buyUnitYen,
    required DateTime execAt,
    double? sellFee,
    double? buyFee,
    String? memo,
  }) async {
    final repository = ref.read(swapRepositoryProvider);
    final created = await repository.createSwap(
      accountId: accountId,
      sellCryptId: sellCryptId,
      sellAmount: sellAmount,
      sellUnitYen: sellUnitYen,
      buyCryptId: buyCryptId,
      buyAmount: buyAmount,
      buyUnitYen: buyUnitYen,
      execAt: execAt,
      sellFee: sellFee,
      buyFee: buyFee,
      memo: memo,
    );
    await refresh();
    return created;
  }

  Future<void> deleteSwap(String id) async {
    final repository = ref.read(swapRepositoryProvider);
    await repository.deleteSwap(id);
    await refresh();
  }
}

final swapsListProvider =
    AsyncNotifierProvider<SwapsListNotifier, List<SwapWithDetails>>(
  SwapsListNotifier.new,
);
