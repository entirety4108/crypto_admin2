import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/swap.dart';
import '../providers/purchase_provider.dart';
import '../providers/swap_provider.dart';
import '../../../portfolio/presentation/providers/account_provider.dart';

class SwapFormScreen extends ConsumerStatefulWidget {
  const SwapFormScreen({super.key, this.swap});

  final SwapWithDetails? swap;

  @override
  ConsumerState<SwapFormScreen> createState() => _SwapFormScreenState();
}

class _SwapFormScreenState extends ConsumerState<SwapFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sellAmountController = TextEditingController();
  final _sellUnitYenController = TextEditingController();
  final _sellFeeController = TextEditingController(text: '0');
  final _buyAmountController = TextEditingController();
  final _buyUnitYenController = TextEditingController();
  final _buyFeeController = TextEditingController(text: '0');
  final _memoController = TextEditingController();

  DateTime _execAt = DateTime.now();
  String? _accountId;
  String? _sellCryptId;
  String? _buyCryptId;
  bool _isSubmitting = false;

  double? _availableQty;
  double? _wac;
  double? _estimatedProfit;

  bool get _isEditMode => widget.swap != null;

  @override
  void initState() {
    super.initState();
    final current = widget.swap;
    if (current != null) {
      _execAt = current.execAt;
      _accountId = current.accountId;
      _sellCryptId = current.sellCryptId;
      _buyCryptId = current.buyCryptId;
      _sellAmountController.text = current.sell.amount.toString();
      _sellUnitYenController.text = current.sell.unitYen.toString();
      _buyAmountController.text = current.buy.amount.toString();
      _buyUnitYenController.text = current.buy.unitYen.toString();
      _memoController.text = current.swap.memo ?? '';
    }
    _sellAmountController.addListener(_recalculateProfit);
    _sellUnitYenController.addListener(_recalculateProfit);
    _sellFeeController.addListener(_recalculateProfit);
    _fetchCostBasis();
  }

  @override
  void dispose() {
    _sellAmountController.dispose();
    _sellUnitYenController.dispose();
    _sellFeeController.dispose();
    _buyAmountController.dispose();
    _buyUnitYenController.dispose();
    _buyFeeController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  double? _parseDouble(String text) {
    final normalized = text.replaceAll(',', '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    return double.tryParse(normalized);
  }

  String _formatDate(DateTime value) => DateFormat('yyyy/MM/dd HH:mm').format(value);

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

  Future<void> _fetchCostBasis() async {
    if (_accountId == null || _sellCryptId == null) {
      setState(() {
        _availableQty = null;
        _wac = null;
        _estimatedProfit = null;
      });
      return;
    }
    try {
      final row = await Supabase.instance.client
          .from('cost_basis_history')
          .select('total_qty, wac')
          .eq('account_id', _accountId!)
          .eq('crypt_id', _sellCryptId!)
          .order('occurred_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (row == null) {
        setState(() {
          _availableQty = 0;
          _wac = null;
          _estimatedProfit = null;
        });
        return;
      }
      setState(() {
        _availableQty = (row['total_qty'] as num).toDouble();
        _wac = (row['wac'] as num).toDouble();
      });
      _recalculateProfit();
    } catch (_) {
      setState(() {
        _availableQty = null;
        _wac = null;
        _estimatedProfit = null;
      });
    }
  }

  void _recalculateProfit() {
    final amount = _parseDouble(_sellAmountController.text);
    final unitYen = _parseDouble(_sellUnitYenController.text);
    final fee = _parseDouble(_sellFeeController.text) ?? 0.0;
    if (amount == null || unitYen == null || _wac == null) {
      setState(() {
        _estimatedProfit = null;
      });
      return;
    }
    final sellYen = amount * unitYen;
    final cost = amount * _wac!;
    setState(() {
      _estimatedProfit = sellYen - cost - fee;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_accountId == null || _sellCryptId == null || _buyCryptId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select account/sell crypt/buy crypt.')),
      );
      return;
    }
    if (_sellCryptId == _buyCryptId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sell and Buy crypt must be different.')),
      );
      return;
    }

    final sellAmount = _parseDouble(_sellAmountController.text)!;
    final sellUnitYen = _parseDouble(_sellUnitYenController.text)!;
    final sellFee = _parseDouble(_sellFeeController.text) ?? 0.0;
    final buyAmount = _parseDouble(_buyAmountController.text)!;
    final buyUnitYen = _parseDouble(_buyUnitYenController.text)!;
    final buyFee = _parseDouble(_buyFeeController.text) ?? 0.0;
    final memo = _memoController.text.trim().isEmpty ? null : _memoController.text.trim();

    if (_availableQty != null && sellAmount > _availableQty!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insufficient quantity. available=$_availableQty')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });
    try {
      final notifier = ref.read(swapsListProvider.notifier);
      if (_isEditMode) {
        await notifier.deleteSwap(widget.swap!.swap.id);
      }
      await notifier.createSwap(
        accountId: _accountId!,
        sellCryptId: _sellCryptId!,
        sellAmount: sellAmount,
        sellUnitYen: sellUnitYen,
        buyCryptId: _buyCryptId!,
        buyAmount: buyAmount,
        buyUnitYen: buyUnitYen,
        execAt: _execAt,
        sellFee: sellFee,
        buyFee: buyFee,
        memo: memo,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditMode ? 'Swap updated.' : 'Swap created.')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save swap: $e')),
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
        title: Text(_isEditMode ? 'Edit Swap' : 'New Swap'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Execution Time',
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
            const SizedBox(height: 12),
            accountsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Failed to load accounts: $e'),
              data: (accounts) => DropdownButtonFormField<String>(
                value: _accountId,
                decoration: const InputDecoration(
                  labelText: 'Account',
                  border: OutlineInputBorder(),
                ),
                items: accounts
                    .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                    .toList(),
                onChanged: (value) {
                  setState(() => _accountId = value);
                  _fetchCostBasis();
                },
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 12),
            cryptsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Failed to load crypts: $e'),
              data: (crypts) => Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _sellCryptId,
                    decoration: const InputDecoration(
                      labelText: 'Sell Crypt',
                      border: OutlineInputBorder(),
                    ),
                    items: crypts
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.symbol)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _sellCryptId = value);
                      _fetchCostBasis();
                    },
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _buyCryptId,
                    decoration: const InputDecoration(
                      labelText: 'Buy Crypt',
                      border: OutlineInputBorder(),
                    ),
                    items: crypts
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.symbol)))
                        .toList(),
                    onChanged: (value) => setState(() => _buyCryptId = value),
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_availableQty != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Available Qty: ${_availableQty!.toStringAsFixed(8)}'
                    '${_wac != null ? ' | WAC: ${_wac!.toStringAsFixed(2)}' : ''}',
                  ),
                ),
              ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sellAmountController,
              decoration: const InputDecoration(
                labelText: 'Sell Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  (_parseDouble(value ?? '') ?? 0) <= 0 ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sellUnitYenController,
              decoration: const InputDecoration(
                labelText: 'Sell Unit Yen',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  (_parseDouble(value ?? '') ?? 0) <= 0 ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sellFeeController,
              decoration: const InputDecoration(
                labelText: 'Sell Fee (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _buyAmountController,
              decoration: const InputDecoration(
                labelText: 'Buy Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  (_parseDouble(value ?? '') ?? 0) <= 0 ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _buyUnitYenController,
              decoration: const InputDecoration(
                labelText: 'Buy Unit Yen',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  (_parseDouble(value ?? '') ?? 0) <= 0 ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _buyFeeController,
              decoration: const InputDecoration(
                labelText: 'Buy Fee (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: 'Memo',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            if (_estimatedProfit != null) ...[
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Estimated Sell P&L: ${_estimatedProfit!.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: _estimatedProfit! >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _save,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isEditMode ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
