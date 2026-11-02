enum ExpenseCategory {
  living('living', 'Sinh hoạt'),
  travel('travel', 'Đi lại'),
  education('education', 'Học tập'),
  health('health', 'Sức khỏe'),
  other('other', 'Khác');

  const ExpenseCategory(this.code, this.label);

  final String code;
  final String label;

  static ExpenseCategory fromCode(String code) => values.firstWhere(
    (category) => category.code == code,
    orElse: () => other,
  );
}
