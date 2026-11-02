// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrencyViewModel)
final currencyViewModelProvider = CurrencyViewModelProvider._();

final class CurrencyViewModelProvider
    extends $AsyncNotifierProvider<CurrencyViewModel, Currency> {
  CurrencyViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyViewModelHash();

  @$internal
  @override
  CurrencyViewModel create() => CurrencyViewModel();
}

String _$currencyViewModelHash() => r'd6c03683f08d949bee70df4dd1b0a854a0b97533';

abstract class _$CurrencyViewModel extends $AsyncNotifier<Currency> {
  FutureOr<Currency> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Currency>, Currency>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Currency>, Currency>,
              AsyncValue<Currency>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
