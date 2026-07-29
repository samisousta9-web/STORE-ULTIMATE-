import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class BatchTrackingScreen extends ConsumerWidget {
  const BatchTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع التشغيلات')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildBatchCard('BATCH-001', 'منتج أ', 100, '2025-06-30', AppColors.success),
          _buildBatchCard('BATCH-002', 'منتج ب', 50, '2025-03-15', AppColors.warning),
          _buildBatchCard('BATCH-003', 'منتج ج', 200, '2024-12-31', AppColors.error),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBatchCard(String batchNumber, String product, int qty, String expiry, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(batchNumber, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                Text('الكمية: $qty', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(product, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('تاريخ الانتهاء: $expiry', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
