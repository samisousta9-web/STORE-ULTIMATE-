import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/dashboard_provider.dart';
import '../pos/pos_screen.dart';
import '../products/products_screen.dart';
import '../customers/customers_screen.dart';
import '../suppliers/suppliers_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';
import '../inventory/inventory_screen.dart';
import '../employees/employees_screen.dart';
import '../invoices/invoices_screen.dart';
import '../accounting/accounting_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
              } else if (value == 'settings') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('الإعدادات')),
              const PopupMenuItem(value: 'logout', child: Text('تسجيل الخروج')),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(dashboardProvider),
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (data) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(authState.user?.fullName ?? 'مستخدم'),
                const SizedBox(height: 16),
                _buildQuickActions(context),
                const SizedBox(height: 16),
                _buildStatsRow(data),
                const SizedBox(height: 16),
                _buildInventoryRow(data),
                const SizedBox(height: 16),
                _buildSalesChart(data),
                const SizedBox(height: 16),
                _buildAlertsCard(data),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PosScreen()),
        ),
        icon: const Icon(Icons.point_of_sale),
        label: const Text('نقطة البيع'),
      ),
    );
  }

  Widget _buildWelcomeCard(String name) {
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مرحباً بك،',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy', 'ar').format(DateTime.now()),
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _Action('نقطة البيع', Icons.point_of_sale, AppColors.primary, const PosScreen()),
      _Action('المنتجات', Icons.inventory_2, AppColors.secondary, const ProductsScreen()),
      _Action('العملاء', Icons.people, AppColors.info, const CustomersScreen()),
      _Action('الموردون', Icons.local_shipping, AppColors.accent, const SuppliersScreen()),
      _Action('المخزون', Icons.warehouse, AppColors.warning, const InventoryScreen()),
      _Action('الفواتير', Icons.receipt_long, AppColors.success, const InvoicesScreen()),
      _Action('التقارير', Icons.bar_chart, Colors.purple, const ReportsScreen()),
      _Action('المحاسبة', Icons.account_balance, Colors.teal, const AccountingScreen()),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.85,
      children: actions.map((action) {
        return InkWell(
          onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => action.screen),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Card(
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(action.icon, color: action.color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  action.label,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsRow(dynamic data) {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard('المبيعات اليوم', '${data.todaySales.toStringAsFixed(2)} ${AppConstants.currency}', Icons.today, AppColors.primary, data.todayInvoices.toString()),
            _buildStatCard('المبيعات الشهرية', '${data.monthlySales.toStringAsFixed(2)} ${AppConstants.currency}', Icons.calendar_month, AppColors.secondary, 'فاتورة'),
          ],
        ),
        Row(
          children: [
            _buildStatCard('صافي الربح', '${data.monthlyProfit.toStringAsFixed(2)} ${AppConstants.currency}', Icons.trending_up, AppColors.success, 'هذا الشهر'),
            _buildStatCard('المصروفات', '${data.monthlyExpenses.toStringAsFixed(2)} ${AppConstants.currency}', Icons.trending_down, AppColors.error, 'هذا الشهر'),
          ],
        ),
      ],
    );
  }

  Widget _buildInventoryRow(dynamic data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildInventoryItem('المنتجات', data.totalProducts.toString(), Icons.inventory_2, AppColors.primary),
            _buildInventoryItem('العملاء', data.totalCustomers.toString(), Icons.people, AppColors.info),
            _buildInventoryItem('الموردون', data.totalSuppliers.toString(), Icons.local_shipping, AppColors.accent),
            _buildInventoryItem('المخزون', '${data.inventoryValue.toStringAsFixed(0)} ${AppConstants.currency}', Icons.warehouse, AppColors.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesChart(dynamic data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('أداء المبيعات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: [data.todaySales, data.monthlySales / 30, data.monthlyProfit].reduce((a, b) => a > b ? a : b) * 1.2,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['اليوم', 'متوسط يومي', 'الربح'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(titles[value.toInt()], style: const TextStyle(fontSize: 10)),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: data.todaySales, color: AppColors.primary, width: 30, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: data.monthlySales / 30, color: AppColors.secondary, width: 30, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: data.monthlyProfit, color: AppColors.success, width: 30, borderRadius: BorderRadius.circular(4))]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsCard(dynamic data) {
    if (data.lowStockCount == 0) return const SizedBox.shrink();
    return Card(
      color: AppColors.error.withOpacity(0.05),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تنبيهات المخزون',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '${data.lowStockCount} منتج على وشك النفاد',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _Action {
  final String label;
  final IconData icon;
  final Color color;
  final Widget screen;
  _Action(this.label, this.icon, this.color, this.screen);
}
