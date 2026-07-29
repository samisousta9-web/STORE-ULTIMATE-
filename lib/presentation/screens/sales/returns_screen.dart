import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class ReturnsScreen extends ConsumerWidget {
  const ReturnsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('المرتجعات')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ExpansionTile(
              leading: const Icon(Icons.assignment_return, color: AppColors.error),
              title: Text('مرتجع #RET-00${index + 1}'),
              subtitle: Text('الفاتورة الأصلية: INV-12345${index}'),
              children: [
                ListTile(
                  title: const Text('سبب الإرجاع'),
                  subtitle: const Text('منتج تالف'),
                ),
                ListTile(
                  title: const Text('المبلغ المسترجع'),
                  trailing: Text('${(5000 + index * 2000).toStringAsFixed(0)} ${AppConstants.currency}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
                ),
                ButtonBar(
                  children: [
                    TextButton(onPressed: () {}, child: const Text('عرض الفاتورة')),
                    ElevatedButton(onPressed: () {}, child: const Text('معالجة')),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('مرتجع جديد'),
      ),
    );
  }
}
