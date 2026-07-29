import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class CompanyScreen extends ConsumerWidget {
  const CompanyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الشركات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCompanyCard(
            name: 'شركتي الرئيسية',
            taxNumber: '123456789',
            address: 'الجزائر العاصمة',
            phone: '0782918108',
            email: 'banouhsami13@gmail.com',
            branches: 3,
            employees: 12,
            isActive: true,
          ),
          _buildCompanyCard(
            name: 'فرع وهران',
            taxNumber: '987654321',
            address: 'وهران',
            phone: '0555123456',
            email: 'oran@company.dz',
            branches: 1,
            employees: 5,
            isActive: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_business),
        label: const Text('شركة جديدة'),
      ),
    );
  }

  Widget _buildCompanyCard({
    required String name,
    required String taxNumber,
    required String address,
    required String phone,
    required String email,
    required int branches,
    required int employees,
    required bool isActive,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.business, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('الرقم الضريبي: $taxNumber', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'نشط' : 'معطل',
                    style: TextStyle(color: isActive ? AppColors.success : AppColors.error, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildInfoRow(Icons.location_on, address),
            _buildInfoRow(Icons.phone, phone),
            _buildInfoRow(Icons.email, email),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatItem('الفروع', branches.toString(), Icons.store),
                _buildStatItem('الموظفون', employees.toString(), Icons.people),
                _buildStatItem('المنتجات', '1250', Icons.inventory),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text('تعديل'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                    label: const Text('الإعدادات'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
