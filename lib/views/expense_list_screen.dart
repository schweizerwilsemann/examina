import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency.dart';
import '../viewmodels/currency_view_model.dart';
import '../viewmodels/expense_list_view_model.dart';
import 'currency_settings_dialog.dart';
import 'edit_expense_screen.dart';
import 'widgets/expense_card.dart';
import 'widgets/load_error.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseListViewModelProvider);
    final currency = ref.watch(currencyViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu'),
        actions: [
          IconButton(
            key: const ValueKey('settings'),
            tooltip: 'Cài đặt đơn vị tiền tệ',
            icon: const Icon(Icons.settings_outlined),
            onPressed: currency.asData == null
                ? null
                : () => showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => CurrencySettingsDialog(
                      initialCurrency: currency.requireValue,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: currency.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => LoadError(
                message: 'Không thể đọc cài đặt tiền tệ.',
                onRetry: () => ref.invalidate(currencyViewModelProvider),
              ),
              data: (unit) => expenses.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => LoadError(
                  message: 'Không thể tải danh sách chi tiêu.',
                  onRetry: () => ref.invalidate(expenseListViewModelProvider),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(child: Text('Chưa có khoản chi nào.'));
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref
                        .read(expenseListViewModelProvider.notifier)
                        .refresh(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => ExpenseCard(
                        expense: items[index],
                        currency: unit,
                        onEdit: () => _edit(context, items[index].id, unit),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, int id, Currency currency) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditExpenseScreen(expenseId: id, currency: currency),
      ),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã lưu khoản chi.')));
    }
  }
}
