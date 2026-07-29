import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrintService {
  static Future<void> printInvoice(Map<String, dynamic> invoice) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('Store Manager Pro', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text('by Sami Banouh'),
            pw.Divider(),
            pw.Text('فاتورة ضريبية', style: pw.TextStyle(fontSize: 14)),
            pw.Text('رقم: ${invoice['invoiceNumber']}'),
            pw.SizedBox(height: 10),
            pw.Text('التاريخ: ${invoice['date']}'),
            pw.Divider(),
            pw.Text('الإجمالي: ${invoice['total']} د.ج'),
            pw.SizedBox(height: 20),
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: invoice['invoiceNumber'] ?? 'INV-000',
              width: 100,
              height: 100,
            ),
            pw.SizedBox(height: 10),
            pw.Text('شكراً لتسوقكم!'),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  static Future<void> printBarcode(String data) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.code128(),
            data: data,
            width: 200,
            height: 80,
          ),
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }
}
