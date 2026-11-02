import 'package:shared_preferences/shared_preferences.dart';

import '../../models/currency.dart';

class SettingsRepository {
  SettingsRepository(this._preferences);

  final SharedPreferencesAsync _preferences;
  static const currencyKey = 'examina.currency';

  Future<Currency> loadCurrency() async =>
      Currency.fromCode(await _preferences.getString(currencyKey));

  Future<void> saveCurrency(Currency currency) =>
      _preferences.setString(currencyKey, currency.code);
}
