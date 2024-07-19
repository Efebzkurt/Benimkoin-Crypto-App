import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

class PortfolioDatabase {
  static final PortfolioDatabase instance = PortfolioDatabase._init();
  static Database? _database;

  PortfolioDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('portfolio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = Path.join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE portfolio (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  average_cost REAL NOT NULL,
  quantity REAL NOT NULL,
  goal REAL
)
    ''');

    await db.execute('''
CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  asset_name TEXT NOT NULL,
  type TEXT NOT NULL,
  cost REAL NOT NULL,
  quantity REAL NOT NULL,
  date TEXT NOT NULL
)
    ''');
  }

  Future<void> addAsset(String name, double cost, double quantity) async {
    final db = await instance.database;

    final existingAsset = await db.query(
      'portfolio',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (existingAsset.isNotEmpty) {
      final existingQuantity = existingAsset.first['quantity'] as num;
      final existingAverageCost = existingAsset.first['average_cost'] as num;

      var newQuantity = existingQuantity + quantity;
      if (newQuantity < 0) {
        newQuantity = 0;
      }
      final newAverageCost = newQuantity == 0
          ? 0
          : ((existingAverageCost * existingQuantity) + (cost * quantity)) /
              newQuantity;

      await db.update(
        'portfolio',
        {'average_cost': newAverageCost, 'quantity': newQuantity},
        where: 'name = ?',
        whereArgs: [name],
      );
    } else {
      await db.insert('portfolio', {
        'name': name,
        'average_cost': cost,
        'quantity': quantity,
        'goal': null,
      });
    }

    await db.insert('transactions', {
      'asset_name': name,
      'type': 'add',
      'cost': cost,
      'quantity': quantity,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> setGoal(String name, double goal) async {
    final db = await instance.database;
    await db.update(
      'portfolio',
      {'goal': goal},
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<List<Map<String, dynamic>>> getGoals() async {
    final db = await instance.database;
    return await db.query('portfolio', columns: ['name', 'goal']);
  }

  Future<List<Map<String, dynamic>>> getPortfolio() async {
    final db = await instance.database;
    final portfolio = await db.rawQuery('''
      SELECT *, (average_cost * quantity) as total_value 
      FROM portfolio 
      ORDER BY total_value DESC
    ''');

    return portfolio;
  }

  Future<List<Map<String, dynamic>>> getTransactions(String assetName) async {
    final db = await instance.database;
    return await db.query(
      'transactions',
      where: 'asset_name = ?',
      whereArgs: [assetName],
      orderBy: 'date DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final db = await instance.database;
    return await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
  }

  Future<int> deleteRowsWithZeroQuantity() async {
    final db = await instance.database;
    return await db.delete(
      'portfolio',
      where: 'quantity = ?',
      whereArgs: [0],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
