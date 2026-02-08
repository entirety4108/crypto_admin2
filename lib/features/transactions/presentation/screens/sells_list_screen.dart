import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/sell.dart';
import '../../domain/crypt.dart';
import '../../../portfolio/domain/account.dart';
import '../providers/sell_provider.dart';
import '../providers/purchase_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

enum SellSort {
  execAtDesc,
  execAtAsc,
  amountDesc,
  amountAsc,
  yenDesc,
  yenAsc,
  profitDesc,
  profitAsc,
}

extension SellSortLabel on SellSort {
  String label() {
    switch (this) {
      case SellSort.execAtDesc:
        return '実行日（新しい順）';
      case SellSort.execAtAsc:
        return '実行日（古い順）';
      case SellSort.amountDesc:
        return '数量（多い順）';
      case SellSort.amountAsc:
        return '数量（少ない順）';
      case SellSort.yenDesc:
        return '売却額（高い順）';
      case SellSort.yenAsc:
        return '売却額（低い順）';
      case SellSort.profitDesc:
        return '損益（利益順）';
      case SellSort.profitAsc:
        return '損益（損失順）';
    }
  }

  int compare(Sell a, Sell b) {
    switch (this) {
      case SellSort.execAtDesc:
        return b.execAt.compareTo(a.execAt);
      case SellSort.execAtAsc:
        return a.execAt.compareTo(b.execAt);
      case SellSort.amountDesc:
        return b.amount.compareTo(a.amount);
      case SellSort.amountAsc:
        return a.amount.compareTo(b.amount);
      case SellSort.yenDesc:
        return b.yen.compareTo(a.yen);
      case SellSort.yenAsc:
        return a.yen.compareTo(b.yen);
      case SellSort.profitDesc:
        final profitA = a.profit ?? 0.0;
        final profitB = b.profit ?? 0.0;
        return profitB.compareTo(profitA);
      case SellSort.profitAsc:
        final profitA = a.profit ?? 0.0;
        final profitB = b.profit ?? 0.0;
        return profitA.compareTo(profitB);
    }
  }
}

enum _SellAction {
  edit,
  delete,
}

class SellsListScreen extends ConsumerStatefulWidget {
  const SellsListScreen({super.key});

  @override
  ConsumerState<SellsListScreen> createState() => _SellsListScreenState();
}

class _SellsListScreenState extends ConsumerState<SellsListScreen> {
  String? _selectedAccountId;
  String? _selectedCryptId;
  SellSort _sort = SellSort.execAtDesc;

  final _yenFormat = NumberFormat.currency(
    locale: 'ja_JP',
    symbol: '¥',
    decimalDigits: 0,
  );

  String _formatDate(DateTime value) {
    return DateFormat('yyyy/MM/dd HH:mm').format(value);
  }

  Color _getProfitColor(BuildContext context, double? profit) {
    if (profit == null || profit == 0.0) {
      return Colors.grey;
    } else if (profit > 0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sellsAsync = ref.watch(sellsListProvider);
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
        title: const Text('売却一覧'),
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
            isLoading: accountsAsync.isLoading || cryptsAsync.isLoading,
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
            child: sellsAsync.when(
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
                      '売却の取得に失敗しました',
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
                        ref.read(sellsListProvider.notifier).refresh();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('再読み込み'),
                    ),
                  ],
                ),
              ),
              data: (sells) {
                final filtered = sells
                    .where((sell) {
                      if (_selectedAccountId == null) {
                        return true;
                      }
                      return sell.accountId == _selectedAccountId;
                    })
                    .where((sell) {
                      if (_selectedCryptId == null) {
                        return true;
                      }
                      return sell.cryptId == _selectedCryptId;
                    })
                    .toList()
                  ..sort(_sort.compare);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sell_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '売却がありません',
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
                    await ref.read(sellsListProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final sell = filtered[index];
                      final account = accountMap[sell.accountId];
                      final crypt = cryptMap[sell.cryptId];
                      final profitColor = _getProfitColor(context, sell.profit);

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
                            '${crypt?.symbol ?? '不明'}  ${sell.amount}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('口座: ${account?.name ?? '不明'}'),
                              Text('実行: ${_formatDate(sell.execAt)}'),
                              Text('単価: ${_yenFormat.format(sell.unitYen)}'),
                              Text('売却額: ${_yenFormat.format(sell.yen)}'),
                              Text(
                                '損益: ${_yenFormat.format(sell.profit ?? 0.0)}',
                                style: TextStyle(
                                  color: profitColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<_SellAction>(
                            onSelected: (action) async {
                              if (action == _SellAction.edit) {
                                context.push(
                                  '/transactions/sells/edit',
                                  extra: sell,
                                );
                                return;
                              }

                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('削除確認'),
                                  content: const Text('この売却を削除しますか？'),
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
                                        backgroundColor:
                                            Theme.of(context).colorScheme.error,
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
                                    .read(sellsListProvider.notifier)
                                    .delete(sell.id);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('削除しました')),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('削除に失敗しました: ${e.toString()}'),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  );
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: _SellAction.edit,
                                child: Text('編集'),
                              ),
                              const PopupMenuItem(
                                value: _SellAction.delete,
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
          context.push('/transactions/sells/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('売却登録'),
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
  final SellSort sort;
  final ValueChanged<String?> onAccountChanged;
  final ValueChanged<String?> onCryptChanged;
  final ValueChanged<SellSort?> onSortChanged;
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
          DropdownButtonFormField<SellSort>(
            value: sort,
            decoration: const InputDecoration(
              labelText: '並び替え',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.sort),
            ),
            items: SellSort.values
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
