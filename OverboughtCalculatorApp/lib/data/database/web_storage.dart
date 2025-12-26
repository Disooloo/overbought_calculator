import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/product_entity.dart';

class WebStorage {
  static const String _keyTransactions = 'transactions';
  static const String _keyProducts = 'products';

  // Transactions
  static Future<List<TransactionEntity>> getAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyTransactions);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    final transactions = jsonList.map((json) => TransactionEntity(
      id: json['id'] as int?,
      amount: (json['amount'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      type: json['type'] as String?,
    )).toList();
    
    // Сортируем по дате (последняя запись сверху)
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }

  static Future<int> addTransaction(TransactionEntity transaction) async {
    final transactions = await getAllTransactions();
    final maxId = transactions.isEmpty
        ? 0
        : transactions.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b);
    
    final newTransaction = TransactionEntity(
      id: maxId + 1,
      amount: transaction.amount,
      comment: transaction.comment,
      createdAt: transaction.createdAt,
      type: transaction.type,
    );
    
    transactions.add(newTransaction);
    await _saveTransactions(transactions);
    return newTransaction.id!;
  }

  static Future<void> deleteTransaction(int id) async {
    final transactions = await getAllTransactions();
    transactions.removeWhere((t) => t.id == id);
    await _saveTransactions(transactions);
  }

  static Future<void> _saveTransactions(List<TransactionEntity> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = transactions.map((t) => {
      'id': t.id,
      'amount': t.amount,
      'comment': t.comment,
      'created_at': t.createdAt.millisecondsSinceEpoch,
      'type': t.type,
    }).toList();
    await prefs.setString(_keyTransactions, json.encode(jsonList));
  }

  // Products
  static Future<List<ProductEntity>> getAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyProducts);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => ProductEntity(
      id: json['id'] as int?,
      name: json['name'] as String,
      imagePath: json['image_path'] as String?,
      costPrice: (json['cost_price'] as num).toDouble(),
      salePrice: (json['sale_price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
    )).toList();
  }

  static Future<int> addProduct(ProductEntity product) async {
    final products = await getAllProducts();
    final maxId = products.isEmpty
        ? 0
        : products.map((p) => p.id ?? 0).reduce((a, b) => a > b ? a : b);
    
    final newProduct = ProductEntity(
      id: maxId + 1,
      name: product.name,
      imagePath: product.imagePath,
      costPrice: product.costPrice,
      salePrice: product.salePrice,
      quantity: product.quantity,
      createdAt: product.createdAt,
    );
    
    products.add(newProduct);
    await _saveProducts(products);
    return newProduct.id!;
  }

  static Future<void> updateProduct(ProductEntity product) async {
    final products = await getAllProducts();
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
      await _saveProducts(products);
    }
  }

  static Future<void> deleteProduct(int id) async {
    final products = await getAllProducts();
    products.removeWhere((p) => p.id == id);
    await _saveProducts(products);
  }

  static Future<void> _saveProducts(List<ProductEntity> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = products.map((p) => {
      'id': p.id,
      'name': p.name,
      'image_path': p.imagePath,
      'cost_price': p.costPrice,
      'sale_price': p.salePrice,
      'quantity': p.quantity,
      'created_at': p.createdAt.millisecondsSinceEpoch,
    }).toList();
    await prefs.setString(_keyProducts, json.encode(jsonList));
  }
}
