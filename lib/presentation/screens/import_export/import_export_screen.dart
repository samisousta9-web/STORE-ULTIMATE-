import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class ImportExportScreen extends ConsumerWidget {
  const ImportExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('استيراد وتصدير')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Import Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.file_upload, color: AppColors.primary),
                        SizedBox(width: 12),
                        Text('استيراد البيانات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('اختر نوع الملف واستورد البيانات بسهولة'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormatButton('Excel', Icons.table_chart, AppColors.success, () {}),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFormatButton('CSV', Icons.description, AppColors.info, () {}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Export Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.file_download, color: AppColors.secondary),
                        SizedBox(width: 12),
                        Text('تصدير البيانات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('صدر بياناتك بصيغ مختلفة'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormatButton('Excel', Icons.table_chart, AppColors.success, () {}),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFormatButton('CSV', Icons.description, AppColors.info, () {}),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFormatButton('PDF', Icons.picture_as_pdf, AppColors.error, () {}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                        'تأكد من صحة البيانات قبل الاستيراد. يتم التحقق من البيانات تلقائياً.',
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

  Widget _buildFormatButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
