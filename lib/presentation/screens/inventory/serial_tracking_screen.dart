import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class SerialTrackingScreen extends ConsumerWidget {
  const SerialTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الأرقام التسلسلية')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildSerialCard('SN-123456789', 'iPhone 15 Pro', 'متاح', AppColors.success),
          _buildSerialCard('SN-987654321', 'Samsung S24', 'مباع', AppColors.error),
          _buildSerialCard('SN-456789123', 'iPad Pro', 'متاح', AppColors.success),
          _buildSerialCard('SN-789123456', 'MacBook Pro', 'تحت الصيانة', AppColors.warning),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSerialCard(String serial, String product, String status, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.confirmation_number, color: color),
        ),
        title: Text(serial, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
        subtitle: Text(product),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }
}
