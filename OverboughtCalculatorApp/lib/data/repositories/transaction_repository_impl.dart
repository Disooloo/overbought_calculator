import 'package:flutter/foundation.dart' show kIsWeb;
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../database/gta_database.dart';
import '../database/web_storage.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  @override
  Future<int> addTransaction(TransactionEntity transaction) async {
    if (kIsWeb) {
      return await WebStorage.addTransaction(transaction);
    } else {
      final db = await GTADatabase.database;
      final map = TransactionModel.toMap(transaction);
      map.remove(GTADatabase.columnId);
      return await db.insert(GTADatabase.tableTransactions, map);
    }
  }

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    if (kIsWeb) {
      return await WebStorage.getAllTransactions();
    } else {
      final db = await GTADatabase.database;
      final maps = await db.query(
        GTADatabase.tableTransactions,
        orderBy: '${GTADatabase.columnCreatedAt} DESC',
      );
      return maps.map((map) => TransactionModel.fromMap(map)).toList();
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    if (kIsWeb) {
      await WebStorage.deleteTransaction(id);
    } else {
      final db = await GTADatabase.database;
      await db.delete(
        GTADatabase.tableTransactions,
        where: '${GTADatabase.columnId} = ?',
        whereArgs: [id],
      );
    }
  }
}

