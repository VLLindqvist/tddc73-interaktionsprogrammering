import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/skeleton.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('Skeleton should expect one text: ', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Skeleton(
            loading: true,
            child: Text('M'),
          ),
        ),
      ),
    );
    await tester.pump();

    // final text = find.text('M');
    // final textIsVisible = await tester.ensureVisible(text);

    // expect(textIsVisible, true);
    final tapTest = await tester.tap(find.widgetWithText(Text, 'M'));
    final isExists = await isPresent(, driver);
    if (isExists) {
      print('widget is present');
    } else {
      print('widget is not present');
    }
  });
}
