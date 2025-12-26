import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<int> addProduct(ProductEntity product);
  Future<List<ProductEntity>> getAllProducts();
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(int id);
}

