import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/profit_loss_provider.dart';
import '../../domain/crypt_profit_loss.dart';
import '../../domain/account_profit_loss.dart';

enum ProfitLossSort {
  pnlDesc,
  pnlAsc,
  nameAsc,
}

extension ProfitLossSortLabel on ProfitLossSort {
  String label() {
    switch (this) {
      case ProfitLossSort.pnlDesc:
        return '損益（高い順）';
      case ProfitLossSort.pnlAsc:
        return '損益（低い順）';
      case ProfitLossSort.nameAsc:
        return '名前（昇順）';
    }
  }
}

class ProfitLossScreen extends ConsumerStatefulWidget {
  const ProfitLossScreen({super.key});

  @override
  ConsumerState<ProfitLossScreen> createState() => _ProfitLossScreenState();
}

class _ProfitLossScreenState extends ConsumerState<ProfitLossScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedYear;
  ProfitLossSort _sort = ProfitLossSort.pnlDesc;

  final _yenFormat = NumberFormat.currency(
    locale: 'ja_JP',
    symbol: '¥',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getProfitColor(double value) {
    if (value > 0) {
      return Colors.green.shade700;
    } else if (value < 0) {
      return Colors.red.shade700;
    }
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(profitLossSummaryProvider(_selectedYear));
    final cryptPnlAsync = ref.watch(cryptProfitLossListProvider(_selectedYear));
    final accountPnlAsync =
        ref.watch(accountProfitLossListProvider(_selectedYear));

    return Scaffold(
      appBar: AppBar(
        title: const Text('損益レポート'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(profitLossSummaryProvider);
              ref.invalidate(cryptProfitLossListProvider);
              ref.invalidate(accountProfitLossListProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profitLossSummaryProvider);
          ref.invalidate(cryptProfitLossListProvider);
          ref.invalidate(accountProfitLossListProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Year Filter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        value: _selectedYear,
                        decoration: const InputDecoration(
                          labelText: '年度',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('全期間')),
                          DropdownMenuItem(value: 2024, child: Text('2024年')),
                          DropdownMenuItem(value: 2025, child: Text('2025年')),
                          DropdownMenuItem(value: 2026, child: Text('2026年')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<ProfitLossSort>(
                        value: _sort,
                        decoration: const InputDecoration(
                          labelText: '並び替え',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.sort),
                        ),
                        items: ProfitLossSort.values
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value.label()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sort = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Summary Card
            SliverToBoxAdapter(
              child: summaryAsync.when(
                data: (summary) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '損益サマリー',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Divider(),
                          _buildSummaryRow(
                            '確定損益',
                            summary.totalRealizedPnl,
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            '評価損益',
                            summary.totalUnrealizedPnl,
                          ),
                          const Divider(),
                          _buildSummaryRow(
                            '合計損益',
                            summary.totalPnl,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'エラー: ${error.toString()}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Tab Bar
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  tabs: const [
                    Tab(text: '通貨別'),
                    Tab(text: 'アカウント別'),
                  ],
                ),
              ),
            ),

            // Tab Content
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // By Crypto
                  cryptPnlAsync.when(
                    data: (list) => _buildCryptList(list),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('エラー: ${error.toString()}'),
                    ),
                  ),
                  // By Account
                  accountPnlAsync.when(
                    data: (list) => _buildAccountList(list),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('エラー: ${error.toString()}'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isBold = false}) {
    final color = _getProfitColor(value);
    final textStyle = isBold
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            )
        : Theme.of(context).textTheme.bodyLarge?.copyWith(color: color);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)
              : null,
        ),
        Text(
          _yenFormat.format(value),
          style: textStyle,
        ),
      ],
    );
  }

  Widget _buildCryptList(List<CryptProfitLoss> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('データがありません'),
      );
    }

    // Sort
    final sorted = [...list];
    switch (_sort) {
      case ProfitLossSort.pnlDesc:
        sorted.sort((a, b) => b.totalPnl.compareTo(a.totalPnl));
        break;
      case ProfitLossSort.pnlAsc:
        sorted.sort((a, b) => a.totalPnl.compareTo(b.totalPnl));
        break;
      case ProfitLossSort.nameAsc:
        sorted.sort((a, b) => a.symbol.compareTo(b.symbol));
        break;
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final item = sorted[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: item.iconUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(item.iconUrl!),
                  )
                : const CircleAvatar(
                    child: Icon(Icons.currency_bitcoin),
                  ),
            title: Text(
              item.symbol,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('確定: ${_yenFormat.format(item.realizedPnl)}'),
                Text('評価: ${_yenFormat.format(item.unrealizedPnl)}'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('合計', style: TextStyle(fontSize: 12)),
                Text(
                  _yenFormat.format(item.totalPnl),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _getProfitColor(item.totalPnl),
                  ),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildAccountList(List<AccountProfitLoss> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('データがありません'),
      );
    }

    // Sort
    final sorted = [...list];
    switch (_sort) {
      case ProfitLossSort.pnlDesc:
        sorted.sort((a, b) => b.totalPnl.compareTo(a.totalPnl));
        break;
      case ProfitLossSort.pnlAsc:
        sorted.sort((a, b) => a.totalPnl.compareTo(b.totalPnl));
        break;
      case ProfitLossSort.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final item = sorted[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.account_balance_wallet),
            ),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('確定: ${_yenFormat.format(item.realizedPnl)}'),
                Text('評価: ${_yenFormat.format(item.unrealizedPnl)}'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('合計', style: TextStyle(fontSize: 12)),
                Text(
                  _yenFormat.format(item.totalPnl),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _getProfitColor(item.totalPnl),
                  ),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
