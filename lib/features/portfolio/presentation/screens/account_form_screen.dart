import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/account.dart';
import '../providers/account_provider.dart';

class AccountFormScreen extends ConsumerStatefulWidget {
  const AccountFormScreen({
    super.key,
    this.account,
  });

  final Account? account;

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _iconUrlController = TextEditingController();
  final _memoController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLocked = false;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.account != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _nameController.text = widget.account!.name;
      _iconUrlController.text = widget.account!.iconUrl ?? '';
      _memoController.text = widget.account!.memo ?? '';
      _isLocked = widget.account!.isLocked;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconUrlController.dispose();
    _memoController.dispose();
    _addressController.dispose();
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
      final notifier = ref.read(accountsListProvider.notifier);

      if (_isEditMode) {
        await notifier.update(
          widget.account!.id,
          name: _nameController.text.trim(),
          icon: _iconUrlController.text.trim().isEmpty
              ? null
              : _iconUrlController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('アカウントを更新しました')),
          );
          context.pop();
        }
      } else {
        await notifier.create(
          _nameController.text.trim(),
          _addressController.text.trim(),
          _iconUrlController.text.trim().isEmpty
              ? null
              : _iconUrlController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('アカウントを作成しました')),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'アカウント編集' : 'アカウント作成'),
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
                labelText: 'アカウント名',
                hintText: '例: メインウォレット',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'アカウント名を入力してください';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
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
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: 'メモ（任意）',
                hintText: '説明やメモを入力',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
              textInputAction: _isEditMode
                  ? TextInputAction.done
                  : TextInputAction.next,
            ),
            const SizedBox(height: 16),
            if (!_isEditMode) ...[
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'ウォレットアドレス',
                  hintText: '0x...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ウォレットアドレスを入力してください';
                  }
                  if (!value.startsWith('0x')) {
                    return 'ウォレットアドレスは0xで始まる必要があります';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),
            ],
            SwitchListTile(
              title: const Text('アカウントをロック'),
              subtitle: const Text('ロックされたアカウントは削除できません'),
              value: _isLocked,
              onChanged: (value) {
                setState(() {
                  _isLocked = value;
                });
              },
              secondary: const Icon(Icons.lock),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
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
              label: Text(_isEditMode ? '更新' : '作成'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
