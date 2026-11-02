// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExpenseListViewModel)
final expenseListViewModelProvider = ExpenseListViewModelProvider._();

final class ExpenseListViewModelProvider
    extends $AsyncNotifierProvider<ExpenseListViewModel, List<Expense>> {
  ExpenseListViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseListViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseListViewModelHash();

  @$internal
  @override
  ExpenseListViewModel create() => ExpenseListViewModel();
}

String _$expenseListViewModelHash() =>
    r'2c634c1bb598215cb4dae9dc47131cc3838ba8fa';

abstract class _$ExpenseListViewModel extends $AsyncNotifier<List<Expense>> {
  FutureOr<List<Expense>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Expense>>, List<Expense>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Expense>>, List<Expense>>,
              AsyncValue<List<Expense>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
