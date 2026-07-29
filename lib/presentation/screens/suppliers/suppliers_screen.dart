import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/database/database_helper.dart';
import '../../../data/models/supplier_model.dart';

final suppliersProvider = FutureProvider<List<SupplierModel>>((ref) async {
  final db = await DatabaseHelper().database;
  final result = await db.query('suppliers', where: 'isActive = 1', orderBy: 'name ASC');
  return result.map((e) => SupplierModel.fromMap(e)).toList();
});

class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersAsync = ref.watch(suppliersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الموردون')),
      body: suppliersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
        data: (suppliers) {
          if (suppliers.isEmpty) {
            return const Center(child: Text('لا يوجد موردون'));
          }
          return ListView.builder(
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final s = suppliers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.accent.withOpacity(0.1),
                    child: Text(s.name[0], style: const TextStyle(color: AppColors.accent)),
                  ),
                  title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (s.phone != null) Text('📞 ${s.phone}'),
                      if (s.email != null) Text('✉️ ${s.email}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'مدفوع: ${s.paid.toStringAsFixed(2)} ${AppConstants.currency}',
                        style: const TextStyle(fontSize: 11, color: AppColors.success),
                      ),
                      Text(
                        'دين: ${s.debt.toStringAsFixed(2)} ${AppConstants.currency}',
                        style: const TextStyle(fontSize: 11, color: AppColors.error),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.local_shipping),
      ),
    );
  }
}
