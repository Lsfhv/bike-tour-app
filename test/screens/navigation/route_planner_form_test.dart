import 'package:bike_tour_app/screens/navigation/route_planner_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test", () {
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: DestinationSelector(),
      )));
    });

    testWidgets("Test2", (WidgetTester tester) async {});

    testWidgets("Test3", (WidgetTester tester) async {});

    testWidgets("Test4", (WidgetTester tester) async {});
  });
}
