import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('النسخ الاحتياطي')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBackupCard(
              'نسخ احتياطي محلي',
              'حفظ نسخة على الجهاز',
              Icons.sd_storage,
              AppColors.primary,
              () {},
            ),
            const SizedBox(height: 16),
            _buildBackupCard(
              'نسخ احتياطي سحابي',
              'حفظ نسخة على Google Drive',
              Icons.cloud_upload,
              AppColors.secondary,
              () {},
            ),
            const SizedBox(height: 16),
            _buildBackupCard(
              'استعادة من النسخة المحلية',
              'استرجاع البيانات من الجهاز',
              Icons.restore,
              AppColors.success,
              () {},
            ),
            const SizedBox(height: 16),
            _buildBackupCard(
              'استعادة من السحابة',
              'استرجاع البيانات من Google Drive',
              Icons.cloud_download,
              AppColors.info,
              () {},
            ),
            const Spacer(),
            Card(
              color: AppColors.warning.withOpacity(0.1),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info, color: AppColors.warning),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'آخر نسخة احتياطية: 2024-07-29 06:30',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
