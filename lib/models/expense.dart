import 'expense_category.dart';

class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.amountMinor,
    required this.category,
    required this.spentOn,
  });

  final int id;
  final String title;

  final int amountMinor;
  final ExpenseCategory category;
  final DateTime spentOn;

  String get editableAmount => amountMinor % 100 == 0
      ? (amountMinor ~/ 100).toString()
      : '${amountMinor ~/ 100}.${(amountMinor % 100).toString().padLeft(2, '0')}';

  Expense copyWith({
    String? title,
    int? amountMinor,
    ExpenseCategory? category,
    DateTime? spentOn,
  }) => Expense(
    id: id,
    title: title ?? this.title,
    amountMinor: amountMinor ?? this.amountMinor,
    category: category ?? this.category,
    spentOn: spentOn ?? this.spentOn,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'amount_minor': amountMinor,
    'category': category.code,
    'spent_on': dateToStorage(spentOn),
  };

  factory Expense.fromMap(Map<String, Object?> map) => Expense(
    id: map['id']! as int,
    title: map['title']! as String,
    amountMinor: map['amount_minor']! as int,
    category: ExpenseCategory.fromCode(map['category']! as String),
    spentOn: DateTime.parse(map['spent_on']! as String),
  );

  static String dateToStorage(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
