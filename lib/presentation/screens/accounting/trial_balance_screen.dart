import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class TrialBalanceScreen extends ConsumerWidget {
  const TrialBalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('ميزان المراجعة')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildSummaryBox('إجمالي المدين', '1,250,000 ${AppConstants.currency}', AppColors.success),
                    _buildSummaryBox('إجمالي الدائن', '1,250,000 ${AppConstants.currency}', AppColors.error),
                    _buildSummaryBox('الفرق', '0.00 ${AppConstants.currency}', AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: DataTable2(
                  columns: const [
                    DataColumn2(label: Text('رقم الحساب'), size: ColumnSize.S),
                    DataColumn2(label: Text('اسم الحساب'), size: ColumnSize.L),
                    DataColumn2(label: Text('المدين'), size: ColumnSize.M),
                    DataColumn2(label: Text('الدائن'), size: ColumnSize.M),
                  ],
                  rows: [
                    _buildRow('1100', 'النقدية', 500000, 0),
                    _buildRow('1200', 'المدينون', 300000, 0),
                    _buildRow('1300', 'المخزون', 450000, 0),
                    _buildRow('2100', 'الدائنون', 0, 200000),
                    _buildRow('3100', 'رأس المال', 0, 1000000),
                    _buildRow('4100', 'المبيعات', 0, 500000),
                    _buildRow('5100', 'المشتريات', 200000, 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String title, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  DataRow2 _buildRow(String code, String name, double debit, double credit) {
    return DataRow2(
      cells: [
        DataCell(Text(code)),
        DataCell(Text(name)),
        DataCell(Text(debit > 0 ? '${debit.toStringAsFixed(2)} ${AppConstants.currency}' : '-')),
        DataCell(Text(credit > 0 ? '${credit.toStringAsFixed(2)} ${AppConstants.currency}' : '-')),
      ],
    );
  }
}
