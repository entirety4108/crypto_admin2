import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/portfolio_provider.dart';
import '../../domain/crypt_holding.dart';
import '../../domain/account_holding.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _touchedIndex = -1;

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

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(portfolioSummaryProvider);
    final cryptHoldingsAsync = ref.watch(cryptHoldingsProvider);
    final accountHoldingsAsync = ref.watch(accountHoldingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ポートフォリオ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(portfolioSummaryProvider);
              ref.invalidate(cryptHoldingsProvider);
              ref.invalidate(accountHoldingsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(portfolioSummaryProvider);
          ref.invalidate(cryptHoldingsProvider);
          ref.invalidate(accountHoldingsProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Summary Card
            SliverToBoxAdapter(
              child: summaryAsync.when(
                data: (summary) => _buildSummaryCard(context, summary),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => _buildErrorCard(context, error),
              ),
            ),

            // Pie Chart
            SliverToBoxAdapter(
              child: cryptHoldingsAsync.when(
                data: (holdings) =>
                    holdings.isNotEmpty ? _buildPieChart(context, holdings) : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

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
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: '通貨別'),
                    Tab(text: 'アカウント別'),
                  ],
                ),
              ),
            ),

            // Holdings List
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // By Crypto
                  cryptHoldingsAsync.when(
                    data: (holdings) => _buildCryptHoldingsList(context, holdings),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => _buildErrorWidget(context, error),
                  ),

                  // By Account
                  accountHoldingsAsync.when(
                    data: (holdings) => _buildAccountHoldingsList(context, holdings),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => _buildErrorWidget(context, error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, dynamic summary) {
    final currencyFormat = NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0);
    final percentFormat = NumberFormat.decimalPattern('ja_JP')..maximumFractionDigits = 2;

    final totalValue = summary.totalValueJpy;
    final totalProfitLoss = summary.totalProfitLossJpy;
    final profitLossPercentage = summary.profitLossPercentage;

    final isProfit = totalProfitLoss > 0;
    final profitLossColor = totalProfitLoss > 0
        ? Colors.green
        : totalProfitLoss < 0
            ? Colors.red
            : Colors.grey;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '総資産額',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(totalValue),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '損益',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${isProfit ? '+' : ''}${currencyFormat.format(totalProfitLoss)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: profitLossColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: profitLossColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${isProfit ? '+' : ''}${percentFormat.format(profitLossPercentage)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: profitLossColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, List<CryptHolding> holdings) {
    if (holdings.isEmpty) return const SizedBox.shrink();

    // Take top 5 and group rest as "その他"
    final displayHoldings = holdings.take(5).toList();
    final restValue = holdings.skip(5).fold<double>(0, (sum, h) => sum + h.valueJpy);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '保有資産の構成',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _buildPieChartSections(displayHoldings, restValue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildPieChartLegend(displayHoldings, restValue),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    List<CryptHolding> holdings,
    double restValue,
  ) {
    final totalValue = holdings.fold<double>(0, (sum, h) => sum + h.valueJpy) + restValue;

    final List<PieChartSectionData> sections = [];

    for (int i = 0; i < holdings.length; i++) {
      final holding = holdings[i];
      final percentage = (holding.valueJpy / totalValue) * 100;
      final isTouched = i == _touchedIndex;

      sections.add(
        PieChartSectionData(
          color: _getColorForIndex(i),
          value: holding.valueJpy,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: isTouched ? 60 : 50,
          titleStyle: TextStyle(
            fontSize: isTouched ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    if (restValue > 0) {
      final percentage = (restValue / totalValue) * 100;
      final isTouched = holdings.length == _touchedIndex;

      sections.add(
        PieChartSectionData(
          color: Colors.grey,
          value: restValue,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: isTouched ? 60 : 50,
          titleStyle: TextStyle(
            fontSize: isTouched ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }

  Widget _buildPieChartLegend(List<CryptHolding> holdings, double restValue) {
    final items = <Widget>[];

    for (int i = 0; i < holdings.length; i++) {
      final holding = holdings[i];
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getColorForIndex(i),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                holding.symbol,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    if (restValue > 0) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'その他',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items,
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  Widget _buildCryptHoldingsList(BuildContext context, List<CryptHolding> holdings) {
    if (holdings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              '保有資産がありません',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: holdings.length,
      itemBuilder: (context, index) {
        final holding = holdings[index];
        return _buildCryptHoldingCard(context, holding);
      },
    );
  }

  Widget _buildCryptHoldingCard(BuildContext context, CryptHolding holding) {
    final currencyFormat = NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0);
    final amountFormat = NumberFormat.decimalPattern('ja_JP')..maximumFractionDigits = 8;
    final percentFormat = NumberFormat.decimalPattern('ja_JP')..maximumFractionDigits = 2;

    final isProfit = holding.profitLossJpy > 0;
    final profitLossColor = holding.profitLossJpy > 0
        ? Colors.green
        : holding.profitLossJpy < 0
            ? Colors.red
            : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to detail screen
          // context.push('/portfolio/crypto/${holding.cryptId}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon placeholder
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        holding.symbol[0],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          holding.symbol,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          holding.name,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormat.format(holding.valueJpy),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${isProfit ? '+' : ''}${currencyFormat.format(holding.profitLossJpy)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: profitLossColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '保有量',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        amountFormat.format(holding.amount),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '平均取得単価',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        currencyFormat.format(holding.avgCostBasisJpy),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '現在価格',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        currencyFormat.format(holding.currentPriceJpy),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: profitLossColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${isProfit ? '+' : ''}${percentFormat.format(holding.profitLossPercentage)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: profitLossColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountHoldingsList(BuildContext context, List<AccountHolding> holdings) {
    if (holdings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'アカウントがありません',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: holdings.length,
      itemBuilder: (context, index) {
        final holding = holdings[index];
        return _buildAccountHoldingCard(context, holding);
      },
    );
  }

  Widget _buildAccountHoldingCard(BuildContext context, AccountHolding holding) {
    final currencyFormat = NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0);

    final isProfit = holding.totalProfitLossJpy > 0;
    final profitLossColor = holding.totalProfitLossJpy > 0
        ? Colors.green
        : holding.totalProfitLossJpy < 0
            ? Colors.red
            : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              holding.name[0],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        title: Text(
          holding.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          '${holding.holdings.length}種類の通貨',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(holding.totalValueJpy),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${isProfit ? '+' : ''}${currencyFormat.format(holding.totalProfitLossJpy)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: profitLossColor,
                  ),
            ),
          ],
        ),
        children: holding.holdings.map((cryptHolding) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  cryptHolding.symbol[0],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            title: Text(
              cryptHolding.symbol,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              NumberFormat.decimalPattern('ja_JP').format(cryptHolding.amount),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(cryptHolding.valueJpy),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${cryptHolding.profitLossJpy > 0 ? '+' : ''}${currencyFormat.format(cryptHolding.profitLossJpy)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cryptHolding.profitLossJpy > 0
                            ? Colors.green
                            : cryptHolding.profitLossJpy < 0
                                ? Colors.red
                                : Colors.grey,
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, Object error) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'データの読み込みに失敗しました',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object error) {
    return Center(
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
            'エラーが発生しました',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
