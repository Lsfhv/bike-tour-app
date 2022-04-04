import 'package:bike_tour_app/screens/authenticate/forgot_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test", () {
    testWidgets("Check widgets existence", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: ForgotPasswordFrom(),
      )));

      var emailField = find.byKey(const Key("EmailKey"));
      expect(emailField, findsOneWidget);

      var resetButton = find.byKey(const Key("ResetKey"));  
      expect(resetButton, findsOneWidget);

      await tester.enterText(emailField, r"""test@test.com""");
      expect(find.text(r"""test@test.com"""), findsOneWidget);

      
      // await tester.tap(resetButton);
      // await tester.pumpAndSettle();
      // expect(find.text('Please check your email to reset you password'), findsOneWidget);
    });

    testWidgets("Test2", (WidgetTester tester) async {});

    testWidgets("Test3", (WidgetTester tester) async {});

    testWidgets("Test4", (WidgetTester tester) async {});
  });
}
