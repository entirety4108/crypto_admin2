import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/transfer.dart';
import '../providers/transfer_provider.dart';
import '../providers/purchase_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

class TransferFormScreen extends ConsumerStatefulWidget {
  const TransferFormScreen({
    super.key,
    this.transfer,
  });

  final Transfer? transfer;

  @override
  ConsumerState<TransferFormScreen> createState() =>
      _TransferFormScreenState();
}

class _TransferFormScreenState extends ConsumerState<TransferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _feeAmountController = TextEditingController();
  final _memoController = TextEditingController();

  DateTime _execAt = DateTime.now();
  String? _selectedFromAccountId;
  String? _selectedToAccountId;
  String? _selectedCryptId;
  String? _selectedFeeCryptId;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.transfer != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      final transfer = widget.transfer!;
      _execAt = transfer.execAt;
      _selectedFromAccountId = transfer.fromAccountId;
      _selectedToAccountId = transfer.toAccountId;
      _selectedCryptId = transfer.cryptId;
      _selectedFeeCryptId = transfer.feeCryptId;
      _amountController.text = transfer.amount.toString();
      _feeAmountController.text =
          (transfer.feeAmount ?? 0).toStringAsFixed(0);
      _memoController.text = transfer.memo ?? '';
    } else {
      _feeAmountController.text = '0';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _feeAmountController.dispose();
    _memoController.dispose();
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

    if (_selectedFromAccountId == null ||
        _selectedToAccountId == null ||
        _selectedCryptId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('送付元・送付先・暗号資産を選択してください')),
      );
      return;
    }

    if (_selectedFromAccountId == _selectedToAccountId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('送付元と送付先は別の口座を選択してください')),
      );
      return;
    }

    final amount = _parseDouble(_amountController.text);
    final feeAmount = _parseDouble(_feeAmountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('数量を正しく入力してください')),
      );
      return;
    }

    final normalizedFeeAmount =
        (feeAmount != null && feeAmount > 0) ? feeAmount : null;
    final normalizedFeeCryptId =
        normalizedFeeAmount == null ? null : _selectedFeeCryptId;

    if (normalizedFeeAmount != null && normalizedFeeCryptId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('手数料の通貨を選択してください')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final notifier = ref.read(transfersListProvider.notifier);

      if (_isEditMode) {
        await notifier.updateTransfer(
          widget.transfer!.id,
          fromAccountId: _selectedFromAccountId,
          toAccountId: _selectedToAccountId,
          cryptId: _selectedCryptId,
          execAt: _execAt,
          amount: amount,
          feeCryptId: normalizedFeeCryptId,
          feeAmount: normalizedFeeAmount,
          memo: _memoController.text.trim().isEmpty
              ? null
              : _memoController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('送付を更新しました')),
          );
          context.pop();
        }
      } else {
        await notifier.createTransfer(
          fromAccountId: _selectedFromAccountId!,
          toAccountId: _selectedToAccountId!,
          cryptId: _selectedCryptId!,
          execAt: _execAt,
          amount: amount,
          feeCryptId: normalizedFeeCryptId,
          feeAmount: normalizedFeeAmount,
          memo: _memoController.text.trim().isEmpty
              ? null
              : _memoController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('送付を登録しました')),
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
        title: Text(_isEditMode ? '送付の編集' : '送付の登録'),
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
                '口座の取得に失敗しました: ${error.toString()}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (accounts) {
                return DropdownButtonFormField<String>(
                  value: _selectedFromAccountId,
                  decoration: const InputDecoration(
                    labelText: '送付元口座',
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
                      _selectedFromAccountId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '送付元口座を選択してください';
                    }
                    if (_selectedToAccountId != null &&
                        value == _selectedToAccountId) {
                      return '送付元と送付先は別の口座を選択してください';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            accountsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => Text(
                '口座の取得に失敗しました: ${error.toString()}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (accounts) {
                return DropdownButtonFormField<String>(
                  value: _selectedToAccountId,
                  decoration: const InputDecoration(
                    labelText: '送付先口座',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance),
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
                      _selectedToAccountId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '送付先口座を選択してください';
                    }
                    if (_selectedFromAccountId != null &&
                        value == _selectedFromAccountId) {
                      return '送付元と送付先は別の口座を選択してください';
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
            TextFormField(
              controller: _feeAmountController,
              decoration: const InputDecoration(
                labelText: '手数料',
                hintText: '例: 0.0005',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.receipt_long),
                helperText: '手数料がない場合は0または空欄',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final parsed = _parseDouble(value ?? '');
                if (parsed == null) {
                  return null;
                }
                if (parsed < 0) {
                  return '手数料は0以上で入力してください';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            cryptsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => Text(
                '暗号資産の取得に失敗しました: ${error.toString()}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (crypts) {
                return DropdownButtonFormField<String?>(
                  value: _selectedFeeCryptId,
                  decoration: const InputDecoration(
                    labelText: '手数料の通貨',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.currency_exchange),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('未選択'),
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
                      _selectedFeeCryptId = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: 'メモ(任意)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
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
              label: Text(_isEditMode ? '更新' : '登録'),
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
