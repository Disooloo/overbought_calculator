import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/calculation_entity.dart';

class CalculationState {
  final double purchasePrice;
  final double salePrice;
  final double repair;
  final double logistics;
  final double commissions;
  final double otherExpenses;
  final Currency currency;

  CalculationState({
    this.purchasePrice = 0,
    this.salePrice = 0,
    this.repair = 0,
    this.logistics = 0,
    this.commissions = 0,
    this.otherExpenses = 0,
    this.currency = Currency.rub,
  });

  CalculationState copyWith({
    double? purchasePrice,
    double? salePrice,
    double? repair,
    double? logistics,
    double? commissions,
    double? otherExpenses,
    Currency? currency,
  }) {
    return CalculationState(
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      repair: repair ?? this.repair,
      logistics: logistics ?? this.logistics,
      commissions: commissions ?? this.commissions,
      otherExpenses: otherExpenses ?? this.otherExpenses,
      currency: currency ?? this.currency,
    );
  }

  CalculationEntity toEntity() {
    return CalculationEntity(
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      repair: repair,
      logistics: logistics,
      commissions: commissions,
      otherExpenses: otherExpenses,
      currency: currency,
    );
  }

  static CalculationState fromEntity(CalculationEntity entity) {
    return CalculationState(
      purchasePrice: entity.purchasePrice,
      salePrice: entity.salePrice,
      repair: entity.repair,
      logistics: entity.logistics,
      commissions: entity.commissions,
      otherExpenses: entity.otherExpenses,
      currency: entity.currency,
    );
  }
}

class CalculationNotifier extends StateNotifier<CalculationState> {
  CalculationNotifier() : super(CalculationState());

  void updatePurchasePrice(double value) {
    state = state.copyWith(purchasePrice: value);
  }

  void updateSalePrice(double value) {
    state = state.copyWith(salePrice: value);
  }

  void updateRepair(double value) {
    state = state.copyWith(repair: value);
  }

  void updateLogistics(double value) {
    state = state.copyWith(logistics: value);
  }

  void updateCommissions(double value) {
    state = state.copyWith(commissions: value);
  }

  void updateOtherExpenses(double value) {
    state = state.copyWith(otherExpenses: value);
  }

  void updateCurrency(Currency currency) {
    state = state.copyWith(currency: currency);
  }

  void loadCalculation(CalculationEntity calculation) {
    state = CalculationState.fromEntity(calculation);
  }

  void reset() {
    state = CalculationState();
  }
}

final calculationProvider =
    StateNotifierProvider<CalculationNotifier, CalculationState>((ref) {
  return CalculationNotifier();
});

final calculationEntityProvider = Provider<CalculationEntity>((ref) {
  final state = ref.watch(calculationProvider);
  return state.toEntity();
});

