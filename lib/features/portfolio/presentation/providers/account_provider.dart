import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/account_repository.dart';
import '../../data/address_repository.dart';
import '../../domain/account.dart';
import '../../domain/address.dart';

part 'account_provider.g.dart';

@riverpod
AccountRepository accountRepository(AccountRepositoryRef ref) {
  return AccountRepository();
}

@riverpod
AddressRepository addressRepository(AddressRepositoryRef ref) {
  return AddressRepository();
}

@riverpod
class AccountsNotifier extends _$AccountsNotifier {
  @override
  Future<List<Account>> build() async {
    final repository = ref.read(accountRepositoryProvider);
    try {
      return await repository.getAccounts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repository = ref.read(accountRepositoryProvider);
    try {
      final accounts = await repository.getAccounts();
      state = AsyncValue.data(accounts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> create(String name, String address, String? icon) async {
    state = const AsyncValue.loading();
    final accountRepository = ref.read(accountRepositoryProvider);
    final addressRepository = ref.read(addressRepositoryProvider);
    try {
      final account = await accountRepository.createAccount(
        name: name,
        isLocked: false,
        iconUrl: icon,
      );
      final Address _ = await addressRepository.createAddress(
        accountId: account.id,
        address: address,
      );
      final current = state.valueOrNull ?? const <Account>[];
      state = AsyncValue.data([...current, account]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update(
    String id, {
    String? name,
    String? icon,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(accountRepositoryProvider);
    try {
      final updated = await repository.updateAccount(
        id,
        name: name,
        iconUrl: icon,
      );
      final current = state.valueOrNull ?? const <Account>[];
      final next = current
          .map((account) => account.id == id ? updated : account)
          .toList();
      state = AsyncValue.data(next);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(accountRepositoryProvider);
    try {
      await repository.deleteAccount(id);
      final current = state.valueOrNull ?? const <Account>[];
      final next = current.where((account) => account.id != id).toList();
      state = AsyncValue.data(next);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final AsyncNotifierProvider<AccountsNotifier, List<Account>> accountsListProvider =
    accountsNotifierProvider;

final selectedAccountProvider = StateProvider<Account?>((ref) => null);
