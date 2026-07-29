import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/database/database_helper.dart';
import '../../../data/models/customer_model.dart';

final customersProvider = FutureProvider<List<CustomerModel>>((ref) async {
  final db = await DatabaseHelper().database;
  final result = await db.query('customers', where: 'isActive = 1', orderBy: 'name ASC');
  return result.map((e) => CustomerModel.fromMap(e)).toList();
});

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('العملاء')),
      body: customersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
        data: (customers) {
          if (customers.isEmpty) {
            return const Center(child: Text('لا يوجد عملاء'));
          }
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final c = customers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(c.name[0], style: const TextStyle(color: AppColors.primary)),
                  ),
                  title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (c.phone != null) Text('📞 ${c.phone}'),
                      if (c.email != null) Text('✉️ ${c.email}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${c.balance.toStringAsFixed(2)} ${AppConstants.currency}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      if (c.debt > 0)
                        Text(
                          'دين: ${c.debt.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 11, color: AppColors.error),
                        ),
                      Text(
                        'نقاط: ${c.loyaltyPoints}',
                        style: const TextStyle(fontSize: 11, color: AppColors.success),
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
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
