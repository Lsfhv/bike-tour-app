import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:bike_tour_app/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("Test", () {
    testWidgets("Test if all components of widget loads",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: MainMap(),
      )));

      var gmap = find.byKey(const Key("GoogleMapKey"));
      expect(gmap, findsOneWidget);

      var settings = find.byKey(const Key("SettingsKey"));
      expect(settings, findsOneWidget);

      var persons = find.byKey(const Key("PersonsKey"));
      expect(persons, findsOneWidget);

      var planjourney = find.byKey(const Key("PlanJourneyKey"));
      expect(planjourney, findsOneWidget);
    });

    testWidgets("Tap settings button", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: MainMap(),
      )));

      var settings = find.byKey(const Key("SettingsKey"));
      expect(settings, findsOneWidget);

      var settings2 = find.byKey(const Key("SettingsKey2"));
      expect(settings2, findsOneWidget);

      await tester.tap(settings2, warnIfMissed: false);
    });

    testWidgets("Tap persons button", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: MainMap(),
      )));

      var persons = find.byKey(const Key("PersonsKey"));
      expect(persons, findsOneWidget);

      await tester.tap(persons, warnIfMissed: false);
    });

    testWidgets("Tap plan journey button", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: MainMap(),
      )));

      var planjourney = find.byKey(const Key("PlanJourneyKey"));
      expect(planjourney, findsOneWidget);

      await tester.tap(planjourney, warnIfMissed: false);
    });
  });
}
