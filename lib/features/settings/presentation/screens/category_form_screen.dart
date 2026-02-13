import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/crypt_category.dart';
import '../providers/category_provider.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  const CategoryFormScreen({
    super.key,
    this.categoryId,
    this.category,
  });

  final String? categoryId;
  final CryptCategory? category;

  @override
  ConsumerState<CategoryFormScreen> createState() =>
      _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _iconUrlController = TextEditingController();

  bool _isSubmitting = false;
  String _selectedColorHex = _colorOptions.first.hex;

  bool get _isEditMode => widget.categoryId != null;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    if (category != null) {
      _nameController.text = category.name;
      _iconUrlController.text = category.iconUrl ?? '';
      _selectedColorHex = _resolveInitialColor(category.color);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final notifier = ref.read(categoriesListProvider.notifier);
      final iconUrl =
          _iconUrlController.text.trim().isEmpty ? null : _iconUrlController.text.trim();

      if (_isEditMode) {
        await notifier.update(
          widget.categoryId!,
          name: _nameController.text.trim(),
          color: _selectedColorHex,
          iconUrl: iconUrl,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('カテゴリを更新しました')),
          );
          context.pop();
        }
      } else {
        await notifier.create(
          name: _nameController.text.trim(),
          color: _selectedColorHex,
          iconUrl: iconUrl,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('カテゴリを作成しました')),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラー: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _resolveInitialColor(String value) {
    final normalized = value.toLowerCase().replaceAll('#', '');
    for (final option in _colorOptions) {
      if (option.hex.toLowerCase().replaceAll('#', '') == normalized) {
        return option.hex;
      }
    }
    return value.startsWith('#') ? value : '#$value';
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditMode ? 'カテゴリ編集' : 'カテゴリ追加';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'カテゴリ名',
                hintText: '例: 長期保有',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'カテゴリ名を入力してください';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            const Text('カラー'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colorOptions.map((option) {
                final isSelected = _selectedColorHex == option.hex;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedColorHex = option.hex;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: option.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.outline,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _iconUrlController,
              decoration: const InputDecoration(
                labelText: 'アイコンURL（任意）',
                hintText: 'https://example.com/icon.png',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : () => context.pop(),
                    child: const Text('キャンセル'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _save,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: const Text('保存'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorOption {
  const _ColorOption({
    required this.hex,
    required this.color,
  });

  final String hex;
  final Color color;
}

const List<_ColorOption> _colorOptions = [
  _ColorOption(hex: '#E53935', color: Color(0xFFE53935)),
  _ColorOption(hex: '#FB8C00', color: Color(0xFFFB8C00)),
  _ColorOption(hex: '#FDD835', color: Color(0xFFFDD835)),
  _ColorOption(hex: '#43A047', color: Color(0xFF43A047)),
  _ColorOption(hex: '#1E88E5', color: Color(0xFF1E88E5)),
  _ColorOption(hex: '#3949AB', color: Color(0xFF3949AB)),
  _ColorOption(hex: '#8E24AA', color: Color(0xFF8E24AA)),
  _ColorOption(hex: '#6D4C41', color: Color(0xFF6D4C41)),
];
