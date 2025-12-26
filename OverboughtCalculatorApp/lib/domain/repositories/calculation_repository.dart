import '../entities/calculation_history_entity.dart';

abstract class CalculationRepository {
  Future<int> saveCalculation(CalculationHistoryEntity calculation);
  Future<List<CalculationHistoryEntity>> getAllCalculations();
  Future<CalculationHistoryEntity?> getCalculationById(int id);
  Future<void> deleteCalculation(int id);
  Future<void> updateCalculation(CalculationHistoryEntity calculation);
}

