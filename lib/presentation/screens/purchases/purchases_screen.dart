import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class PurchasesScreen extends ConsumerWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المشتريات'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'أوامر الشراء'),
              Tab(text: 'الاستلام'),
              Tab(text: 'فواتير الموردين'),
              Tab(text: 'المرتجعات'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PurchaseOrdersTab(),
            _ReceivingTab(),
            _SupplierInvoicesTab(),
            _ReturnsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('أمر شراء جديد'),
        ),
      ),
    );
  }
}

class _PurchaseOrdersTab extends StatelessWidget {
  const _PurchaseOrdersTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('قائمة أوامر الشراء'));
  }
}

class _ReceivingTab extends StatelessWidget {
  const _ReceivingTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('استلام المنتجات من الموردين'));
  }
}

class _SupplierInvoicesTab extends StatelessWidget {
  const _SupplierInvoicesTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('فواتير الموردين'));
  }
}

class _ReturnsTab extends StatelessWidget {
  const _ReturnsTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('المرتجعات للموردين'));
  }
}
