class TransactionEntity {
  final int? id;
  final double amount; // Положительное или отрицательное число
  final String comment;
  final DateTime createdAt;
  final String? type; // 'manual' или 'product_sale'

  const TransactionEntity({
    this.id,
    required this.amount,
    required this.comment,
    required this.createdAt,
    this.type,
  });

  bool get isIncome => amount > 0;
  bool get isExpense => amount < 0;
}

