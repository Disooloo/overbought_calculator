import '../../domain/entities/product_entity.dart';
import '../database/gta_database.dart';

class ProductModel {
  static Map<String, dynamic> toMap(ProductEntity entity) {
    return {
      GTADatabase.columnProductId: entity.id,
      GTADatabase.columnName: entity.name,
      GTADatabase.columnImagePath: entity.imagePath,
      GTADatabase.columnCostPrice: entity.costPrice,
      GTADatabase.columnSalePrice: entity.salePrice,
      GTADatabase.columnQuantity: entity.quantity,
      GTADatabase.columnProductCreatedAt:
          entity.createdAt.millisecondsSinceEpoch,
    };
  }

  static ProductEntity fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      id: map[GTADatabase.columnProductId] as int?,
      name: map[GTADatabase.columnName] as String,
      imagePath: map[GTADatabase.columnImagePath] as String?,
      costPrice: map[GTADatabase.columnCostPrice] as double,
      salePrice: map[GTADatabase.columnSalePrice] as double,
      quantity: map[GTADatabase.columnQuantity] as double,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[GTADatabase.columnProductCreatedAt] as int,
      ),
    );
  }
}

