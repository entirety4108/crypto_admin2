import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/daily_balance_provider.dart';
import '../../../transactions/presentation/providers/purchase_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

class BalanceHistoryScreen extends ConsumerStatefulWidget {
  const BalanceHistoryScreen({super.key});

  @override
  ConsumerState<BalanceHistoryScreen> createState() =>
      _BalanceHistoryScreenState();
}

class _BalanceHistoryScreenState extends ConsumerState<BalanceHistoryScreen> {
  String? _selectedCryptId;
  String? _selectedAccountId;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  final _yenFormat = NumberFormat.currency(
    locale: 'ja_JP',
    symbol: '¥',
    decimalDigits: 0,
  );

  final _dateFormat = DateFormat('MM/dd');

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final balancesAsync = ref.watch(aggregatedBalancesProvider(
      cryptId: _selectedCryptId,
      accountId: _selectedAccountId,
      startDate: _startDate,
      endDate: _endDate,
    ));

    final cryptsAsync = ref.watch(cryptsListProvider);
    final accountsAsync = ref.watch(accountsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('残高履歴'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(aggregatedBalancesProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(aggregatedBalancesProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Filters
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Date Range
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          '${_dateFormat.format(_startDate)} - ${_dateFormat.format(_endDate)}',
                        ),
                        subtitle: const Text('期間選択'),
                        trailing: const Icon(Icons.edit),
                        onTap: _selectDateRange,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Crypto Filter
                    cryptsAsync.when(
                      data: (crypts) => DropdownButtonFormField<String?>(
                        value: _selectedCryptId,
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
                        onChanged: (value) {
                          setState(() {
                            _selectedCryptId = value;
                          });
                        },
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 12),
                    // Account Filter
                    accountsAsync.when(
                      data: (accounts) => DropdownButtonFormField<String?>(
                        value: _selectedAccountId,
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
                        onChanged: (value) {
                          setState(() {
                            _selectedAccountId = value;
                          });
                        },
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            // Chart
            SliverToBoxAdapter(
              child: balancesAsync.when(
                data: (balances) {
                  if (balances.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(64),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.show_chart, size: 64),
                            SizedBox(height: 16),
                            Text('データがありません'),
                            SizedBox(height: 8),
                            Text(
                              '日次残高の更新を待つか、期間を変更してください',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return _buildChart(balances);
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(64),
                  child: Center(child: CircularProgressIndicator()),
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
          ],
        ),
      ),
    );
  }

  Widget _buildChart(Map<DateTime, double> balances) {
    final sortedEntries = balances.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final spots = <FlSpot>[];
    for (var i = 0; i < sortedEntries.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedEntries[i].value));
    }

    final maxY = sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minY = sortedEntries.map((e) => e.value).reduce((a, b) => a < b ? a : b);

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: (maxY - minY) / 5,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sortedEntries.length) {
                    return const Text('');
                  }
                  if (index % (sortedEntries.length ~/ 5).clamp(1, 10) == 0 ||
                      index == sortedEntries.length - 1) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _dateFormat.format(sortedEntries[index].key),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _yenFormat.format(value),
                    style: const TextStyle(fontSize: 10),
                  );
                },
                reservedSize: 70,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          minX: 0,
          maxX: (sortedEntries.length - 1).toDouble(),
          minY: minY * 0.9,
          maxY: maxY * 1.1,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  if (index < 0 || index >= sortedEntries.length) {
                    return null;
                  }
                  final entry = sortedEntries[index];
                  return LineTooltipItem(
                    '${_dateFormat.format(entry.key)}\n${_yenFormat.format(entry.value)}',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
