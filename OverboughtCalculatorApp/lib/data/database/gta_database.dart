import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GTADatabase {
  static const String _databaseName = 'gta5rp_calculator.db';
  static const int _databaseVersion = 1;

  static const String tableTransactions = 'transactions';
  static const String columnId = 'id';
  static const String columnAmount = 'amount';
  static const String columnComment = 'comment';
  static const String columnCreatedAt = 'created_at';
  static const String columnType = 'type';

  static const String tableProducts = 'products';
  static const String columnProductId = 'id';
  static const String columnName = 'name';
  static const String columnImagePath = 'image_path';
  static const String columnCostPrice = 'cost_price';
  static const String columnSalePrice = 'sale_price';
  static const String columnQuantity = 'quantity';
  static const String columnProductCreatedAt = 'created_at';

  static Database? _database;

  static Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite not supported on web');
    }
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
    // Таблица транзакций
    await db.execute('''
      CREATE TABLE $tableTransactions (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnAmount REAL NOT NULL,
        $columnComment TEXT NOT NULL,
        $columnCreatedAt INTEGER NOT NULL,
        $columnType TEXT
      )
    ''');

    // Таблица товаров
    await db.execute('''
      CREATE TABLE $tableProducts (
        $columnProductId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnImagePath TEXT,
        $columnCostPrice REAL NOT NULL,
        $columnSalePrice REAL NOT NULL,
        $columnQuantity REAL NOT NULL DEFAULT 1,
        $columnProductCreatedAt INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> close() async {
    if (kIsWeb) return;
    final db = await database;
    await db.close();
    _database = null;
  }
}

