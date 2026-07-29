import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';

class BarcodeScreen extends ConsumerStatefulWidget {
  const BarcodeScreen({super.key});

  @override
  ConsumerState<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends ConsumerState<BarcodeScreen> {
  final _textController = TextEditingController(text: '123456789012');
  String _barcodeType = 'code128';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الباركود و QR'),
        actions: [
          IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'النص / الرقم',
                hintText: 'أدخل النص للباركود',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'code128', label: Text('Barcode')),
                ButtonSegment(value: 'qrcode', label: Text('QR Code')),
              ],
              selected: {_barcodeType},
              onSelectionChanged: (v) => setState(() => _barcodeType = v.first),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _barcodeType == 'qrcode'
                    ? QrImageView(
                        data: _textController.text,
                        version: QrVersions.auto,
                        size: 250,
                        backgroundColor: Colors.white,
                      )
                    : BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: _textController.text,
                        width: 300,
                        height: 120,
                        drawText: true,
                      ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print),
                    label: const Text('طباعة'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: const Text('مشاركة'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
