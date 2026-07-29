import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الموظفون'),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}),
          IconButton(icon: const Icon(Icons.assessment), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildEmployeeCard(
            name: 'Sami Banouh',
            role: 'مدير',
            salary: 150000,
            attendance: 'حاضر',
            color: AppColors.primary,
          ),
          _buildEmployeeCard(
            name: 'أحمد محمد',
            role: 'محاسب',
            salary: 80000,
            attendance: 'حاضر',
            color: AppColors.secondary,
          ),
          _buildEmployeeCard(
            name: 'فاطمة علي',
            role: 'موظفة مبيعات',
            salary: 60000,
            attendance: 'غائب',
            color: AppColors.accent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildEmployeeCard({
    required String name,
    required String role,
    required double salary,
    required String attendance,
    required Color color,
  }) {
    final isPresent = attendance == 'حاضر';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Text(name[0], style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(role, style: TextStyle(color: color, fontSize: 12)),
                  Text('الراتب: ${salary.toStringAsFixed(0)} د.ج', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isPresent ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isPresent ? Icons.check_circle : Icons.cancel, size: 16, color: isPresent ? AppColors.success : AppColors.error),
                  const SizedBox(width: 4),
                  Text(attendance, style: TextStyle(color: isPresent ? AppColors.success : AppColors.error, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
