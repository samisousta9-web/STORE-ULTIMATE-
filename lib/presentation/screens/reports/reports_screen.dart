import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _selectedCategory = 'sales';

  final _categories = [
    _ReportCategory('sales', 'المبيعات', Icons.point_of_sale, [
      _Report('تقرير المبيعات اليومية', Icons.today),
      _Report('تقرير المبيعات الشهرية', Icons.calendar_month),
      _Report('تقرير المبيعات السنوية', Icons.calendar_today),
      _Report('تقرير المنتجات الأكثر مبيعاً', Icons.trending_up),
      _Report('تقرير المبيعات حسب الموظف', Icons.person),
      _Report('تقرير المبيعات حسب الفرع', Icons.store),
    ]),
    _ReportCategory('inventory', 'المخزون', Icons.warehouse, [
      _Report('تقرير حركة المخزون', Icons.sync),
      _Report('تقرير المنتجات منخفضة المخزون', Icons.warning),
      _Report('تقرير المنتجات منتهية الصلاحية', Icons.timer_off),
      _Report('تقرير قيمة المخزون', Icons.attach_money),
      _Report('تقرير الجرد', Icons.fact_check),
    ]),
    _ReportCategory('customers', 'العملاء', Icons.people, [
      _Report('تقرير العملاء النشطين', Icons.person),
      _Report('تقرير ديون العملاء', Icons.money_off),
      _Report('تقرير نقاط الولاء', Icons.stars),
      _Report('تقرير مشتريات العملاء', Icons.shopping_cart),
    ]),
    _ReportCategory('suppliers', 'الموردون', Icons.local_shipping, [
      _Report('تقرير الموردين', Icons.business),
      _Report('تقرير ديون الموردين', Icons.account_balance),
      _Report('تقرير المشتريات', Icons.shopping_bag),
    ]),
    _ReportCategory('financial', 'المالية', Icons.account_balance_wallet, [
      _Report('تقرير الأرباح والخسائر', Icons.show_chart),
      _Report('تقرير المصروفات', Icons.trending_down),
      _Report('تقرير التدفق النقدي', Icons.waterfall_chart),
      _Report('الميزانية', Icons.pie_chart),
    ]),
    _ReportCategory('employees', 'الموظفون', Icons.badge, [
      _Report('تقرير الحضور والانصراف', Icons.access_time),
      _Report('تقرير الرواتب', Icons.payments),
      _Report('تقرير العمولات', Icons.monetization_on),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    final currentCategory = _categories.firstWhere((c) => c.id == _selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
        actions: [
          IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: () {}),
          IconButton(icon: const Icon(Icons.table_chart), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          // Categories Sidebar
          Container(
            width: 200,
            color: Colors.grey.shade50,
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat.id == _selectedCategory;
                return ListTile(
                  leading: Icon(cat.icon, color: isSelected ? AppColors.primary : Colors.grey),
                  title: Text(cat.name, style: TextStyle(
                    color: isSelected ? AppColors.primary : null,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  )),
                  selected: isSelected,
                  selectedTileColor: AppColors.primary.withOpacity(0.1),
                  onTap: () => setState(() => _selectedCategory = cat.id),
                );
              },
            ),
          ),
          // Reports List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: currentCategory.reports.length,
              itemBuilder: (context, index) {
                final report = currentCategory.reports[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(report.icon, color: AppColors.primary),
                    ),
                    title: Text(report.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.picture_as_pdf, color: AppColors.error), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.table_chart, color: AppColors.success), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.visibility, color: AppColors.primary), onPressed: () {}),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCategory {
  final String id;
  final String name;
  final IconData icon;
  final List<_Report> reports;
  _ReportCategory(this.id, this.name, this.icon, this.reports);
}

class _Report {
  final String name;
  final IconData icon;
  _Report(this.name, this.icon);
}
