import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/providers.dart';
import '../models/expense.dart';

part 'expense_list_view_model.g.dart';

@riverpod
class ExpenseListViewModel extends _$ExpenseListViewModel {
  @override
  Future<List<Expense>> build() =>
      ref.watch(expenseRepositoryProvider).fetchAll();

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
