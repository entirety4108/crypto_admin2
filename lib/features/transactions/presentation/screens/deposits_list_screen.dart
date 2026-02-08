import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/purchase.dart';
import '../../domain/crypt.dart';
import '../../../portfolio/domain/account.dart';
import '../providers/purchase_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

enum DepositSort {
  execAtDesc,
  execAtAsc,
  amountDesc,
  amountAsc,
  depositDesc,
  depositAsc,
}

extension DepositSortLabel on DepositSort {
  String label() {
    switch (this) {
      case DepositSort.execAtDesc:
        return '実行日（新しい順）';
      case DepositSort.execAtAsc:
        return '実行日（古い順）';
      case DepositSort.amountDesc:
        return '数量（多い順）';
      case DepositSort.amountAsc:
        return '数量（少ない順）';
      case DepositSort.depositDesc:
        return '入金額（高い順）';
      case DepositSort.depositAsc:
        return '入金額（低い順）';
    }
  }

  int compare(Purchase a, Purchase b) {
    switch (this) {
      case DepositSort.execAtDesc:
        return b.execAt.compareTo(a.execAt);
      case DepositSort.execAtAsc:
        return a.execAt.compareTo(b.execAt);
      case DepositSort.amountDesc:
        return b.amount.compareTo(a.amount);
      case DepositSort.amountAsc:
        return a.amount.compareTo(b.amount);
      case DepositSort.depositDesc:
        return b.depositYen.compareTo(a.depositYen);
      case DepositSort.depositAsc:
        return a.depositYen.compareTo(b.depositYen);
    }
  }
}

enum _DepositAction {
  edit,
  delete,
}

class DepositsListScreen extends ConsumerStatefulWidget {
  const DepositsListScreen({super.key});

  @override
  ConsumerState<DepositsListScreen> createState() =>
      _DepositsListScreenState();
}

class _DepositsListScreenState extends ConsumerState<DepositsListScreen> {
  String? _selectedAccountId;
  String? _selectedCryptId;
  DepositSort _sort = DepositSort.execAtDesc;

  final _yenFormat = NumberFormat.currency(
    locale: 'ja_JP',
    symbol: '¥',
    decimalDigits: 0,
  );

  String _formatDate(DateTime value) {
    return DateFormat('yyyy/MM/dd HH:mm').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final purchasesAsync = ref.watch(purchasesListProvider);
    final accountsAsync = ref.watch(accountsListProvider);
    final cryptsAsync = ref.watch(cryptsListProvider);

    final accounts = accountsAsync.valueOrNull ?? const <Account>[];
    final crypts = cryptsAsync.valueOrNull ?? const <Crypt>[];

    final accountMap = {
      for (final account in accounts) account.id: account,
    };
    final cryptMap = {
      for (final crypt in crypts) crypt.id: crypt,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('入金一覧'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _FiltersSection(
            accounts: accounts,
            crypts: crypts,
            selectedAccountId: _selectedAccountId,
            selectedCryptId: _selectedCryptId,
            sort: _sort,
            isLoading:
                accountsAsync.isLoading || cryptsAsync.isLoading,
            onAccountChanged: (value) {
              setState(() {
                _selectedAccountId = value;
              });
            },
            onCryptChanged: (value) {
              setState(() {
                _selectedCryptId = value;
              });
            },
            onSortChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _sort = value;
              });
            },
          ),
          Expanded(
            child: purchasesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '入金の取得に失敗しました',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        ref.read(purchasesListProvider.notifier).refresh();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('再読み込み'),
                    ),
                  ],
                ),
              ),
              data: (purchases) {
                final filtered = purchases
                    .where((purchase) => purchase.type == 'd')
                    .where((purchase) {
                      if (_selectedAccountId == null) {
                        return true;
                      }
                      return purchase.accountId == _selectedAccountId;
                    })
                    .where((purchase) {
                      if (_selectedCryptId == null) {
                        return true;
                      }
                      return purchase.cryptId == _selectedCryptId;
                    })
                    .toList()
                  ..sort(_sort.compare);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.savings_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '入金がありません',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('右下のボタンから登録できます'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(purchasesListProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final purchase = filtered[index];
                      final account = accountMap[purchase.accountId];
                      final crypt = cryptMap[purchase.cryptId];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: crypt?.iconUrl != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(crypt!.iconUrl!),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.currency_bitcoin),
                                ),
                          title: Text(
                            '${crypt?.symbol ?? '不明'}  ${purchase.amount}',
                          ),
                          subtitle: Text(
                            '口座: ${account?.name ?? '不明'}\n'
                            '実行: ${_formatDate(purchase.execAt)}\n'
                            '入金額: ${_yenFormat.format(purchase.depositYen)}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<_DepositAction>(
                            onSelected: (action) async {
                              if (action == _DepositAction.edit) {
                                context.push(
                                  '/transactions/deposits/edit',
                                  extra: purchase,
                                );
                                return;
                              }

                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('削除確認'),
                                  content: const Text('この入金を削除しますか？'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('キャンセル'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .error,
                                      ),
                                      child: const Text('削除'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed != true) {
                                return;
                              }

                              try {
                                await ref
                                    .read(purchasesListProvider.notifier)
                                    .delete(purchase.id);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('削除しました')),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('削除に失敗しました: ${e.toString()}'),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .error,
                                    ),
                                  );
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: _DepositAction.edit,
                                child: Text('編集'),
                              ),
                              const PopupMenuItem(
                                value: _DepositAction.delete,
                                child: Text('削除'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/transactions/deposits/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('入金登録'),
      ),
    );
  }
}

class _FiltersSection extends StatelessWidget {
  const _FiltersSection({
    required this.accounts,
    required this.crypts,
    required this.selectedAccountId,
    required this.selectedCryptId,
    required this.sort,
    required this.onAccountChanged,
    required this.onCryptChanged,
    required this.onSortChanged,
    required this.isLoading,
  });

  final List<Account> accounts;
  final List<Crypt> crypts;
  final String? selectedAccountId;
  final String? selectedCryptId;
  final DepositSort sort;
  final ValueChanged<String?> onAccountChanged;
  final ValueChanged<String?> onCryptChanged;
  final ValueChanged<DepositSort?> onSortChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          if (isLoading) ...[
            const LinearProgressIndicator(),
            const SizedBox(height: 12),
          ],
          DropdownButtonFormField<String?>(
            value: selectedAccountId,
            decoration: const InputDecoration(
              labelText: '口座フィルター',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_balance_wallet),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('すべての口座'),
              ),
              ...accounts.map(
                (account) => DropdownMenuItem(
                  value: account.id,
                  child: Text(account.name),
                ),
              ),
            ],
            onChanged: onAccountChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            value: selectedCryptId,
            decoration: const InputDecoration(
              labelText: '暗号資産フィルター',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.currency_bitcoin),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('すべての暗号資産'),
              ),
              ...crypts.map(
                (crypt) => DropdownMenuItem(
                  value: crypt.id,
                  child: Text(crypt.symbol),
                ),
              ),
            ],
            onChanged: onCryptChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<DepositSort>(
            value: sort,
            decoration: const InputDecoration(
              labelText: '並び替え',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.sort),
            ),
            items: DepositSort.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(value.label()),
                  ),
                )
                .toList(),
            onChanged: onSortChanged,
          ),
        ],
      ),
    );
  }
}
