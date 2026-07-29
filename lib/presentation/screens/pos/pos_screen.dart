import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/database/database_helper.dart';
import '../../../domain/providers/product_provider.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final List<CartItem> _cart = [];
  final _searchController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _taxController = TextEditingController(text: '19');
  String _paymentMethod = 'cash';
  int? _selectedCustomerId;
  String _customerName = 'عميل نقدي';

  double get _subtotal => _cart.fold(0, (sum, item) => sum + item.total);
  double get _discount => double.tryParse(_discountController.text) ?? 0;
  double get _taxRate => double.tryParse(_taxController.text) ?? 0;
  double get _taxAmount => _subtotal * _taxRate / 100;
  double get _total => _subtotal + _taxAmount - _discount;

  void _addToCart(ProductModel product) {
    final existingIndex = _cart.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      setState(() => _cart[existingIndex].quantity++);
    } else {
      setState(() => _cart.add(CartItem(product: product)));
    }
  }

  void _removeFromCart(int index) {
    setState(() => _cart.removeAt(index));
  }

  void _updateQuantity(int index, int qty) {
    if (qty <= 0) {
      _removeFromCart(index);
    } else {
      setState(() => _cart[index].quantity = qty);
    }
  }

  Future<void> _completeSale() async {
    if (_cart.isEmpty) return;

    final db = await DatabaseHelper().database;
    final invoiceNumber = 'INV-${DateTime.now().millisecondsSinceEpoch}';

    final sale = SaleModel(
      invoiceNumber: invoiceNumber,
      customerId: _selectedCustomerId,
      userId: 1,
      branchId: 1,
      subtotal: _subtotal,
      taxAmount: _taxAmount,
      discountAmount: _discount,
      total: _total,
      paid: _total,
      paymentMethod: _paymentMethod,
      status: 'completed',
      createdAt: DateTime.now(),
    );

    final saleId = await db.insert('sales', sale.toMap());

    for (var item in _cart) {
      await db.insert('sale_items', {
        'saleId': saleId,
        'productId': item.product.id,
        'productName': item.product.name,
        'unitPrice': item.product.salePrice,
        'quantity': item.quantity,
        'discount': 0,
        'tax': item.product.taxRate,
        'total': item.total,
      });

      await db.rawUpdate(
        'UPDATE products SET quantity = quantity - ? WHERE id = ?',
        [item.quantity, item.product.id],
      );

      await db.insert('inventory_movements', {
        'productId': item.product.id,
        'type': 'sale',
        'quantity': -item.quantity,
        'referenceId': saleId,
        'referenceType': 'sale',
        'userId': 1,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    setState(() => _cart.clear());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إتمام البيع بنجاح - $invoiceNumber'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _scanBarcode() async {
    // In real app: use barcode_scan2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح الباركود'),
        content: const Text('ميزة المسح ستعمل على الجهاز الفعلي'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final searchQuery = ref.watch(productSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('نقطة البيع'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
          IconButton(
            icon: const Icon(Icons.pause_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // Products Panel
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ابحث بالاسم أو الباركود...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(productSearchProvider.notifier).state = '';
                        },
                      ),
                    ),
                    onChanged: (v) {
                      ref.read(productSearchProvider.notifier).state = v;
                      ref.read(productProvider.notifier).loadProducts(search: v);
                    },
                  ),
                ),
                Expanded(
                  child: productState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : productState.products.isEmpty
                          ? const Center(child: Text('لا توجد منتجات'))
                          : GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: productState.products.length,
                              itemBuilder: (context, index) {
                                final product = productState.products[index];
                                return _ProductCard(
                                  product: product,
                                  onTap: () => _addToCart(product),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
          // Cart Panel
          Container(
            width: 380,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.primary,
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_cart, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'السلة (${_cart.length})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _customerName,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _cart.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('السلة فارغة', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _cart.length,
                          itemBuilder: (context, index) {
                            final item = _cart[index];
                            return ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.inventory, color: AppColors.primary),
                              ),
                              title: Text(item.product.name,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${item.product.salePrice.toStringAsFixed(2)} ${AppConstants.currency}',
                                style: const TextStyle(fontSize: 11),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                                    onPressed: () => _updateQuantity(index, item.quantity - 1),
                                  ),
                                  Text('${item.quantity}',
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 20),
                                    onPressed: () => _updateQuantity(index, item.quantity + 1),
                                  ),
                                  Text(
                                    '${item.total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Totals
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTotalRow('المجموع الفرعي', _subtotal),
                      _buildTotalRow('الضريبة ($_taxRate%)', _taxAmount),
                      _buildTotalRow('الخصم', _discount, isNegative: true),
                      const Divider(),
                      _buildTotalRow('الإجمالي', _total, isTotal: true),
                      const SizedBox(height: 12),
                      // Payment Method
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'cash', label: Text('نقدي'), icon: Icon(Icons.money)),
                          ButtonSegment(value: 'card', label: Text('بطاقة'), icon: Icon(Icons.credit_card)),
                          ButtonSegment(value: 'mixed', label: Text('مختلط'), icon: Icon(Icons.payments)),
                        ],
                        selected: {_paymentMethod},
                        onSelectionChanged: (v) => setState(() => _paymentMethod = v.first),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => setState(() => _cart.clear()),
                              icon: const Icon(Icons.clear),
                              label: const Text('إلغاء'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _cart.isEmpty ? null : _completeSale,
                              icon: const Icon(Icons.check_circle),
                              label: const Text('إتمام البيع', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double value,
      {bool isTotal = false, bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14)),
          Text(
            '${isNegative ? '-' : ''}${value.toStringAsFixed(2)} ${AppConstants.currency}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final ProductModel product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
  double get total => product.salePrice * quantity;
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: AppColors.primary.withOpacity(0.05),
                child: const Center(
                  child: Icon(Icons.inventory_2, size: 40, color: AppColors.primary),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${product.salePrice.toStringAsFixed(2)} ${AppConstants.currency}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: product.isLowStock ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${product.quantity}',
                          style: TextStyle(
                            fontSize: 10,
                            color: product.isLowStock ? AppColors.error : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
