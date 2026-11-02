import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

import '../../models/expense.dart';
import '../../models/expense_category.dart';

class AppDatabase {
  AppDatabase({this.factory, this.path});

  final DatabaseFactory? factory;
  final String? path;
  Future<Database>? _database;

  Future<Database> get database =>
      _database ??= _open().catchError((Object error) {
        _database = null;
        throw error;
      });

  Future<Database> _open() async {
    final desktop = Platform.isWindows || Platform.isLinux;
    var factory = this.factory;
    if (factory == null) {
      if (desktop) {
        ffi.sqfliteFfiInit();
        factory = ffi.databaseFactoryFfi;
      } else {
        factory = databaseFactory;
      }
    }
    var path = this.path;
    if (path == null) {
      final directory = desktop
          ? (await getApplicationSupportDirectory()).path
          : await factory.getDatabasesPath();
      await Directory(directory).create(recursive: true);
      path = p.join(directory, 'examina_expenses.db');
    }
    return factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE expenses (
              id INTEGER PRIMARY KEY,
              title TEXT NOT NULL CHECK(length(trim(title)) > 0),
              amount_minor INTEGER NOT NULL CHECK(amount_minor > 0),
              category TEXT NOT NULL,
              spent_on TEXT NOT NULL
            )
          ''');
          final batch = db.batch();
          for (final expense in seedExpenses) {
            batch.insert('expenses', expense.toMap());
          }
          await batch.commit(noResult: true);
        },
      ),
    );
  }

  Future<void> close() async {
    final pending = _database;
    _database = null;
    if (pending != null) {
      await (await pending).close();
    }
  }

  static final seedExpenses = <Expense>[
    Expense(
      id: 1,
      title: 'Ăn uống',
      amountMinor: 15000000,
      category: ExpenseCategory.living,
      spentOn: DateTime(2026, 10, 29),
    ),
    Expense(
      id: 2,
      title: 'Di chuyển',
      amountMinor: 5000000,
      category: ExpenseCategory.travel,
      spentOn: DateTime(2026, 10, 28),
    ),
    Expense(
      id: 3,
      title: 'Mua sách',
      amountMinor: 20000000,
      category: ExpenseCategory.education,
      spentOn: DateTime(2026, 10, 27),
    ),
    Expense(
      id: 4,
      title: 'Mua sắm',
      amountMinor: 150000000,
      category: ExpenseCategory.living,
      spentOn: DateTime(2026, 10, 25),
    ),
    Expense(
      id: 5,
      title: 'Khám bệnh',
      amountMinor: 355000000,
      category: ExpenseCategory.health,
      spentOn: DateTime(2026, 10, 22),
    ),
  ];
}
