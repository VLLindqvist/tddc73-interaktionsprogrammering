import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/skeleton.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key key, @required this.text}) : super(key: key);

  final Widget text;

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(46, 46, 46, 1.0),
      child: Column(
        children: <Widget>[
          Skeleton(
            loading: _loading,
            child: widget.text,
          ),
          Switch(
            value: _loading,
            onChanged: (value) {
              setState(() {
                _loading = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  // A test that first loads a Skeleton with the loading prop true
  // and then changing it to false, while testing if the correct decentant is visible.
  testWidgets('Skeleton loading prop change', (WidgetTester tester) async {
    const Key testWidgetKey = Key('testWidget');

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TestWidget(
            key: testWidgetKey,
            text: Text('M'),
          ),
        ),
      ),
    );

    // The test widget defined as the TestWidget class in the top of this document
    // It has the key we defined in the top of this function
    final StatefulElement testWidget =
        tester.element(find.byKey(testWidgetKey));
    // The state of the test widget (_loading)
    final TestWidgetState testWidgetState = testWidget.state as TestWidgetState;

    // Test if the states are correct and if _loading is true (which it should be initially)
    expect(tester.element(find.byKey(testWidgetKey)), equals(testWidget));
    expect(testWidget.state, equals(testWidgetState));
    expect(testWidgetState._loading, true);

    // A finder which search for the text "m".
    // It shouldn't find anything, since _loading is true,
    // which means that the Skeleton screen is currently visible
    // (i.e. the child prop into which the text is sent isn't rendered)
    final text = find.text('M');
    expect(text, findsNothing);

    // A finder which searchs for elements of type SkeletonPlaceholder,
    // which is the default placeholder prop for Skeleton.
    // It should be found since _loading is true.
    final skeletonPlaceholder = find.byType(SkeletonPlaceholder);
    expect(skeletonPlaceholder, findsOneWidget);

    // Simulate a tap on the switch button, which changes the state so that _loading is false.
    await tester.tap(find.byType(Switch));
    // pumpAndSettle will rerender the screen until there are no frames left,
    // i.e all animations are done.
    await tester.pumpAndSettle();

    // Since _loading now is true, we should find the text "m", but not SkeletonPlaceholder.
    expect(text, findsOneWidget);
    expect(skeletonPlaceholder, findsNothing);
  });
}
