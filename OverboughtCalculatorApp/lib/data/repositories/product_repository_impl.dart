import 'package:flutter/foundation.dart' show kIsWeb;
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../database/gta_database.dart';
import '../database/web_storage.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<int> addProduct(ProductEntity product) async {
    if (kIsWeb) {
      return await WebStorage.addProduct(product);
    } else {
      final db = await GTADatabase.database;
      final map = ProductModel.toMap(product);
      map.remove(GTADatabase.columnProductId);
      return await db.insert(GTADatabase.tableProducts, map);
    }
  }

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    if (kIsWeb) {
      return await WebStorage.getAllProducts();
    } else {
      final db = await GTADatabase.database;
      final maps = await db.query(
        GTADatabase.tableProducts,
        orderBy: '${GTADatabase.columnProductCreatedAt} DESC',
      );
      return maps.map((map) => ProductModel.fromMap(map)).toList();
    }
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    if (kIsWeb) {
      await WebStorage.updateProduct(product);
    } else {
      final db = await GTADatabase.database;
      final map = ProductModel.toMap(product);
      await db.update(
        GTADatabase.tableProducts,
        map,
        where: '${GTADatabase.columnProductId} = ?',
        whereArgs: [product.id],
      );
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    if (kIsWeb) {
      await WebStorage.deleteProduct(id);
    } else {
      final db = await GTADatabase.database;
      await db.delete(
        GTADatabase.tableProducts,
        where: '${GTADatabase.columnProductId} = ?',
        whereArgs: [id],
      );
    }
  }
}

