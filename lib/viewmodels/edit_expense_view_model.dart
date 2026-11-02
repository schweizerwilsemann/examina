import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/providers.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import 'expense_list_view_model.dart';

part 'edit_expense_view_model.g.dart';

class EditExpenseState {
  const EditExpenseState(this.expense, {this.isSaving = false, this.error});

  final Expense expense;
  final bool isSaving;
  final String? error;
}

@riverpod
class EditExpenseViewModel extends _$EditExpenseViewModel {
  @override
  Future<EditExpenseState> build(int expenseId) async => EditExpenseState(
    await ref.watch(expenseRepositoryProvider).findById(expenseId),
  );

  Future<bool> save({
    required String title,
    required String amount,
    required ExpenseCategory category,
    required DateTime spentOn,
  }) async {
    final current = state.asData?.value;
    if (current == null || current.isSaving) return false;
    final validation = validateTitle(title) ?? validateAmount(amount);
    if (validation != null) {
      state = AsyncData(EditExpenseState(current.expense, error: validation));
      return false;
    }
    state = AsyncData(EditExpenseState(current.expense, isSaving: true));
    try {
      final updated = current.expense.copyWith(
        title: title.trim(),
        amountMinor: parseAmount(amount)!,
        category: category,
        spentOn: DateTime(spentOn.year, spentOn.month, spentOn.day),
      );
      await ref.read(expenseRepositoryProvider).update(updated);
      if (!ref.mounted) return false;
      ref.invalidate(expenseListViewModelProvider);
      state = AsyncData(EditExpenseState(updated));
      return true;
    } catch (_) {
      if (ref.mounted) {
        state = AsyncData(
          EditExpenseState(
            current.expense,
            error: 'Không thể lưu khoản chi. Vui lòng thử lại.',
          ),
        );
      }
      return false;
    }
  }

  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên khoản chi.';
    }
    if (value.trim().length > 100) return 'Tên khoản chi tối đa 100 ký tự.';
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập số tiền.';
    if (parseAmount(value) == null) {
      return 'Nhập số tiền từ 0,01 đến 999.999.999.999,99 (tối đa 2 số lẻ).';
    }
    return null;
  }

  static int? parseAmount(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (!RegExp(r'^\d{1,12}(\.\d{1,2})?$').hasMatch(normalized)) return null;
    final parts = normalized.split('.');
    final whole = int.tryParse(parts.first);
    if (whole == null) return null;
    final fraction = parts.length == 2
        ? int.parse(parts[1].padRight(2, '0'))
        : 0;
    final minor = whole * 100 + fraction;
    return minor > 0 ? minor : null;
  }
}
