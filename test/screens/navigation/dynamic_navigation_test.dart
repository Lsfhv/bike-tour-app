import 'package:bike_tour_app/screens/navigation/dynamic_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test", () {
    testWidgets("Test1", (WidgetTester tester) async {
      // await tester.pumpWidget(const MaterialApp(
      //     home: Scaffold(
      //   body: DynamicNavigation(),
      // )));

      await tester.pumpWidget(const DynamicNavigation());

      // var cancelIcon = find.byKey(const Key("IconBackspace"));
      // expect(cancelIcon, findsOneWidget);
      // var googlemap = find.byKey(const Key("GoogleMap"));
      // expect(googlemap, findsOneWidget);
    });

    testWidgets("Test2", (WidgetTester tester) async {});

    testWidgets("Test3", (WidgetTester tester) async {});

    testWidgets("Test4", (WidgetTester tester) async {});
  });
}
