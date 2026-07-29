import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class HoldInvoicesScreen extends ConsumerWidget {
  const HoldInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('الفواتير المعلقة')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.pause_circle, color: AppColors.warning),
              title: Text('فاتورة معلقة #${index + 1}'),
              subtitle: Text('العميل: عميل نقدي | العناصر: ${3 + index}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${(15000 + index * 5000).toStringAsFixed(0)} ${AppConstants.currency}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('منذ ${index + 1} دقائق', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
