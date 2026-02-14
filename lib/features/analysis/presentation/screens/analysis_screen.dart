import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_admin/l10n/app_localizations.dart';

/// Analysis screen
class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analysis),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('損益レポート'),
              subtitle: const Text('確定損益・評価損益の確認'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/analysis/profit-loss'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('残高履歴'),
              subtitle: const Text('日次残高の推移'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/analysis/balance-history'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('税務レポート'),
              subtitle: const Text('年度別確定損益集計'),
              trailing: const Icon(Icons.chevron_right),
              enabled: false,
              onTap: () {
                // TODO: Implement in Phase 4 Step 3
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.candlestick_chart),
              title: const Text('価格チャート'),
              subtitle: const Text('テクニカル分析'),
              trailing: const Icon(Icons.chevron_right),
              enabled: false,
              onTap: () {
                // TODO: Implement in Phase 4 Step 4-5
              },
            ),
          ),
        ],
      ),
    );
  }
}
