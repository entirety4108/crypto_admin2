import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/sell.dart';
import '../providers/sell_provider.dart';
import '../providers/purchase_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

class SellFormScreen extends ConsumerStatefulWidget {
  const SellFormScreen({
    super.key,
    this.sell,
  });

  final Sell? sell;

  @override
  ConsumerState<SellFormScreen> createState() => _SellFormScreenState();
}

class _SellFormScreenState extends ConsumerState<SellFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _unitYenController = TextEditingController();
  final _amountController = TextEditingController();
  final _commissionController = TextEditingController();

  DateTime _execAt = DateTime.now();
  String? _selectedAccountId;
  String? _selectedCryptId;
  bool _isSubmitting = false;
  bool _isAutoUpdating = false;

  // Cost basis data
  double? _availableQty;
  double? _currentWac;
  double? _calculatedYen;
  double? _estimatedProfit;

  bool get _isEditMode => widget.sell != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      final sell = widget.sell!;
      _execAt = sell.execAt;
      _selectedAccountId = sell.accountId;
      _selectedCryptId = sell.cryptId;

      _unitYenController.text = sell.unitYen.toString();
      _amountController.text = sell.amount.toString();

      final commission = sell.commissionId != null ? 0.0 : 0.0;
      _commissionController.text = commission.toStringAsFixed(0);
    } else {
      _commissionController.text = '0';
    }

    _unitYenController.addListener(_recalculateYenAndProfit);
    _amountController.addListener(_recalculateYenAndProfit);
    _commissionController.addListener(_recalculateYenAndProfit);
  }

  @override
  void dispose() {
    _unitYenController.dispose();
    _amountController.dispose();
    _commissionController.dispose();
    super.dispose();
  }

  void _recalculateYenAndProfit() {
    if (_isAutoUpdating) {
      return;
    }

    final unitYen = _parseDouble(_unitYenController.text);
    final amount = _parseDouble(_amountController.text);
    final commission = _parseDouble(_commissionController.text) ?? 0;

    if (unitYen == null || amount == null) {
      setState(() {
        _calculatedYen = null;
        _estimatedProfit = null;
      });
      return;
    }

    // Calculate yen (sell proceeds)
    final yen = unitYen * amount;

    // Calculate profit if WAC is available
    double? profit;
    if (_currentWac != null) {
      final costBasis = amount * _currentWac!;
      profit = yen - costBasis - commission;
    }

    setState(() {
      _calculatedYen = yen;
      _estimatedProfit = profit;
    });
  }

  Future<void> _fetchCostBasis() async {
    if (_selectedAccountId == null || _selectedCryptId == null) {
      setState(() {
        _availableQty = null;
        _currentWac = null;
        _estimatedProfit = null;
      });
      return;
    }

    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('cost_basis_history')
          .select('total_qty, wac')
          .eq('account_id', _selectedAccountId!)
          .eq('crypt_id', _selectedCryptId!)
          .order('occurred_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        setState(() {
          _availableQty = (response['total_qty'] as num).toDouble();
          _currentWac = (response['wac'] as num).toDouble();
        });
        _recalculateYenAndProfit();
      } else {
        setState(() {
          _availableQty = 0.0;
          _currentWac = null;
          _estimatedProfit = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保有数量の取得に失敗: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
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
        const SnackBar(content: Text('口座と暗号資産を選択してください')),
      );
      return;
    }

    final unitYen = _parseDouble(_unitYenController.text);
    final amount = _parseDouble(_amountController.text);

    if (unitYen == null || amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('数値を正しく入力してください')),
      );
      return;
    }

    // Validate quantity
    if (_availableQty != null && amount > _availableQty!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('保有数量（${_availableQty!.toStringAsFixed(8)}）を超えて売却できません'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final notifier = ref.read(sellsListProvider.notifier);

      if (_isEditMode) {
        await notifier.updateSell(
          widget.sell!.id,
          execAt: _execAt,
          unitYen: unitYen,
          amount: amount,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('売却を更新しました')),
          );
          context.pop();
        }
      } else {
        await notifier.createSale(
          accountId: _selectedAccountId!,
          cryptId: _selectedCryptId!,
          execAt: _execAt,
          unitYen: unitYen,
          amount: amount,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('売却を登録しました')),
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
        title: Text(_isEditMode ? '売却の編集' : '売却の登録'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Execution date time
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

            // Account selector
            accountsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => Text(
                '口座の取得に失敗しました: ${error.toString()}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (accounts) {
                return DropdownButtonFormField<String>(
                  value: _selectedAccountId,
                  decoration: const InputDecoration(
                    labelText: '口座',
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
                    _fetchCostBasis();
                  },
                  validator: (value) {
                    if (value == null) {
                      return '口座を選択してください';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Crypt selector
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
                    _fetchCostBasis();
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

            // Available quantity display (read-only)
            if (_availableQty != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '保有数量: ${_availableQty!.toStringAsFixed(8)}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (_currentWac != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '現在のWAC: ¥${_currentWac!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Unit price
            TextFormField(
              controller: _unitYenController,
              decoration: const InputDecoration(
                labelText: '単価 (円)',
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

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: '数量',
                hintText: '例: 0.5',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.toll),
                helperText: _availableQty != null
                    ? '最大: ${_availableQty!.toStringAsFixed(8)}'
                    : null,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final parsed = _parseDouble(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return '数量を正しく入力してください';
                }
                if (_availableQty != null && parsed > _availableQty!) {
                  return '保有数量を超えています';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Commission (optional)
            TextFormField(
              controller: _commissionController,
              decoration: const InputDecoration(
                labelText: '手数料 (円)',
                hintText: '例: 500',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.receipt_long),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final parsed = _parseDouble(value ?? '');
                if (parsed == null || parsed < 0) {
                  return '手数料を正しく入力してください';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),

            // Calculated sell proceeds (read-only)
            if (_calculatedYen != null) ...[
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '売却代金: ¥${_calculatedYen!.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (_estimatedProfit != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '予想損益: ¥${_estimatedProfit!.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: _estimatedProfit! >= 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Submit button
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
