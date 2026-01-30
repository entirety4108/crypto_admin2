import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/locale_provider.dart';

/// Settings screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Language section
          _buildSectionHeader(context, l10n.language),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(
              currentLocale.languageCode == 'ja' ? l10n.japanese : l10n.english,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref, currentLocale),
          ),
          const Divider(),

          // Account management section
          _buildSectionHeader(context, l10n.accounts),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(l10n.accounts),
            subtitle: Text('Coming in Phase 3'),
            trailing: const Icon(Icons.chevron_right),
            enabled: false,
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: Text(l10n.categories),
            subtitle: Text('Coming in Phase 3'),
            trailing: const Icon(Icons.chevron_right),
            enabled: false,
          ),
          const Divider(),

          // Logout section
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              l10n.logout,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: Text(l10n.japanese),
              value: const Locale('ja'),
              groupValue: currentLocale,
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<Locale>(
              title: Text(l10n.english),
              value: const Locale('en'),
              groupValue: currentLocale,
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authStateProvider.notifier).signOut();
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
