import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class BalanceSheetScreen extends ConsumerWidget {
  const BalanceSheetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('الميزانية العمومية')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection('الأصول', [
              _buildItem('النقدية', 500000),
              _buildItem('المدينون', 300000),
              _buildItem('المخزون', 450000),
              _buildItem('الأصول الثابتة', 750000),
            ], 2000000),
            _buildSection('الخصوم', [
              _buildItem('الدائنون', 200000),
              _buildItem('القروض', 500000),
            ], 700000),
            _buildSection('حقوق الملكية', [
              _buildItem('رأس المال', 1000000),
              _buildItem('الأرباح المحتجزة', 300000),
            ], 1300000),
            Card(
              color: AppColors.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('إجمالي الأصول = الخصوم + حقوق الملكية', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('2,000,000 ${AppConstants.currency}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items, double total) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const Divider(),
            ...items,
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${total.toStringAsFixed(0)} ${AppConstants.currency}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('${amount.toStringAsFixed(0)} ${AppConstants.currency}'),
        ],
      ),
    );
  }
}
