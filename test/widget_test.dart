import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edu_bridge/main.dart';  // correct import

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // pump the actual root widget of your app
    await tester.pumpWidget(const EduBridge());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
