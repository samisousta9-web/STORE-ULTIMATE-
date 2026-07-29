import '../../data/database/database_helper.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final DatabaseHelper _db = DatabaseHelper();

  // Predict products that will run out soon
  Future<List<Map<String, dynamic>>> predictLowStock() async {
    final db = await _db.database;
    final result = await db.rawQuery('''
      SELECT p.*,
        COALESCE(AVG(si.quantity), 0) as avgDailySales,
        CASE 
          WHEN COALESCE(AVG(si.quantity), 0) > 0 
          THEN CAST(p.quantity / COALESCE(AVG(si.quantity), 1) AS INTEGER)
          ELSE 999
        END as daysUntilStockout
      FROM products p
      LEFT JOIN sale_items si ON p.id = si.productId
      LEFT JOIN sales s ON si.saleId = s.id AND s.createdAt >= date('now', '-30 days')
      WHERE p.isActive = 1
      GROUP BY p.id
      HAVING daysUntilStockout <= 7 OR p.quantity <= p.minStock
      ORDER BY daysUntilStockout ASC
    ''');
    return result;
  }

  // Analyze sales trends
  Future<List<Map<String, dynamic>>> analyzeSalesTrends() async {
    final db = await _db.database;
    return await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', s.createdAt) as month,
        COUNT(*) as totalInvoices,
        SUM(s.total) as totalSales,
        SUM(si.quantity * (si.unitPrice - p.purchasePrice)) as totalProfit
      FROM sales s
      JOIN sale_items si ON s.id = si.saleId
      JOIN products p ON si.productId = p.id
      WHERE s.status = 'completed'
      GROUP BY strftime('%Y-%m', s.createdAt)
      ORDER BY month DESC
      LIMIT 12
    ''');
  }

  // Suggest reorder quantities
  Future<List<Map<String, dynamic>>> suggestReorder() async {
    final db = await _db.database;
    return await db.rawQuery('''
      SELECT p.*,
        COALESCE(AVG(si.quantity), 0) as avgMonthlySales,
        CASE 
          WHEN COALESCE(AVG(si.quantity), 0) > 0 
          THEN CAST(COALESCE(AVG(si.quantity), 0) * 2 - p.quantity AS INTEGER)
          ELSE p.minStock * 2
        END as suggestedReorder
      FROM products p
      LEFT JOIN sale_items si ON p.id = si.productId
      LEFT JOIN sales s ON si.saleId = s.id AND s.createdAt >= date('now', '-30 days')
      WHERE p.isActive = 1
      GROUP BY p.id
      HAVING suggestedReorder > 0
      ORDER BY suggestedReorder DESC
    ''');
  }

  // Product profitability analysis
  Future<List<Map<String, dynamic>>> analyzeProductProfitability() async {
    final db = await _db.database;
    return await db.rawQuery('''
      SELECT 
        p.name,
        p.sku,
        SUM(si.quantity) as totalSold,
        SUM(si.quantity * si.unitPrice) as totalRevenue,
        SUM(si.quantity * p.purchasePrice) as totalCost,
        SUM(si.quantity * (si.unitPrice - p.purchasePrice)) as totalProfit,
        ROUND((SUM(si.quantity * (si.unitPrice - p.purchasePrice)) / NULLIF(SUM(si.quantity * si.unitPrice), 0)) * 100, 2) as profitMargin
      FROM products p
      LEFT JOIN sale_items si ON p.id = si.productId
      LEFT JOIN sales s ON si.saleId = s.id AND s.status = 'completed' AND s.createdAt >= date('now', '-90 days')
      WHERE p.isActive = 1
      GROUP BY p.id
      ORDER BY totalProfit DESC
      LIMIT 20
    ''');
  }

  // Generate smart report summary
  Future<Map<String, dynamic>> generateSmartSummary() async {
    final db = await _db.database;

    final todaySales = await db.rawQuery('''
      SELECT COALESCE(SUM(total), 0) as amount, COUNT(*) as count
      FROM sales WHERE date(createdAt) = date('now') AND status = 'completed'
    ''');

    final weekSales = await db.rawQuery('''
      SELECT COALESCE(SUM(total), 0) as amount
      FROM sales WHERE createdAt >= date('now', '-7 days') AND status = 'completed'
    ''');

    final topProduct = await db.rawQuery('''
      SELECT p.name, SUM(si.quantity) as qty
      FROM sale_items si
      JOIN products p ON si.productId = p.id
      JOIN sales s ON si.saleId = s.id AND s.createdAt >= date('now', '-7 days')
      GROUP BY p.id ORDER BY qty DESC LIMIT 1
    ''');

    final lowStock = await db.rawQuery('''
      SELECT COUNT(*) as count FROM products WHERE quantity <= minStock AND isActive = 1
    ''');

    return {
      'todaySales': (todaySales.first['amount'] as num?)?.toDouble() ?? 0,
      'todayInvoices': (todaySales.first['count'] as num?)?.toInt() ?? 0,
      'weekSales': (weekSales.first['amount'] as num?)?.toDouble() ?? 0,
      'topProduct': topProduct.isNotEmpty ? topProduct.first['name'] : 'لا يوجد',
      'lowStockCount': (lowStock.first['count'] as num?)?.toInt() ?? 0,
    };
  }
}
