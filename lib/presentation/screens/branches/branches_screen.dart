import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class BranchesScreen extends ConsumerWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفروع والمخازن'),
        actions: [
          IconButton(icon: const Icon(Icons.swap_horiz), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBranchCard(
            name: 'الفرع الرئيسي',
            address: 'الجزائر العاصمة',
            manager: 'Sami Banouh',
            products: 1250,
            color: AppColors.primary,
          ),
          _buildBranchCard(
            name: 'فرع وهران',
            address: 'وهران',
            manager: 'أحمد محمد',
            products: 850,
            color: AppColors.secondary,
          ),
          _buildBranchCard(
            name: 'فرع قسنطينة',
            address: 'قسنطينة',
            manager: 'فاطمة علي',
            products: 620,
            color: AppColors.accent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_business),
      ),
    );
  }

  Widget _buildBranchCard({
    required String name,
    required String address,
    required String manager,
    required int products,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.store, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(address, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                _buildBranchInfo('المدير', manager, Icons.person),
                _buildBranchInfo('المنتجات', products.toString(), Icons.inventory),
                _buildBranchInfo('الموظفون', '12', Icons.people),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('تحويل منتجات'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility),
                    label: const Text('عرض المخزون'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchInfo(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
