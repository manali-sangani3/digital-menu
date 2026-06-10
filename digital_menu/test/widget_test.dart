// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:digital_menu/app.dart';

void main() {
  testWidgets('Smoke test for digital menu main page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalMenuApp());

    // Verify that the initial customer view renders.
    expect(find.text('Digital Menu Customer View'), findsOneWidget);
    expect(find.text('Non-existent text'), findsNothing);
  });
}
