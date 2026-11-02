import 'package:intl/intl.dart';

enum Currency {
  vnd('VND', 'Việt Nam Đồng'),
  usd('USD', 'Đô la Mỹ');

  const Currency(this.code, this.label);

  final String code;
  final String label;

  String get description => '$code ($label)';
  String format(int amountMinor) {
    final decimals = this == usd || amountMinor % 100 != 0 ? 2 : 0;
    return '${NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: decimals).format(amountMinor / 100)} $code';
  }

  static Currency fromCode(String? code) =>
      values.firstWhere((value) => value.code == code, orElse: () => vnd);
}
