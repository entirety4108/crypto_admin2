import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/category_with_crypts.dart';
import '../../../transactions/domain/crypt.dart';
import '../../../transactions/presentation/providers/purchase_provider.dart';
import '../providers/category_provider.dart';

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryWithCryptsProvider(categoryId));
    final cryptsAsync = ref.watch(cryptsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('カテゴリ詳細'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/settings/categories/$categoryId/edit');
            },
            tooltip: '編集',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(categoryWithCryptsProvider(categoryId));
              ref.invalidate(categoryCryptCountProvider(categoryId));
            },
            tooltip: '再読み込み',
          ),
        ],
      ),
      body: categoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
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
              const Text('カテゴリの取得に失敗しました'),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  ref.invalidate(categoryWithCryptsProvider(categoryId));
                },
                icon: const Icon(Icons.refresh),
                label: const Text('再読み込み'),
              ),
            ],
          ),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(categoryWithCryptsProvider(categoryId));
            await ref.read(categoryWithCryptsProvider(categoryId).future);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _CategoryInfoCard(data: data),
              const SizedBox(height: 16),
              _AssignedCryptsSection(
                data: data,
                onRemove: (crypt) async {
                  await ref.read(categoriesListProvider.notifier).unassignCrypt(
                        cryptId: crypt.id,
                        categoryId: categoryId,
                      );
                  ref.invalidate(categoryWithCryptsProvider(categoryId));
                  ref.invalidate(categoryCryptCountProvider(categoryId));
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  final allCrypts = cryptsAsync.valueOrNull ?? const <Crypt>[];
                  final assignedIds = data.crypts.map((c) => c.id).toSet();
                  final available = allCrypts
                      .where((c) => !assignedIds.contains(c.id))
                      .toList();

                  if (available.isEmpty) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('追加できる通貨がありません')),
                      );
                    }
                    return;
                  }

                  final selected = await _showCryptSelector(
                    context,
                    available,
                  );

                  if (selected == null) {
                    return;
                  }

                  await ref.read(categoriesListProvider.notifier).assignCrypt(
                        cryptId: selected.id,
                        categoryId: categoryId,
                      );
                  ref.invalidate(categoryWithCryptsProvider(categoryId));
                  ref.invalidate(categoryCryptCountProvider(categoryId));
                },
                icon: const Icon(Icons.add),
                label: const Text('通貨を追加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryInfoCard extends StatelessWidget {
  const _CategoryInfoCard({required this.data});

  final CategoryWithCrypts data;

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(
      data.category.color,
      Theme.of(context).colorScheme.primary,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(width: 12),
            data.category.iconUrl != null
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(data.category.iconUrl!),
                  )
                : const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.category),
                  ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data.category.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssignedCryptsSection extends StatelessWidget {
  const _AssignedCryptsSection({
    required this.data,
    required this.onRemove,
  });

  final CategoryWithCrypts data;
  final Future<void> Function(Crypt crypt) onRemove;

  @override
  Widget build(BuildContext context) {
    if (data.crypts.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('割り当てられた通貨がありません'),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.crypts.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final crypt = data.crypts[index];
          return ListTile(
            leading: crypt.iconUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(crypt.iconUrl!),
                  )
                : const CircleAvatar(
                    child: Icon(Icons.currency_bitcoin),
                  ),
            title: Text(crypt.symbol),
            subtitle: crypt.projectName != null ? Text(crypt.projectName!) : null,
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: Theme.of(context).colorScheme.error,
              onPressed: () => onRemove(crypt),
              tooltip: '削除',
            ),
          );
        },
      ),
    );
  }
}

Future<Crypt?> _showCryptSelector(
  BuildContext context,
  List<Crypt> available,
) {
  return showDialog<Crypt>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('通貨を選択'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: available.length,
          itemBuilder: (context, index) {
            final crypt = available[index];
            return ListTile(
              leading: crypt.iconUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(crypt.iconUrl!),
                    )
                  : const CircleAvatar(
                      child: Icon(Icons.currency_bitcoin),
                    ),
              title: Text(crypt.symbol),
              subtitle:
                  crypt.projectName != null ? Text(crypt.projectName!) : null,
              onTap: () => Navigator.of(context).pop(crypt),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('キャンセル'),
        ),
      ],
    ),
  );
}

Color _parseColor(String value, Color fallback) {
  final normalized = value
      .toLowerCase()
      .replaceAll('#', '')
      .replaceAll('0x', '');

  if (normalized.length == 6) {
    return Color(int.parse('ff$normalized', radix: 16));
  }
  if (normalized.length == 8) {
    return Color(int.parse(normalized, radix: 16));
  }
  return fallback;
}
