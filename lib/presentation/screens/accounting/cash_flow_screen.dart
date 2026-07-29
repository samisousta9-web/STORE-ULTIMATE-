import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class CashFlowScreen extends ConsumerWidget {
  const CashFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('التدفقات النقدية')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFlowRow('التدفقات النقدية من الأنشطة التشغيلية', 350000, AppColors.success),
                    _buildFlowRow('التدفقات النقدية من الأنشطة الاستثمارية', -150000, AppColors.error),
                    _buildFlowRow('التدفقات النقدية من الأنشطة التمويلية', -50000, AppColors.warning),
                    const Divider(),
                    _buildFlowRow('صافي التدفق النقدي', 150000, AppColors.primary, isTotal: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 350000, color: AppColors.success)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 150000, color: AppColors.error)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 50000, color: AppColors.warning)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 150000, color: AppColors.primary)]),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          const labels = ['تشغيلية', 'استثمارية', 'تمويلية', 'صافي'];
                          return Text(labels[v.toInt()], style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowRow(String label, double amount, Color color, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            '${amount > 0 ? '+' : ''}${amount.toStringAsFixed(0)} ${AppConstants.currency}',
            style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: color),
          ),
        ],
      ),
    );
  }
}
