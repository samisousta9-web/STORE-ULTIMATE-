import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/database_helper.dart';

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final db = await DatabaseHelper().database;

  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day).toIso8601String();
  final startOfMonth = DateTime(today.year, today.month, 1).toIso8601String();

  // Today's sales
  final todaySalesResult = await db.rawQuery('''
    SELECT COALESCE(SUM(total), 0) as total, COALESCE(COUNT(*), 0) as count
    FROM sales 
    WHERE createdAt >= ? AND status = 'completed'
  ''', [startOfDay]);
  final todaySales = (todaySalesResult.first['total'] as num?)?.toDouble() ?? 0.0;
  final todayInvoices = (todaySalesResult.first['count'] as num?)?.toInt() ?? 0;

  // Monthly sales
  final monthlySalesResult = await db.rawQuery('''
    SELECT COALESCE(SUM(total), 0) as total
    FROM sales 
    WHERE createdAt >= ? AND status = 'completed'
  ''', [startOfMonth]);
  final monthlySales = (monthlySalesResult.first['total'] as num?)?.toDouble() ?? 0.0;

  // Total products
  final productsResult = await db.rawQuery('SELECT COUNT(*) as count FROM products WHERE isActive = 1');
  final totalProducts = (productsResult.first['count'] as num?)?.toInt() ?? 0;

  // Total customers
  final customersResult = await db.rawQuery('SELECT COUNT(*) as count FROM customers WHERE isActive = 1');
  final totalCustomers = (customersResult.first['count'] as num?)?.toInt() ?? 0;

  // Total suppliers
  final suppliersResult = await db.rawQuery('SELECT COUNT(*) as count FROM suppliers WHERE isActive = 1');
  final totalSuppliers = (suppliersResult.first['count'] as num?)?.toInt() ?? 0;

  // Inventory value
  final inventoryResult = await db.rawQuery('''
    SELECT COALESCE(SUM(purchasePrice * quantity), 0) as value
    FROM products WHERE isActive = 1
  ''');
  final inventoryValue = (inventoryResult.first['value'] as num?)?.toDouble() ?? 0.0;

  // Low stock count
  final lowStockResult = await db.rawQuery('''
    SELECT COUNT(*) as count FROM products 
    WHERE quantity <= minStock AND isActive = 1
  ''');
  final lowStockCount = (lowStockResult.first['count'] as num?)?.toInt() ?? 0;

  // Expenses
  final expensesResult = await db.rawQuery('''
    SELECT COALESCE(SUM(amount), 0) as total
    FROM expenses WHERE createdAt >= ?
  ''', [startOfMonth]);
  final monthlyExpenses = (expensesResult.first['total'] as num?)?.toDouble() ?? 0.0;

  // Profit calculation
  final profitResult = await db.rawQuery('''
    SELECT COALESCE(SUM((si.unitPrice - p.purchasePrice) * si.quantity), 0) as profit
    FROM sale_items si
    JOIN products p ON si.productId = p.id
    JOIN sales s ON si.saleId = s.id
    WHERE s.createdAt >= ? AND s.status = 'completed'
  ''', [startOfMonth]);
  final monthlyProfit = (profitResult.first['profit'] as num?)?.toDouble() ?? 0.0;

  return DashboardData(
    todaySales: todaySales,
    todayInvoices: todayInvoices,
    monthlySales: monthlySales,
    monthlyProfit: monthlyProfit,
    monthlyExpenses: monthlyExpenses,
    totalProducts: totalProducts,
    totalCustomers: totalCustomers,
    totalSuppliers: totalSuppliers,
    inventoryValue: inventoryValue,
    lowStockCount: lowStockCount,
  );
});

class DashboardData {
  final double todaySales;
  final int todayInvoices;
  final double monthlySales;
  final double monthlyProfit;
  final double monthlyExpenses;
  final int totalProducts;
  final int totalCustomers;
  final int totalSuppliers;
  final double inventoryValue;
  final int lowStockCount;

  DashboardData({
    required this.todaySales,
    required this.todayInvoices,
    required this.monthlySales,
    required this.monthlyProfit,
    required this.monthlyExpenses,
    required this.totalProducts,
    required this.totalCustomers,
    required this.totalSuppliers,
    required this.inventoryValue,
    required this.lowStockCount,
  });
}
