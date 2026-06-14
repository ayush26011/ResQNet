import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resqnet/app/app.dart';

void main() {
  testWidgets('ResQNet smoke test — app renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ResQNetApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);

    // Clean up the widget tree to dispose of infinite animation controllers and timers
    await tester.pumpWidget(Container());
    await tester.pump(const Duration(seconds: 2));
  });
}
