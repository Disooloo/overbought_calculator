enum Currency {
  rub('RUB', '₽'),
  usd('USD', '\$'),
  eur('EUR', '€');

  const Currency(this.code, this.symbol);
  final String code;
  final String symbol;
}

class CalculationEntity {
  final double purchasePrice;
  final double salePrice;
  final double repair;
  final double logistics;
  final double commissions;
  final double otherExpenses;
  final Currency currency;

  const CalculationEntity({
    required this.purchasePrice,
    required this.salePrice,
    required this.repair,
    required this.logistics,
    required this.commissions,
    required this.otherExpenses,
    required this.currency,
  });

  // Calculated properties
  double get totalExpenses =>
      repair + logistics + commissions + otherExpenses;

  double get investments => purchasePrice + totalExpenses;

  double get profit => salePrice - investments;

  double get margin {
    if (salePrice == 0) return 0;
    return (profit / salePrice) * 100;
  }

  double get roi {
    if (investments == 0) return 0;
    return (profit / investments) * 100;
  }

  double get breakEvenPoint => investments;

  bool get isProfit => profit >= 0;
}

