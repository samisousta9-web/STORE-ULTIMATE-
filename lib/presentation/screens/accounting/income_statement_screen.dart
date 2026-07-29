import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class IncomeStatementScreen extends ConsumerWidget {
  const IncomeStatementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الدخل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionCard('الإيرادات', [
              _buildItem('المبيعات', 2450000, false),
              _buildItem('إيرادات أخرى', 50000, false),
              _buildTotal('إجمالي الإيرادات', 2500000, false),
            ]),
            _buildSectionCard('تكلفة البضاعة المباعة', [
              _buildItem('مشتريات البضاعة', 1200000, true),
              _buildItem('مصاريف الشحن', 30000, true),
              _buildTotal('إجمالي التكلفة', 1230000, true),
            ]),
            _buildSectionCard('مصاريف التشغيل', [
              _buildItem('رواتب الموظفين', 450000, true),
              _buildItem('الإيجار', 200000, true),
              _buildItem('الكهرباء والماء', 80000, true),
              _buildItem('صيانة', 60000, true),
              _buildItem('مصاريف أخرى', 60000, true),
              _buildTotal('إجمالي المصاريف', 850000, true),
            ]),
            Card(
              color: AppColors.success.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('صافي الربح', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('420,000 ${AppConstants.currency}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.success)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, double amount, bool isExpense) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('${amount.toStringAsFixed(2)} ${AppConstants.currency}', style: TextStyle(color: isExpense ? AppColors.error : AppColors.success)),
        ],
      ),
    );
  }

  Widget _buildTotal(String label, double amount, bool isExpense) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('${amount.toStringAsFixed(2)} ${AppConstants.currency}', style: TextStyle(fontWeight: FontWeight.bold, color: isExpense ? AppColors.error : AppColors.success)),
        ],
      ),
    );
  }
}
