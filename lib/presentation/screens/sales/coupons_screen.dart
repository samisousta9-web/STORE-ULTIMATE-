import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class CouponsScreen extends ConsumerWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('الكوبونات والعروض')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildCouponCard('SUMMER2024', 'خصم 20%', 'percentage', 20, AppColors.success),
          _buildCouponCard('WELCOME50', 'خصم 5000 د.ج', 'fixed', 5000, AppColors.primary),
          _buildCouponCard('BOGO', 'اشترِ واحداً واحصل على الثاني مجاناً', 'bogo', 0, AppColors.accent),
          _buildCouponCard('FLASH10', 'خصم 10% لفترة محدودة', 'percentage', 10, AppColors.info),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.local_offer),
      ),
    );
  }

  Widget _buildCouponCard(String code, String desc, String type, double value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.local_offer, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(type == 'percentage' ? '$value%' : '${value.toStringAsFixed(0)} ${AppConstants.currency}', style: TextStyle(color: color, fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      const Text('نشط', style: TextStyle(color: AppColors.success, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {},
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                const PopupMenuItem(value: 'deactivate', child: Text('تعطيل')),
                const PopupMenuItem(value: 'delete', child: Text('حذف', style: TextStyle(color: AppColors.error))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
