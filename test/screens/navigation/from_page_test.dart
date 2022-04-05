import 'package:bike_tour_app/screens/navigation/from_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test", () {
    testWidgets("Check if widget loads", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: FromPage(),
      )));

      var location = find.byKey(const Key("LocationKey"));
      expect(location, findsOneWidget);

      var map = find.byKey(const Key("MapKey"));
      expect(map, findsOneWidget);
    });
  });
}
