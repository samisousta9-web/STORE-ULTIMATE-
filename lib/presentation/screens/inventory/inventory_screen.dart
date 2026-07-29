import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/database/database_helper.dart';
import '../../../data/models/product_model.dart';

final inventoryProvider = FutureProvider<List<ProductModel>>((ref) async {
  final db = await DatabaseHelper().database;
  final result = await db.query('products', where: 'isActive = 1', orderBy: 'quantity ASC');
  return result.map((e) => ProductModel.fromMap(e)).toList();
});

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المخزون'),
        actions: [
          IconButton(icon: const Icon(Icons.sync), onPressed: () {}),
          IconButton(icon: const Icon(Icons.swap_horiz), onPressed: () {}),
        ],
      ),
      body: inventoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
        data: (products) {
          final lowStock = products.where((p) => p.isLowStock).toList();
          final normal = products.where((p) => !p.isLowStock).toList();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              if (lowStock.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('مخزون منخفض', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ...lowStock.map((p) => _InventoryCard(product: p, isAlert: true)),
              ],
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('جميع المنتجات', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...normal.map((p) => _InventoryCard(product: p)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('جرد جديد'),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final ProductModel product;
  final bool isAlert;
  const _InventoryCard({required this.product, this.isAlert = false});

  @override
  Widget build(BuildContext context) {
    final stockPercent = product.minStock > 0
        ? (product.quantity / (product.minStock * 3)).clamp(0.0, 1.0)
        : 1.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isAlert ? AppColors.error.withOpacity(0.05) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAlert ? AppColors.error : AppColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${product.quantity}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: stockPercent,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                isAlert ? AppColors.error : AppColors.success,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الحد الأدنى: ${product.minStock}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text('SKU: ${product.sku}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
