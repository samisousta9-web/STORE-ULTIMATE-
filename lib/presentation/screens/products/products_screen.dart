import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/product_model.dart';
import '../../../domain/providers/product_provider.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(productProvider.notifier).loadProducts());
  }

  void _showProductDialog([ProductModel? product]) {
    showDialog(
      context: context,
      builder: (context) => ProductDialog(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Stats
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'ابحث بالاسم، الباركود، أو SKU...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => ref.read(productProvider.notifier).loadProducts(search: v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatChip('الإجمالي', productState.totalCount.toString(), AppColors.primary),
                    _buildStatChip('القيمة', '${productState.totalValue.toStringAsFixed(0)} ${AppConstants.currency}', AppColors.success),
                  ],
                ),
              ],
            ),
          ),
          // Product List
          Expanded(
            child: productState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productState.products.isEmpty
                    ? const Center(child: Text('لا توجد منتجات'))
                    : ListView.builder(
                        itemCount: productState.products.length,
                        itemBuilder: (context, index) {
                          final p = productState.products[index];
                          return _ProductListTile(
                            product: p,
                            onEdit: () => _showProductDialog(p),
                            onDelete: () => _confirmDelete(p),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: color)),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  void _confirmDelete(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف "${product.name}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              ref.read(productProvider.notifier).deleteProduct(product.id!);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductListTile({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.inventory_2, color: AppColors.primary),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SKU: ${product.sku}'),
            Row(
              children: [
                Text('البيع: ${product.salePrice.toStringAsFixed(2)} ${AppConstants.currency}'),
                const SizedBox(width: 12),
                Text('الشراء: ${product.purchasePrice.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: product.isLowStock ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${product.quantity}',
                style: TextStyle(
                  color: product.isLowStock ? AppColors.error : AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                const PopupMenuItem(value: 'delete', child: Text('حذف', style: TextStyle(color: AppColors.error))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDialog extends StatefulWidget {
  final ProductModel? product;
  const ProductDialog({super.key, this.product});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.product?.name ?? '');
  late final _skuController = TextEditingController(text: widget.product?.sku ?? '');
  late final _barcodeController = TextEditingController(text: widget.product?.barcode ?? '');
  late final _purchaseController = TextEditingController(text: widget.product?.purchasePrice.toString() ?? '0');
  late final _saleController = TextEditingController(text: widget.product?.salePrice.toString() ?? '0');
  late final _quantityController = TextEditingController(text: widget.product?.quantity.toString() ?? '0');
  late final _minStockController = TextEditingController(text: widget.product?.minStock.toString() ?? '5');
  late final _taxController = TextEditingController(text: widget.product?.taxRate.toString() ?? '19');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'إضافة منتج' : 'تعديل منتج'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'اسم المنتج *'),
                  validator: (v) => v?.isEmpty ?? true ? 'مطلوب' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _skuController,
                        decoration: const InputDecoration(labelText: 'SKU *'),
                        validator: (v) => v?.isEmpty ?? true ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _barcodeController,
                        decoration: const InputDecoration(labelText: 'الباركود'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _purchaseController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'سعر الشراء *'),
                        validator: (v) => v?.isEmpty ?? true ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _saleController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'سعر البيع *'),
                        validator: (v) => v?.isEmpty ?? true ? 'مطلوب' : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'الكمية *'),
                        validator: (v) => v?.isEmpty ?? true ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _minStockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'الحد الأدنى'),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _taxController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'نسبة الضريبة %'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Save logic here
              Navigator.pop(context);
            }
          },
          child: Text(widget.product == null ? 'إضافة' : 'حفظ'),
        ),
      ],
    );
  }
}
