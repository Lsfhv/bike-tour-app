import 'package:bike_tour_app/screens/authenticate/forgot_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test", () {
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: ForgotPasswordFrom(),
      )));

      var email = find.byKey(const Key("EmailKey"));
      expect(email, findsOneWidget);

      var reset = find.byKey(const Key("ResetKey"));
      expect(reset, findsOneWidget);

      await tester.enterText(email, r"""test@test.com""");
      expect(find.text(r"""test@test.com"""), findsOneWidget);

      // await tester.tap(reset);
      // await tester.pump();

      // expect(find.text('Please check your email to reset you password'),
      //     findsOneWidget);
    });

    testWidgets("Test2", (WidgetTester tester) async {});

    testWidgets("Test3", (WidgetTester tester) async {});

    testWidgets("Test4", (WidgetTester tester) async {});
  });
}
