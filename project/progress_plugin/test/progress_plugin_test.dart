import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_plugin/progress_modal.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('Progress modal test:', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ProgressModal(labelText: Text("hej"),),
        ),
      ),)
    );

    // Create the Finders.
    final labelFinder = find.text('hej');
    final widgetWithTextFinder = find.widgetWithText(Row, "hej");

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(labelFinder, findsOneWidget);
    expect(widgetWithTextFinder, findsOneWidget);
  });
}
