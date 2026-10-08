import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:capstone_1/screens/landing/landing_screen.dart';

void main() {
  testWidgets('Landing screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LandingScreen()));
    await tester.pump();

    expect(find.text('Gran Verde Cacao'), findsOneWidget);
  });
}
