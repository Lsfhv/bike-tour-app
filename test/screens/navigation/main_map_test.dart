import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:bike_tour_app/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// class MockAppNavigator extends Mock implements AppNavigator {}

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

    testWidgets("Tap settings", (WidgetTester tester) async {
      // final mockObserver = MockNavigatorObserver();
      // final appNavigator = MockAppNavigator();

      // await tester.pumpWidget(
      //   MaterialApp(
      //     home: const MainMap(),
      //     navigatorObservers: [mockObserver],
      //   ),
      // );

      var settings = find.byKey(const Key("SettingsKey"));
      expect(settings, findsOneWidget);

      await tester.tap(settings);
      await tester.pumpAndSettle();

      // verify(appNavigator.showNextscreen());
      // expect(find.byType(SettingsPage), findsWidgets);
    });

    testWidgets("Test3", (WidgetTester tester) async {});

    testWidgets("Test4", (WidgetTester tester) async {});
  });
}
