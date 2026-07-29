import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00', 'ar_DZ');
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd', 'ar').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm', 'ar').format(date);
  }

  static String formatNumber(int number) {
    return NumberFormat('#,###', 'ar').format(number);
  }

  static String generateInvoiceNumber() {
    final now = DateTime.now();
    return 'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(7)}';
  }

  static String generateSKU() {
    final now = DateTime.now();
    return 'SKU-${now.millisecondsSinceEpoch.toString().substring(5)}';
  }
}
