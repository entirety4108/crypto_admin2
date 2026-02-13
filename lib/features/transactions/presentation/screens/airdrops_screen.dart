import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/purchase.dart';
import '../../domain/crypt.dart';
import '../../../portfolio/domain/account.dart';
import '../providers/airdrop_provider.dart';
import '../providers/purchase_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

enum AirdropSort {
  execAtDesc,
  execAtAsc,
  amountDesc,
  amountAsc,
  profitDesc,
  profitAsc,
}

extension AirdropSortLabel on AirdropSort {
  String label() {
    switch (this) {
      case AirdropSort.execAtDesc:
        return '実行日時（新しい順）';
      case AirdropSort.execAtAsc:
        return '実行日時（古い順）';
      case AirdropSort.amountDesc:
        return '数量（多い順）';
      case AirdropSort.amountAsc:
        return '数量（少ない順）';
      case AirdropSort.profitDesc:
        return '受取時価値（高い順）';
      case AirdropSort.profitAsc:
        return '受取時価値（低い順）';
    }
  }

  int compare(Purchase a, Purchase b) {
    final aProfit = a.airdropProfit ?? a.depositYen;
    final bProfit = b.airdropProfit ?? b.depositYen;
    switch (this) {
      case AirdropSort.execAtDesc:
        return b.execAt.compareTo(a.execAt);
      case AirdropSort.execAtAsc:
        return a.execAt.compareTo(b.execAt);
      case AirdropSort.amountDesc:
        return b.amount.compareTo(a.amount);
      case AirdropSort.amountAsc:
        return a.amount.compareTo(b.amount);
      case AirdropSort.profitDesc:
        return bProfit.compareTo(aProfit);
      case AirdropSort.profitAsc:
        return aProfit.compareTo(bProfit);
    }
  }
}

enum AirdropTypeFilter {
  all,
  airdrop,
  staking,
}

extension AirdropTypeFilterLabel on AirdropTypeFilter {
  String label() {
    switch (this) {
      case AirdropTypeFilter.all:
        return 'すべて';
      case AirdropTypeFilter.airdrop:
        return 'エアドロップ';
      case AirdropTypeFilter.staking:
        return 'ステーキング報酬';
    }
  }
}

enum _AirdropAction {
  edit,
  delete,
}

class AirdropsScreen extends ConsumerStatefulWidget {
  const AirdropsScreen({super.key});

  @override
  ConsumerState<AirdropsScreen> createState() => _AirdropsScreenState();
}

class _AirdropsScreenState extends ConsumerState<AirdropsScreen> {
  String? _selectedAccountId;
  String? _selectedCryptId;
  AirdropSort _sort = AirdropSort.execAtDesc;
  AirdropTypeFilter _typeFilter = AirdropTypeFilter.all;

  final _yenFormat = NumberFormat.currency(
    locale: 'ja_JP',
    symbol: '¥',
    decimalDigits: 0,
  );

  String _formatDate(DateTime value) {
    return DateFormat('yyyy/MM/dd HH:mm').format(value);
  }

  String _typeLabel(int? type) {
    switch (type) {
      case 1:
        return 'エアドロップ';
      case 2:
        return 'ステーキング報酬';
      default:
        return '不明';
    }
  }

  Color _typeColor(BuildContext context, int? type) {
    final colors = Theme.of(context).colorScheme;
    switch (type) {
      case 1:
        return colors.secondaryContainer;
      case 2:
        return colors.tertiaryContainer;
      default:
        return colors.surfaceVariant;
    }
  }

  Color _typeLabelColor(BuildContext context, int? type) {
    final colors = Theme.of(context).colorScheme;
    switch (type) {
      case 1:
        return colors.onSecondaryContainer;
      case 2:
        return colors.onTertiaryContainer;
      default:
        return colors.onSurfaceVariant;
    }
  }

  Widget _buildTypeBadge(BuildContext context, int? type) {
    return Chip(
      label: Text(_typeLabel(type)),
      labelStyle: TextStyle(color: _typeLabelColor(context, type)),
      backgroundColor: _typeColor(context, type),
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final airdropsAsync = ref.watch(airdropsListProvider);
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
        title: const Text('エアドロップ一覧'),
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
            typeFilter: _typeFilter,
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
            onTypeFilterChanged: (value) {
              setState(() {
                _typeFilter = value;
              });
            },
          ),
          Expanded(
            child: airdropsAsync.when(
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
                      'エアドロップの取得に失敗しました',
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
                        ref.read(airdropsListProvider.notifier).refresh();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('再読み込み'),
                    ),
                  ],
                ),
              ),
              data: (airdrops) {
                final filtered = airdrops
                    .where((purchase) => purchase.type == 'a')
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
                    .where((purchase) {
                      switch (_typeFilter) {
                        case AirdropTypeFilter.all:
                          return true;
                        case AirdropTypeFilter.airdrop:
                          return purchase.airdropType == 1;
                        case AirdropTypeFilter.staking:
                          return purchase.airdropType == 2;
                      }
                    })
                    .toList()
                  ..sort(_sort.compare);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 64,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'エアドロップがありません',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('右下のボタンから追加できます'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(airdropsListProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final purchase = filtered[index];
                      final account = accountMap[purchase.accountId];
                      final crypt = cryptMap[purchase.cryptId];
                      final profit = purchase.airdropProfit ?? purchase.depositYen;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: crypt?.iconUrl != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(crypt!.iconUrl!),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.currency_bitcoin),
                                ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${crypt?.symbol ?? '不明'}  ${purchase.amount}',
                                ),
                              ),
                              _buildTypeBadge(context, purchase.airdropType),
                            ],
                          ),
                          subtitle: Text(
                            'アカウント: ${account?.name ?? '不明'}\n'
                            '日時: ${_formatDate(purchase.execAt)}\n'
                            '受取時価値: ${_yenFormat.format(profit)}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<_AirdropAction>(
                            onSelected: (action) async {
                              if (action == _AirdropAction.edit) {
                                context.push(
                                  '/transactions/airdrops/edit',
                                  extra: purchase,
                                );
                                return;
                              }

                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('削除確認'),
                                  content: const Text('このエアドロップを削除しますか？'),
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
                                    .read(airdropsListProvider.notifier)
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
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  );
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: _AirdropAction.edit,
                                child: Text('編集'),
                              ),
                              const PopupMenuItem(
                                value: _AirdropAction.delete,
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
          context.push('/transactions/airdrops/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('エアドロップ追加'),
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
    required this.typeFilter,
    required this.onAccountChanged,
    required this.onCryptChanged,
    required this.onSortChanged,
    required this.onTypeFilterChanged,
    required this.isLoading,
  });

  final List<Account> accounts;
  final List<Crypt> crypts;
  final String? selectedAccountId;
  final String? selectedCryptId;
  final AirdropSort sort;
  final AirdropTypeFilter typeFilter;
  final ValueChanged<String?> onAccountChanged;
  final ValueChanged<String?> onCryptChanged;
  final ValueChanged<AirdropSort?> onSortChanged;
  final ValueChanged<AirdropTypeFilter> onTypeFilterChanged;
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
          Wrap(
            spacing: 8,
            children: AirdropTypeFilter.values
                .map(
                  (value) => ChoiceChip(
                    label: Text(value.label()),
                    selected: typeFilter == value,
                    onSelected: (_) => onTypeFilterChanged(value),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            value: selectedAccountId,
            decoration: const InputDecoration(
              labelText: 'アカウントフィルター',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_balance_wallet),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('すべてのアカウント'),
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
          DropdownButtonFormField<AirdropSort>(
            value: sort,
            decoration: const InputDecoration(
              labelText: '並び替え',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.sort),
            ),
            items: AirdropSort.values
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
