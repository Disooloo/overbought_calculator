class ProductEntity {
  final int? id;
  final String name;
  final String? imagePath; // Путь к сохранённому фото
  final double costPrice; // Себестоимость
  final double salePrice; // Цена продажи
  final double quantity; // Количество
  final DateTime createdAt;

  const ProductEntity({
    this.id,
    required this.name,
    this.imagePath,
    required this.costPrice,
    required this.salePrice,
    required this.quantity,
    required this.createdAt,
  });

  // Прибыль с единицы товара
  double get profitPerUnit => salePrice - costPrice;

  // Общая прибыль при продаже всего количества
  double get totalProfit => profitPerUnit * quantity;

  // Прибыль при продаже части товара
  double getProfitForQuantity(double qty) {
    return profitPerUnit * qty;
  }
}

