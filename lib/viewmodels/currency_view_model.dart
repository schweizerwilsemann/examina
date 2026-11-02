import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/providers.dart';
import '../models/currency.dart';

part 'currency_view_model.g.dart';

@Riverpod(keepAlive: true)
class CurrencyViewModel extends _$CurrencyViewModel {
  @override
  Future<Currency> build() =>
      ref.watch(settingsRepositoryProvider).loadCurrency();

  Future<void> save(Currency currency) async {
    await ref.read(settingsRepositoryProvider).saveCurrency(currency);
    if (ref.mounted) state = AsyncData(currency);
  }
}
