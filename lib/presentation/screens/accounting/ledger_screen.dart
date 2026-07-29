import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class LedgerScreen extends ConsumerWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('دفتر الأستاذ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'بحث في دفتر الأستاذ...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('قيود يومية'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: DataTable2(
                  columns: const [
                    DataColumn2(label: Text('التاريخ'), size: ColumnSize.S),
                    DataColumn2(label: Text('رقم الحساب'), size: ColumnSize.S),
                    DataColumn2(label: Text('اسم الحساب'), size: ColumnSize.M),
                    DataColumn2(label: Text('البيان'), size: ColumnSize.L),
                    DataColumn2(label: Text('مدين'), size: ColumnSize.S),
                    DataColumn2(label: Text('دائن'), size: ColumnSize.S),
                    DataColumn2(label: Text('الرصيد'), size: ColumnSize.S),
                  ],
                  rows: [
                    _buildLedgerRow('2024-07-29', '1100', 'النقدية', 'مبيعات نقدية', 50000, 0, 50000),
                    _buildLedgerRow('2024-07-29', '4100', 'المبيعات', 'مبيعات نقدية', 0, 50000, 50000),
                    _buildLedgerRow('2024-07-28', '5100', 'المشتريات', 'شراء بضاعة', 30000, 0, 30000),
                    _buildLedgerRow('2024-07-28', '1100', 'النقدية', 'شراء بضاعة', 0, 30000, 20000),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow2 _buildLedgerRow(String date, String code, String name, String desc, double debit, double credit, double balance) {
    return DataRow2(
      cells: [
        DataCell(Text(date)),
        DataCell(Text(code, style: const TextStyle(fontFamily: 'monospace'))),
        DataCell(Text(name)),
        DataCell(Text(desc)),
        DataCell(Text(debit > 0 ? '${debit.toStringAsFixed(2)} ${AppConstants.currency}' : '-', style: const TextStyle(color: AppColors.success))),
        DataCell(Text(credit > 0 ? '${credit.toStringAsFixed(2)} ${AppConstants.currency}' : '-', style: const TextStyle(color: AppColors.error))),
        DataCell(Text('${balance.toStringAsFixed(2)} ${AppConstants.currency}', style: const TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }
}
