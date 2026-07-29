import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class AccountingScreen extends ConsumerWidget {
  const AccountingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المحاسبة'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الإيرادات', icon: Icon(Icons.trending_up)),
              Tab(text: 'المصروفات', icon: Icon(Icons.trending_down)),
              Tab(text: 'الأرباح', icon: Icon(Icons.show_chart)),
              Tab(text: 'الصندوق', icon: Icon(Icons.account_balance_wallet)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRevenueTab(),
            _buildExpensesTab(),
            _buildProfitTab(),
            _buildCashTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('قيود يومية'),
        ),
      ),
    );
  }

  Widget _buildRevenueTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCard('إجمالي الإيرادات', '2,450,000 ${AppConstants.currency}', AppColors.success),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const labels = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'];
                        if (v.toInt() < labels.length) {
                          return Text(labels[v.toInt()], style: const TextStyle(fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 300),
                      FlSpot(1, 450),
                      FlSpot(2, 380),
                      FlSpot(3, 520),
                      FlSpot(4, 480),
                      FlSpot(5, 600),
                    ],
                    color: AppColors.success,
                    barWidth: 3,
                    isCurved: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.success.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCard('إجمالي المصروفات', '850,000 ${AppConstants.currency}', AppColors.error),
          const SizedBox(height: 16),
          _buildExpenseItem('رواتب الموظفين', 450000, AppColors.primary),
          _buildExpenseItem('إيجار المحل', 200000, AppColors.secondary),
          _buildExpenseItem('فواتير الكهرباء', 80000, AppColors.accent),
          _buildExpenseItem('مصاريف صيانة', 60000, AppColors.info),
          _buildExpenseItem('مصاريف أخرى', 60000, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildProfitTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCard('صافي الربح', '1,600,000 ${AppConstants.currency}', AppColors.success),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfitRow('إجمالي المبيعات', '2,450,000', AppColors.success),
                  const Divider(),
                  _buildProfitRow('تكلفة البضاعة', '1,200,000', AppColors.error),
                  _buildProfitRow('المصروفات', '850,000', AppColors.error),
                  const Divider(),
                  _buildProfitRow('صافي الربح', '400,000', AppColors.success, isBold: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCard('رصيد الصندوق', '320,000 ${AppConstants.currency}', AppColors.primary),
          const SizedBox(height: 16),
          _buildCashItem('نقدي', 150000, Icons.money, AppColors.success),
          _buildCashItem('بنك', 120000, Icons.account_balance, AppColors.info),
          _buildCashItem('شيكات', 50000, Icons.description, AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: color, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: color, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseItem(String title, double amount, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(Icons.receipt, color: color)),
        title: Text(title),
        trailing: Text('${amount.toStringAsFixed(0)} ${AppConstants.currency}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildProfitRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text('$value ${AppConstants.currency}', style: TextStyle(color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildCashItem(String title, double amount, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title),
        trailing: Text('${amount.toStringAsFixed(0)} ${AppConstants.currency}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
