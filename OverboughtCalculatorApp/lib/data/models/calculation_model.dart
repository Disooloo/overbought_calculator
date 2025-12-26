import '../../domain/entities/calculation_entity.dart';
import '../../domain/entities/calculation_history_entity.dart';
import '../database/app_database.dart';

class CalculationModel {
  static Map<String, dynamic> toMap(CalculationHistoryEntity entity) {
    return {
      AppDatabase.columnId: entity.id,
      AppDatabase.columnName: entity.name,
      AppDatabase.columnPurchasePrice: entity.calculation.purchasePrice,
      AppDatabase.columnSalePrice: entity.calculation.salePrice,
      AppDatabase.columnRepair: entity.calculation.repair,
      AppDatabase.columnLogistics: entity.calculation.logistics,
      AppDatabase.columnCommissions: entity.calculation.commissions,
      AppDatabase.columnOtherExpenses: entity.calculation.otherExpenses,
      AppDatabase.columnCurrency: entity.calculation.currency.code,
      AppDatabase.columnCreatedAt: entity.createdAt.millisecondsSinceEpoch,
    };
  }

  static CalculationHistoryEntity fromMap(Map<String, dynamic> map) {
    final currencyCode = map[AppDatabase.columnCurrency] as String;
    Currency currency;
    switch (currencyCode) {
      case 'RUB':
        currency = Currency.rub;
        break;
      case 'USD':
        currency = Currency.usd;
        break;
      case 'EUR':
        currency = Currency.eur;
        break;
      default:
        currency = Currency.rub;
    }

    final calculation = CalculationEntity(
      purchasePrice: map[AppDatabase.columnPurchasePrice] as double,
      salePrice: map[AppDatabase.columnSalePrice] as double,
      repair: map[AppDatabase.columnRepair] as double? ?? 0.0,
      logistics: map[AppDatabase.columnLogistics] as double? ?? 0.0,
      commissions: map[AppDatabase.columnCommissions] as double? ?? 0.0,
      otherExpenses: map[AppDatabase.columnOtherExpenses] as double? ?? 0.0,
      currency: currency,
    );

    return CalculationHistoryEntity(
      id: map[AppDatabase.columnId] as int?,
      name: map[AppDatabase.columnName] as String,
      calculation: calculation,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[AppDatabase.columnCreatedAt] as int,
      ),
    );
  }
}

