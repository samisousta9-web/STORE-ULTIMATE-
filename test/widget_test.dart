import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_manager_pro/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StoreManagerProApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Splash screen should display app name', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StoreManagerProApp(),
      ),
    );
    expect(find.text('Store Manager Pro Ultimate'), findsOneWidget);
  });
}
