import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        amount INTEGER NOT NULL,
        isIncome INTEGER NOT NULL,
        date TEXT NOT NULL,
        note TEXT
      )
    ''');
    
    // Sample data
    await db.insert('transactions', {'category': 'Ăn uống', 'amount': 100000, 'isIncome': 0, 'date': '12/04/2025', 'note': 'Ăn trưa'});
    await db.insert('transactions', {'category': 'Mua sắm', 'amount': 500000, 'isIncome': 0, 'date': '10/04/2025', 'note': 'Mua quần áo'});
    await db.insert('transactions', {'category': 'Lương', 'amount': 10000000, 'isIncome': 1, 'date': '05/04/2025', 'note': 'Lương tháng 4'});
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('transactions', row);
  }

  Future<List<Map<String, dynamic>>> readAllTransactions() async {
    final db = await instance.database;
    return await db.query('transactions', orderBy: 'id DESC');
  }

  Future<int> updateTransaction(Map<String, dynamic> row, int id) async {
    final db = await instance.database;
    return await db.update('transactions', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
