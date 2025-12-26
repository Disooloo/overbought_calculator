import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../providers/product_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/product_card.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/transaction_entity.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<String?> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите источник'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Камера'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Галерея'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return null;

    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return null;

      // Для веб используем путь напрямую, для мобильных - сохраняем
      if (kIsWeb) {
        // В веб-версии image.path уже содержит данные
        return image.path;
      } else {
        // Сохраняем изображение в постоянное хранилище
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
        final savedImage = await File(image.path).copy(
          path.join(appDir.path, fileName),
        );
        return savedImage.path;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки изображения: $e')),
        );
      }
      return null;
    }
  }

  Future<void> _addProduct() async {
    final nameController = TextEditingController();
    final costPriceController = TextEditingController();
    final salePriceController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    String? imagePath;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Добавить товар'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Наименование',
                  ),
                ),
                const SizedBox(height: 16),
                // Превью фото
                if (imagePath != null)
                  kIsWeb
                      ? Image.network(
                          imagePath!,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 100,
                              color: Colors.grey[800],
                              child: const Icon(Icons.image),
                            );
                          },
                        )
                      : Image.file(
                          File(imagePath!),
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final path = await _pickImage();
                    if (path != null) {
                      setState(() {
                        imagePath = path;
                      });
                    }
                  },
                  icon: const Icon(Icons.add_photo_alternate),
                  label: Text(imagePath == null ? 'Добавить фото' : 'Изменить фото'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: costPriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Себестоимость',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: salePriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Цена продажи',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Количество',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Введите наименование')),
                  );
                  return;
                }
                final costPrice = double.tryParse(costPriceController.text);
                final salePrice = double.tryParse(salePriceController.text);

                if (costPrice == null || salePrice == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Введите корректные цены')),
                  );
                  return;
                }

                Navigator.pop(context, true);
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      final costPrice = double.parse(costPriceController.text);
      final salePrice = double.parse(salePriceController.text);
      final quantity = double.tryParse(quantityController.text) ?? 1;

      final product = ProductEntity(
        name: nameController.text.trim(),
        imagePath: imagePath,
        costPrice: costPrice,
        salePrice: salePrice,
        quantity: quantity,
        createdAt: DateTime.now(),
      );

      await ref.read(productProvider.notifier).addProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Товар добавлен')),
        );
      }
    }

    nameController.dispose();
    costPriceController.dispose();
    salePriceController.dispose();
    quantityController.dispose();
  }

  Future<void> _sellProduct(ProductEntity product, {double? quantity}) async {
    final qty = quantity ?? product.quantity;
    if (qty > product.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Недостаточно товара')),
      );
      return;
    }

    final profit = product.getProfitForQuantity(qty);

    // Добавляем транзакцию с прибылью
    final transaction = TransactionEntity(
      amount: profit,
      comment: 'Продажа: ${product.name} ($qty шт.)',
      createdAt: DateTime.now(),
      type: 'product_sale',
    );

    await ref.read(transactionProvider.notifier).addTransaction(transaction);

    // Обновляем количество товара или удаляем, если продано всё
    if (qty >= product.quantity) {
      await ref.read(productProvider.notifier).deleteProduct(product.id!);
    } else {
      final updatedProduct = ProductEntity(
        id: product.id,
        name: product.name,
        imagePath: product.imagePath,
        costPrice: product.costPrice,
        salePrice: product.salePrice,
        quantity: product.quantity - qty,
        createdAt: product.createdAt,
      );
      await ref.read(productProvider.notifier).updateProduct(updatedProduct);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Продано на сумму: $profit')),
      );
    }
  }

  Future<void> _sellPart(ProductEntity product) async {
    final quantityController = TextEditingController();

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Продать часть'),
        content: TextField(
          controller: quantityController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Количество (макс: ${product.quantity})',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final qty = double.tryParse(quantityController.text);
              if (qty == null || qty <= 0 || qty > product.quantity) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Введите корректное количество')),
                );
                return;
              }
              Navigator.pop(context, qty);
            },
            child: const Text('Продать'),
          ),
        ],
      ),
    );

    quantityController.dispose();

    if (result != null) {
      await _sellProduct(product, quantity: result);
    }
  }

  Future<void> _cancelProduct(ProductEntity product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Аннулировать товар?'),
        content: Text('Товар "${product.name}" будет удалён без учёта прибыли.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Аннулировать'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(productProvider.notifier).deleteProduct(product.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Товар аннулирован')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет товаров',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onSellAll: () => _sellProduct(product),
                onSellPart: () => _sellPart(product),
                onCancel: () => _cancelProduct(product),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: $error'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        tooltip: 'Добавить товар',
        child: const Icon(Icons.add),
      ),
    );
  }
}

