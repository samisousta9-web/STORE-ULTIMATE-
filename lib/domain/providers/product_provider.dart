import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/database_helper.dart';
import '../../data/models/product_model.dart';

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier();
});

final lowStockProvider = FutureProvider<List<ProductModel>>((ref) async {
  final db = await DatabaseHelper().database;
  final result = await db.rawQuery('''
    SELECT * FROM products 
    WHERE quantity <= minStock AND isActive = 1
    ORDER BY quantity ASC
  ''');
  return result.map((e) => ProductModel.fromMap(e)).toList();
});

final productSearchProvider = StateProvider<String>((ref) => '');

class ProductState {
  final List<ProductModel> products;
  final bool isLoading;
  final String? error;
  final int totalCount;
  final double totalValue;

  ProductState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.totalCount = 0,
    this.totalValue = 0.0,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    String? error,
    int? totalCount,
    double? totalValue,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      totalCount: totalCount ?? this.totalCount,
      totalValue: totalValue ?? this.totalValue,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier() : super(ProductState());

  final DatabaseHelper _db = DatabaseHelper();

  Future<void> loadProducts({String? search, int? categoryId, int? branchId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final db = await _db.database;

      String whereClause = 'isActive = 1';
      List<dynamic> whereArgs = [];

      if (search != null && search.isNotEmpty) {
        whereClause += ' AND (name LIKE ? OR barcode LIKE ? OR sku LIKE ?)';
        whereArgs.addAll(['%\$search%', '%\$search%', '%\$search%']);
      }

      if (categoryId != null) {
        whereClause += ' AND categoryId = ?';
        whereArgs.add(categoryId);
      }

      if (branchId != null) {
        whereClause += ' AND branchId = ?';
        whereArgs.add(branchId);
      }

      final result = await db.query(
        'products',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'name ASC',
      );

      final products = result.map((e) => ProductModel.fromMap(e)).toList();

      final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM products WHERE isActive = 1');
      final totalCount = countResult.first['count'] as int;

      final valueResult = await db.rawQuery('''
        SELECT SUM(purchasePrice * quantity) as totalValue 
        FROM products WHERE isActive = 1
      ''');
      final totalValue = (valueResult.first['totalValue'] as num?)?.toDouble() ?? 0.0;

      state = state.copyWith(
        products: products,
        isLoading: false,
        totalCount: totalCount,
        totalValue: totalValue,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ أثناء تحميل المنتجات',
      );
    }
  }

  Future<bool> addProduct(ProductModel product) async {
    try {
      final db = await _db.database;
      await db.insert('products', product.toMap());
      await loadProducts();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'حدث خطأ أثناء إضافة المنتج');
      return false;
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    try {
      final db = await _db.database;
      await db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      await loadProducts();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'حدث خطأ أثناء تحديث المنتج');
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final db = await _db.database;
      await db.update(
        'products',
        {'isActive': 0},
        where: 'id = ?',
        whereArgs: [id],
      );
      await loadProducts();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'حدث خطأ أثناء حذف المنتج');
      return false;
    }
  }

  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      final db = await _db.database;
      final result = await db.query(
        'products',
        where: 'barcode = ? AND isActive = 1',
        whereArgs: [barcode],
      );
      if (result.isNotEmpty) {
        return ProductModel.fromMap(result.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
