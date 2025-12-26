import '../../domain/entities/transaction_entity.dart';
import '../database/gta_database.dart';

class TransactionModel {
  static Map<String, dynamic> toMap(TransactionEntity entity) {
    return {
      GTADatabase.columnId: entity.id,
      GTADatabase.columnAmount: entity.amount,
      GTADatabase.columnComment: entity.comment,
      GTADatabase.columnCreatedAt: entity.createdAt.millisecondsSinceEpoch,
      GTADatabase.columnType: entity.type,
    };
  }

  static TransactionEntity fromMap(Map<String, dynamic> map) {
    return TransactionEntity(
      id: map[GTADatabase.columnId] as int?,
      amount: map[GTADatabase.columnAmount] as double,
      comment: map[GTADatabase.columnComment] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[GTADatabase.columnCreatedAt] as int,
      ),
      type: map[GTADatabase.columnType] as String?,
    );
  }
}

