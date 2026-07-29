import 'package:flutter_test/flutter_test.dart';
import 'package:store_manager_pro/core/utils/helpers.dart';
import 'package:store_manager_pro/core/utils/validators.dart';
import 'package:store_manager_pro/data/models/product_model.dart';

void main() {
  group('Helpers Tests', () {
    test('formatCurrency should format correctly', () {
      final result = Helpers.formatCurrency(1234.56);
      expect(result, isNotEmpty);
    });

    test('generateInvoiceNumber should be unique', () {
      final inv1 = Helpers.generateInvoiceNumber();
      final inv2 = Helpers.generateInvoiceNumber();
      expect(inv1, isNot(equals(inv2)));
    });

    test('generateSKU should not be empty', () {
      final sku = Helpers.generateSKU();
      expect(sku, isNotEmpty);
      expect(sku.startsWith('SKU-'), isTrue);
    });
  });

  group('Validators Tests', () {
    test('required should return error for empty string', () {
      final result = Validators.required('', 'الاسم');
      expect(result, isNotNull);
    });

    test('required should return null for valid string', () {
      final result = Validators.required('test', 'الاسم');
      expect(result, isNull);
    });

    test('email should validate correctly', () {
      expect(Validators.email('test@example.com'), isNull);
      expect(Validators.email('invalid'), isNotNull);
    });

    test('phone should validate Algerian numbers', () {
      expect(Validators.phone('0782918108'), isNull);
      expect(Validators.phone('123'), isNotNull);
    });
  });

  group('Product Model Tests', () {
    test('finalPrice calculation', () {
      final product = ProductModel(
        name: 'Test',
        sku: 'SKU-001',
        categoryId: 1,
        purchasePrice: 100,
        salePrice: 150,
        taxRate: 19,
        discount: 10,
        quantity: 10,
        branchId: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(product.finalPrice, greaterThan(0));
      expect(product.profit, equals(50));
    });

    test('isLowStock should work correctly', () {
      final product = ProductModel(
        name: 'Test',
        sku: 'SKU-002',
        categoryId: 1,
        purchasePrice: 100,
        salePrice: 150,
        quantity: 2,
        minStock: 5,
        branchId: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(product.isLowStock, isTrue);
      expect(product.isOutOfStock, isFalse);
    });
  });
}
