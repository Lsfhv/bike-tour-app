import 'package:bike_tour_app/screens/navigation/location_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test", () {
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: DetailsPage(
          closePage: null,
        ),
      )));
    });

    testWidgets("Test2", (WidgetTester tester) async {});

    testWidgets("Test3", (WidgetTester tester) async {});

    testWidgets("Test4", (WidgetTester tester) async {});
  });
}
