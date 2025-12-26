import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:overbought_calculator/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: GTA5RPCalculatorApp(),
      ),
    );

    // Verify that the app title is displayed.
    expect(find.text('Калькулятор перекупа'), findsOneWidget);
  });
}
