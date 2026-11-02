import '../../models/expense.dart';
import '../local/app_database.dart';

class ExpenseRepository {
  ExpenseRepository(this._database);

  final AppDatabase _database;

  Future<List<Expense>> fetchAll() async {
    final db = await _database.database;
    final rows = await db.query('expenses', orderBy: 'spent_on DESC, id DESC');
    return rows.map(Expense.fromMap).toList(growable: false);
  }

  Future<Expense> findById(int id) async {
    final db = await _database.database;
    final rows = await db.query('expenses', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) throw StateError('Khoản chi không còn tồn tại.');
    return Expense.fromMap(rows.single);
  }

  Future<void> update(Expense expense) async {
    final db = await _database.database;
    final count = await db.update(
      'expenses',
      expense.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    if (count != 1) throw StateError('Không tìm thấy khoản chi cần cập nhật.');
  }
}
