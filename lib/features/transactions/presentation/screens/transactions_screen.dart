import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_admin/l10n/app_localizations.dart';

/// Transactions screen
class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transactions),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('入金一覧'),
              subtitle: const Text('暗号資産の購入・預入を管理'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/transactions/deposits'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text('売却一覧'),
              subtitle: const Text('暗号資産の売却を管理'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/transactions/sells'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('送付一覧'),
              subtitle: const Text('口座間の暗号資産送付を管理'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/transactions/transfers'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.currency_exchange),
              title: const Text('スワップ一覧'),
              subtitle: const Text('暗号資産の交換取引を管理'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/transactions/swaps'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('エアドロップ一覧'),
              subtitle: const Text('エアドロップとステーキング報酬を管理'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/transactions/airdrops'),
            ),
          ),
        ],
      ),
    );
  }
}
