import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/purchase.dart';
import '../providers/airdrop_provider.dart';
import '../providers/purchase_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

class AirdropFormScreen extends ConsumerStatefulWidget {
  const AirdropFormScreen({
    super.key,
    this.purchase,
  });

  final Purchase? purchase;

  @override
  ConsumerState<AirdropFormScreen> createState() => _AirdropFormScreenState();
}

class _AirdropFormScreenState extends ConsumerState<AirdropFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _unitYenController = TextEditingController();
  final _amountController = TextEditingController();
  final _airdropProfitController = TextEditingController();

  DateTime _execAt = DateTime.now();
  String? _selectedAccountId;
  String? _selectedCryptId;
  int _airdropType = 1;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.purchase != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      final purchase = widget.purchase!;
      _execAt = purchase.execAt;
      _selectedAccountId = purchase.accountId;
      _selectedCryptId = purchase.cryptId;
      _airdropType = purchase.airdropType ?? 1;

      _unitYenController.text = purchase.unitYen.toString();
      _amountController.text = purchase.amount.toString();
      final profit = purchase.airdropProfit ?? purchase.depositYen;
      _airdropProfitController.text = profit.toStringAsFixed(0);
    } else {
      _airdropProfitController.text = '0';
    }
  }

  @override
  void dispose() {
    _unitYenController.dispose();
    _amountController.dispose();
    _airdropProfitController.dispose();
    super.dispose();
  }

  double? _parseDouble(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    return double.tryParse(normalized);
  }

  String _formatDate(DateTime value) {
    return DateFormat('yyyy/MM/dd HH:mm').format(value);
  }

  Future<void> _pickExecAt() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _execAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_execAt),
    );
    if (time == null) {
      return;
    }

    setState(() {
      _execAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAccountId == null || _selectedCryptId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('アカウントと暗号資産を選択してください')),
      );
      return;
    }

    final unitYen = _parseDouble(_unitYenController.text);
    final amount = _parseDouble(_amountController.text);
    final airdropProfit = _parseDouble(_airdropProfitController.text);

    if (unitYen == null || amount == null || airdropProfit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('数値を正しく入力してください')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final notifier = ref.read(airdropsListProvider.notifier);

      if (_isEditMode) {
        await notifier.update(
          widget.purchase!.id,
          execAt: _execAt,
          unitYen: unitYen,
          amount: amount,
          airdropType: _airdropType,
          airdropProfit: airdropProfit,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('エアドロップを更新しました')),
          );
          context.pop();
        }
      } else {
        await notifier.create(
          accountId: _selectedAccountId!,
          cryptId: _selectedCryptId!,
          execAt: _execAt,
          unitYen: unitYen,
          amount: amount,
          airdropType: _airdropType,
          airdropProfit: airdropProfit,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('エアドロップを追加しました')),
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
    final accountsAsync = ref.watch(accountsListProvider);
    final cryptsAsync = ref.watch(cryptsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'エアドロップ編集' : 'エアドロップ追加'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InputDecorator(
              decoration: const InputDecoration(
                labelText: '実行日時',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event),
              ),
              child: InkWell(
                onTap: _pickExecAt,
                child: Row(
                  children: [
                    Expanded(child: Text(_formatDate(_execAt))),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            accountsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => Text(
                'アカウントの取得に失敗しました: ${error.toString()}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (accounts) {
                return DropdownButtonFormField<String>(
                  value: _selectedAccountId,
                  decoration: const InputDecoration(
                    labelText: 'アカウント',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance_wallet),
                  ),
                  items: accounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(account.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'アカウントを選択してください';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            cryptsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => Text(
                '暗号資産の取得に失敗しました: ${error.toString()}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (crypts) {
                return DropdownButtonFormField<String>(
                  value: _selectedCryptId,
                  decoration: const InputDecoration(
                    labelText: '暗号資産',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.currency_bitcoin),
                  ),
                  items: crypts
                      .map(
                        (crypt) => DropdownMenuItem(
                          value: crypt.id,
                          child: Text(crypt.symbol),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCryptId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '暗号資産を選択してください';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _unitYenController,
              decoration: const InputDecoration(
                labelText: '単価（円）',
                hintText: '例: 4500000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.price_change),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final parsed = _parseDouble(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return '単価を正しく入力してください';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: '数量',
                hintText: '例: 0.5',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.toll),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final parsed = _parseDouble(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return '数量を正しく入力してください';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: '種類',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              child: Column(
                children: [
                  RadioListTile<int>(
                    value: 1,
                    groupValue: _airdropType,
                    onChanged: (value) {
                      setState(() {
                        _airdropType = value ?? 1;
                      });
                    },
                    title: const Text('エアドロップ'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  RadioListTile<int>(
                    value: 2,
                    groupValue: _airdropType,
                    onChanged: (value) {
                      setState(() {
                        _airdropType = value ?? 2;
                      });
                    },
                    title: const Text('ステーキング報酬'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _airdropProfitController,
              decoration: const InputDecoration(
                labelText: '受取時価値（円）',
                hintText: '例: 120000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payments),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final parsed = _parseDouble(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return '受取時価値を正しく入力してください';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),
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
              label: Text(_isEditMode ? '更新' : '追加'),
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
