import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency.dart';
import '../viewmodels/currency_view_model.dart';

class CurrencySettingsDialog extends ConsumerStatefulWidget {
  const CurrencySettingsDialog({required this.initialCurrency, super.key});

  final Currency initialCurrency;

  @override
  ConsumerState<CurrencySettingsDialog> createState() =>
      _CurrencySettingsDialogState();
}

class _CurrencySettingsDialogState
    extends ConsumerState<CurrencySettingsDialog> {
  late Currency _selected = widget.initialCurrency;
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(currencyViewModelProvider.notifier).save(_selected);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Không thể lưu đơn vị tiền tệ. Vui lòng thử lại.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: AlertDialog(
      title: const Text(
        'Đơn vị tiền tệ',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioGroup<Currency>(
              groupValue: _selected,
              onChanged: (value) {
                if (!_saving && value != null) {
                  setState(() => _selected = value);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final currency in Currency.values)
                    RadioListTile<Currency>(
                      value: currency,
                      enabled: !_saving,
                      title: Text(
                        currency.description,
                        style: const TextStyle(fontSize: 15),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const Divider(height: 24),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _saving ? null : () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Đang lưu…' : 'Lưu'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
