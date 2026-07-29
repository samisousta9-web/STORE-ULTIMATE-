import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class StocktakeScreen extends ConsumerStatefulWidget {
  const StocktakeScreen({super.key});

  @override
  ConsumerState<StocktakeScreen> createState() => _StocktakeScreenState();
}

class _StocktakeScreenState extends ConsumerState<StocktakeScreen> {
  final _barcodeController = TextEditingController();
  int _scannedCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جرد سريع'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: Text('$_scannedCount', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcodeController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'امسح الباركود أو اكتب SKU...',
                      prefixIcon: Icon(Icons.qr_code_scanner),
                    ),
                    onSubmitted: (v) {
                      setState(() => _scannedCount++);
                      _barcodeController.clear();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 32),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _scannedCount,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.success.withOpacity(0.1),
                      child: const Icon(Icons.check, color: AppColors.success),
                    ),
                    title: Text('منتج #${index + 1}'),
                    subtitle: Text('SKU: SKU-${1000 + index}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.remove), onPressed: () {}),
                        const Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.add), onPressed: () {}),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _scannedCount = 0),
                    icon: const Icon(Icons.clear),
                    label: const Text('إعادة البدء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _scannedCount > 0 ? () {} : null,
                    icon: const Icon(Icons.save),
                    label: const Text('حفظ الجرد'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
