import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/crypt_category.dart';
import '../providers/category_provider.dart';

enum _CategoryAction {
  edit,
  delete,
}

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('カテゴリ管理'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: categoriesAsync.when(
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
                  ref.read(categoriesListProvider.notifier).refresh();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('再読み込み'),
              ),
            ],
          ),
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(
              child: Text('カテゴリがありません'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(categoriesListProvider.notifier).refresh();
            },
            child: ListView.builder(
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _CategoryListTile(category: category);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/settings/categories/new'),
        icon: const Icon(Icons.add),
        label: const Text('カテゴリ追加'),
      ),
    );
  }
}

class _CategoryListTile extends ConsumerWidget {
  const _CategoryListTile({required this.category});

  final CryptCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(categoryCryptCountProvider(category.id));
    final color = _parseColor(
      category.color,
      Theme.of(context).colorScheme.primary,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            category.iconUrl != null
                ? CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(category.iconUrl!),
                  )
                : const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.category, size: 16),
                  ),
          ],
        ),
        title: Text(category.name),
        subtitle: countAsync.when(
          loading: () => const Text('割り当て: ...'),
          error: (_, __) => const Text('割り当て: -'),
          data: (count) => Text('割り当て: $count'),
        ),
        trailing: PopupMenuButton<_CategoryAction>(
          onSelected: (action) async {
            if (action == _CategoryAction.edit) {
              context.push(
                '/settings/categories/${category.id}/edit',
                extra: category,
              );
              return;
            }

            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('削除確認'),
                content: Text('「${category.name}」を削除しますか？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('キャンセル'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text('削除'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              await ref.read(categoriesListProvider.notifier).delete(
                    category.id,
                  );
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _CategoryAction.edit,
              child: Text('編集'),
            ),
            PopupMenuItem(
              value: _CategoryAction.delete,
              child: Text('削除'),
            ),
          ],
        ),
        onTap: () {
          context.push('/settings/categories/${category.id}');
        },
      ),
    );
  }
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
