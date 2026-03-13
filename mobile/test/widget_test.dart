import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billy/main.dart';

void main() {
  testWidgets('Billy app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BillyApp());

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
