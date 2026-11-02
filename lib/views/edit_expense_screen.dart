import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/currency.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../viewmodels/edit_expense_view_model.dart';
import 'widgets/load_error.dart';

class EditExpenseScreen extends ConsumerWidget {
  const EditExpenseScreen({
    required this.expenseId,
    required this.currency,
    super.key,
  });

  final int expenseId;
  final Currency currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editor = ref.watch(editExpenseViewModelProvider(expenseId));
    final saving = editor.asData?.value.isSaving ?? false;
    return PopScope(
      canPop: !saving,
      child: Scaffold(
        appBar: AppBar(title: const Text('Chỉnh sửa khoản chi')),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: editor.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => LoadError(
                  message: 'Không thể tải khoản chi.',
                  onRetry: () =>
                      ref.invalidate(editExpenseViewModelProvider(expenseId)),
                ),
                data: (data) => _ExpenseForm(
                  expense: data.expense,
                  currency: currency,
                  saving: data.isSaving,
                  error: data.error,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseForm extends ConsumerStatefulWidget {
  const _ExpenseForm({
    required this.expense,
    required this.currency,
    required this.saving,
    this.error,
  });

  final Expense expense;
  final Currency currency;
  final bool saving;
  final String? error;

  @override
  ConsumerState<_ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<_ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.expense.title);
  late final _amount = TextEditingController(
    text: widget.expense.editableAmount,
  );
  late DateTime _date = widget.expense.spentOn;
  late final _dateText = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(_date),
  );
  late ExpenseCategory _category = widget.expense.category;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _dateText.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'Chọn ngày chi tiêu',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
    );
    if (picked != null && mounted) {
      setState(() {
        _date = picked;
        _dateText.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final saved = await ref
        .read(editExpenseViewModelProvider(widget.expense.id).notifier)
        .save(
          title: _title.text,
          amount: _amount.text,
          category: _category,
          spentOn: _date,
        );
    if (saved && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(
                  'Tên khoản chi *',
                  TextFormField(
                    key: const ValueKey('expense-title'),
                    controller: _title,
                    enabled: !widget.saving,
                    maxLength: 100,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Nhập tên khoản chi',
                    ),
                    validator: EditExpenseViewModel.validateTitle,
                  ),
                ),
                _field(
                  'Số tiền *',
                  TextFormField(
                    key: const ValueKey('expense-amount'),
                    controller: _amount,
                    enabled: !widget.saving,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      suffixText: widget.currency.code,
                      hintText: 'Nhập số tiền',
                    ),
                    validator: EditExpenseViewModel.validateAmount,
                  ),
                ),
                _field(
                  'Danh mục *',
                  DropdownButtonFormField<ExpenseCategory>(
                    key: const ValueKey('expense-category'),
                    initialValue: _category,
                    isExpanded: true,
                    items: [
                      for (final category in ExpenseCategory.values)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ),
                    ],
                    onChanged: widget.saving
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() => _category = value);
                            }
                          },
                  ),
                ),
                _field(
                  'Ngày chi tiêu *',
                  TextFormField(
                    key: const ValueKey('expense-date'),
                    controller: _dateText,
                    readOnly: true,
                    enabled: !widget.saving,
                    onTap: _pickDate,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                    ),
                  ),
                ),
                if (widget.error != null)
                  Text(
                    widget.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.saving
                    ? null
                    : () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                key: const ValueKey('save-expense'),
                onPressed: widget.saving ? null : _save,
                child: Text(widget.saving ? 'Đang lưu…' : 'Lưu'),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _field(String label, Widget child) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}
