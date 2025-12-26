import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabase {
  static const String _databaseName = 'overbought_calculator.db';
  static const int _databaseVersion = 1;

  static const String tableCalculations = 'calculations';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnPurchasePrice = 'purchase_price';
  static const String columnSalePrice = 'sale_price';
  static const String columnRepair = 'repair';
  static const String columnLogistics = 'logistics';
  static const String columnCommissions = 'commissions';
  static const String columnOtherExpenses = 'other_expenses';
  static const String columnCurrency = 'currency';
  static const String columnCreatedAt = 'created_at';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCalculations (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnPurchasePrice REAL NOT NULL,
        $columnSalePrice REAL NOT NULL,
        $columnRepair REAL NOT NULL DEFAULT 0,
        $columnLogistics REAL NOT NULL DEFAULT 0,
        $columnCommissions REAL NOT NULL DEFAULT 0,
        $columnOtherExpenses REAL NOT NULL DEFAULT 0,
        $columnCurrency TEXT NOT NULL,
        $columnCreatedAt INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

