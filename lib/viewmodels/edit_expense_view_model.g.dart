// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_expense_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditExpenseViewModel)
final editExpenseViewModelProvider = EditExpenseViewModelFamily._();

final class EditExpenseViewModelProvider
    extends $AsyncNotifierProvider<EditExpenseViewModel, EditExpenseState> {
  EditExpenseViewModelProvider._({
    required EditExpenseViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'editExpenseViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editExpenseViewModelHash();

  @override
  String toString() {
    return r'editExpenseViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditExpenseViewModel create() => EditExpenseViewModel();

  @override
  bool operator ==(Object other) {
    return other is EditExpenseViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editExpenseViewModelHash() =>
    r'c15e0cbe83df57fe532f7311d6330223c2dbb802';

final class EditExpenseViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          EditExpenseViewModel,
          AsyncValue<EditExpenseState>,
          EditExpenseState,
          FutureOr<EditExpenseState>,
          int
        > {
  EditExpenseViewModelFamily._()
    : super(
        retry: null,
        name: r'editExpenseViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditExpenseViewModelProvider call(int expenseId) =>
      EditExpenseViewModelProvider._(argument: expenseId, from: this);

  @override
  String toString() => r'editExpenseViewModelProvider';
}

abstract class _$EditExpenseViewModel extends $AsyncNotifier<EditExpenseState> {
  late final _$args = ref.$arg as int;
  int get expenseId => _$args;

  FutureOr<EditExpenseState> build(int expenseId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<EditExpenseState>, EditExpenseState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EditExpenseState>, EditExpenseState>,
              AsyncValue<EditExpenseState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
