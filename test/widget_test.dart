import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resqnet/app.dart';

void main() {
  testWidgets('ResQNet smoke test — app renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ResQNetApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
