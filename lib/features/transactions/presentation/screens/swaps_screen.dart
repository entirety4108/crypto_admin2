import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/crypt.dart';
import '../../../portfolio/domain/account.dart';
import '../providers/purchase_provider.dart';
import '../providers/swap_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

enum SwapSort { execAtDesc, execAtAsc, profitDesc, profitAsc }

enum _SwapAction { edit, delete }

class SwapsScreen extends ConsumerStatefulWidget {
  const SwapsScreen({super.key});

  @override
  ConsumerState<SwapsScreen> createState() => _SwapsScreenState();
}

class _SwapsScreenState extends ConsumerState<SwapsScreen> {
  String? _accountId;
  String? _sellCryptId;
  String? _buyCryptId;
  SwapSort _sort = SwapSort.execAtDesc;

  final _yenFormat = NumberFormat.currency(
    locale: 'ja_JP',
    symbol: '¥',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final swapsAsync = ref.watch(swapsListProvider);
    final accounts = ref.watch(accountsListProvider).valueOrNull ?? const <Account>[];
    final crypts = ref.watch(cryptsListProvider).valueOrNull ?? const <Crypt>[];

    final accountMap = {for (final item in accounts) item.id: item};
    final cryptMap = {for (final item in crypts) item.id: item};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swaps'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                DropdownButtonFormField<String?>(
                  value: _accountId,
                  decoration: const InputDecoration(
                    labelText: 'Account Filter',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Accounts')),
                    ...accounts.map(
                      (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
                    ),
                  ],
                  onChanged: (value) => setState(() => _accountId = value),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  value: _sellCryptId,
                  decoration: const InputDecoration(
                    labelText: 'Sell Crypt Filter',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Sell Crypts')),
                    ...crypts.map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.symbol)),
                    ),
                  ],
                  onChanged: (value) => setState(() => _sellCryptId = value),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  value: _buyCryptId,
                  decoration: const InputDecoration(
                    labelText: 'Buy Crypt Filter',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Buy Crypts')),
                    ...crypts.map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.symbol)),
                    ),
                  ],
                  onChanged: (value) => setState(() => _buyCryptId = value),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<SwapSort>(
                  value: _sort,
                  decoration: const InputDecoration(
                    labelText: 'Sort',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: SwapSort.execAtDesc, child: Text('Exec At Desc')),
                    DropdownMenuItem(value: SwapSort.execAtAsc, child: Text('Exec At Asc')),
                    DropdownMenuItem(value: SwapSort.profitDesc, child: Text('Profit Desc')),
                    DropdownMenuItem(value: SwapSort.profitAsc, child: Text('Profit Asc')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sort = value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: swapsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Failed to load swaps: $error')),
              data: (items) {
                final list = items.where((item) {
                  if (_accountId != null && item.accountId != _accountId) return false;
                  if (_sellCryptId != null && item.sellCryptId != _sellCryptId) return false;
                  if (_buyCryptId != null && item.buyCryptId != _buyCryptId) return false;
                  return true;
                }).toList();

                list.sort((a, b) {
                  switch (_sort) {
                    case SwapSort.execAtDesc:
                      return b.execAt.compareTo(a.execAt);
                    case SwapSort.execAtAsc:
                      return a.execAt.compareTo(b.execAt);
                    case SwapSort.profitDesc:
                      return b.profit.compareTo(a.profit);
                    case SwapSort.profitAsc:
                      return a.profit.compareTo(b.profit);
                  }
                });

                if (list.isEmpty) {
                  return const Center(child: Text('No swaps found.'));
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(swapsListProvider.notifier).refresh(),
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final account = accountMap[item.accountId];
                      final sellCrypt = cryptMap[item.sellCryptId];
                      final buyCrypt = cryptMap[item.buyCryptId];
                      final profitColor =
                          item.profit >= 0 ? Colors.green : Colors.red;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(
                            '${sellCrypt?.symbol ?? 'N/A'} ${item.sell.amount}'
                            ' -> ${buyCrypt?.symbol ?? 'N/A'} ${item.buy.amount}',
                          ),
                          subtitle: Text(
                            '${DateFormat('yyyy/MM/dd HH:mm').format(item.execAt)}\n'
                            'Account: ${account?.name ?? 'N/A'}\n'
                            'Profit: ${_yenFormat.format(item.profit)}',
                          ),
                          trailing: PopupMenuButton<_SwapAction>(
                            onSelected: (action) async {
                              if (action == _SwapAction.edit) {
                                context.push('/transactions/swaps/edit', extra: item);
                                return;
                              }
                              final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete'),
                                      content: const Text('Delete this swap?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        FilledButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                              if (!confirmed) return;
                              await ref
                                  .read(swapsListProvider.notifier)
                                  .deleteSwap(item.swap.id);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: _SwapAction.edit,
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: _SwapAction.delete,
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          textColor: profitColor,
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
        onPressed: () => context.push('/transactions/swaps/new'),
        icon: const Icon(Icons.swap_horiz),
        label: const Text('New Swap'),
      ),
    );
  }
}
