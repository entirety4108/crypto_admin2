import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/transfer.dart';
import '../../domain/crypt.dart';
import '../../../portfolio/domain/account.dart';
import '../providers/transfer_provider.dart';
import '../providers/purchase_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

enum TransferSort {
  execAtDesc,
  execAtAsc,
  amountDesc,
  amountAsc,
  feeDesc,
  feeAsc,
}

extension TransferSortLabel on TransferSort {
  String label() {
    switch (this) {
      case TransferSort.execAtDesc:
        return '実行日時(新しい順)';
      case TransferSort.execAtAsc:
        return '実行日時(古い順)';
      case TransferSort.amountDesc:
        return '数量(多い順)';
      case TransferSort.amountAsc:
        return '数量(少ない順)';
      case TransferSort.feeDesc:
        return '手数料(多い順)';
      case TransferSort.feeAsc:
        return '手数料(少ない順)';
    }
  }

  int compare(Transfer a, Transfer b) {
    switch (this) {
      case TransferSort.execAtDesc:
        return b.execAt.compareTo(a.execAt);
      case TransferSort.execAtAsc:
        return a.execAt.compareTo(b.execAt);
      case TransferSort.amountDesc:
        return b.amount.compareTo(a.amount);
      case TransferSort.amountAsc:
        return a.amount.compareTo(b.amount);
      case TransferSort.feeDesc:
        final feeA = a.feeAmount ?? 0.0;
        final feeB = b.feeAmount ?? 0.0;
        return feeB.compareTo(feeA);
      case TransferSort.feeAsc:
        final feeA = a.feeAmount ?? 0.0;
        final feeB = b.feeAmount ?? 0.0;
        return feeA.compareTo(feeB);
    }
  }
}

enum _TransferAction {
  edit,
  delete,
}

class TransfersScreen extends ConsumerStatefulWidget {
  const TransfersScreen({super.key});

  @override
  ConsumerState<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends ConsumerState<TransfersScreen> {
  String? _selectedFromAccountId;
  String? _selectedToAccountId;
  String? _selectedCryptId;
  TransferSort _sort = TransferSort.execAtDesc;

  String _formatDate(DateTime value) {
    return DateFormat('yyyy/MM/dd HH:mm').format(value);
  }

  String _formatAmount(double value) {
    return value.toStringAsFixed(8);
  }

  @override
  Widget build(BuildContext context) {
    final transfersAsync = ref.watch(transfersListProvider);
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
        title: const Text('送付一覧'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _FiltersSection(
            accounts: accounts,
            crypts: crypts,
            selectedFromAccountId: _selectedFromAccountId,
            selectedToAccountId: _selectedToAccountId,
            selectedCryptId: _selectedCryptId,
            sort: _sort,
            isLoading: accountsAsync.isLoading || cryptsAsync.isLoading,
            onFromAccountChanged: (value) {
              setState(() {
                _selectedFromAccountId = value;
              });
            },
            onToAccountChanged: (value) {
              setState(() {
                _selectedToAccountId = value;
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
            child: transfersAsync.when(
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
                      '送付の取得に失敗しました',
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
                        ref.read(transfersListProvider.notifier).refresh();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('再読み込み'),
                    ),
                  ],
                ),
              ),
              data: (transfers) {
                final filtered = transfers
                    .where((transfer) {
                      if (_selectedFromAccountId == null) {
                        return true;
                      }
                      return transfer.fromAccountId == _selectedFromAccountId;
                    })
                    .where((transfer) {
                      if (_selectedToAccountId == null) {
                        return true;
                      }
                      return transfer.toAccountId == _selectedToAccountId;
                    })
                    .where((transfer) {
                      if (_selectedCryptId == null) {
                        return true;
                      }
                      return transfer.cryptId == _selectedCryptId;
                    })
                    .toList()
                  ..sort(_sort.compare);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swap_horiz,
                          size: 64,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '送付がありません',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('右下のボタンから送付を登録できます'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(transfersListProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final transfer = filtered[index];
                      final fromAccount = accountMap[transfer.fromAccountId];
                      final toAccount = accountMap[transfer.toAccountId];
                      final crypt = cryptMap[transfer.cryptId];
                      final feeCrypt = transfer.feeCryptId != null
                          ? cryptMap[transfer.feeCryptId!]
                          : null;

                      final feeText = transfer.feeAmount != null &&
                              transfer.feeAmount! > 0
                          ? '${_formatAmount(transfer.feeAmount!)} ${feeCrypt?.symbol ?? ''}'
                          : 'なし';

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
                            '${crypt?.symbol ?? '不明'}  ${_formatAmount(transfer.amount)}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('送付元: ${fromAccount?.name ?? '不明'}'),
                              Text('送付先: ${toAccount?.name ?? '不明'}'),
                              Text('実行日時: ${_formatDate(transfer.execAt)}'),
                              Text('手数料: $feeText'),
                              if (transfer.memo != null &&
                                  transfer.memo!.trim().isNotEmpty)
                                Text('メモ: ${transfer.memo}'),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<_TransferAction>(
                            onSelected: (action) async {
                              if (action == _TransferAction.edit) {
                                context.push(
                                  '/transactions/transfers/edit',
                                  extra: transfer,
                                );
                                return;
                              }

                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('削除確認'),
                                  content: const Text('この送付を削除しますか?'),
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
                                    .read(transfersListProvider.notifier)
                                    .delete(transfer.id);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('削除しました')),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '削除に失敗しました: ${e.toString()}'),
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
                                value: _TransferAction.edit,
                                child: Text('編集'),
                              ),
                              const PopupMenuItem(
                                value: _TransferAction.delete,
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
          context.push('/transactions/transfers/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('送付を追加'),
      ),
    );
  }
}

class _FiltersSection extends StatelessWidget {
  const _FiltersSection({
    required this.accounts,
    required this.crypts,
    required this.selectedFromAccountId,
    required this.selectedToAccountId,
    required this.selectedCryptId,
    required this.sort,
    required this.onFromAccountChanged,
    required this.onToAccountChanged,
    required this.onCryptChanged,
    required this.onSortChanged,
    required this.isLoading,
  });

  final List<Account> accounts;
  final List<Crypt> crypts;
  final String? selectedFromAccountId;
  final String? selectedToAccountId;
  final String? selectedCryptId;
  final TransferSort sort;
  final ValueChanged<String?> onFromAccountChanged;
  final ValueChanged<String?> onToAccountChanged;
  final ValueChanged<String?> onCryptChanged;
  final ValueChanged<TransferSort?> onSortChanged;
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
            value: selectedFromAccountId,
            decoration: const InputDecoration(
              labelText: '送付元口座フィルター',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_balance_wallet),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('すべての送付元'),
              ),
              ...accounts.map(
                (account) => DropdownMenuItem(
                  value: account.id,
                  child: Text(account.name),
                ),
              ),
            ],
            onChanged: onFromAccountChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            value: selectedToAccountId,
            decoration: const InputDecoration(
              labelText: '送付先口座フィルター',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_balance),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('すべての送付先'),
              ),
              ...accounts.map(
                (account) => DropdownMenuItem(
                  value: account.id,
                  child: Text(account.name),
                ),
              ),
            ],
            onChanged: onToAccountChanged,
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
          DropdownButtonFormField<TransferSort>(
            value: sort,
            decoration: const InputDecoration(
              labelText: '並び替え',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.sort),
            ),
            items: TransferSort.values
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
