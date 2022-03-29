import 'package:bike_tour_app/screens/authenticate/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Accept valid passwords", () {
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignInForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordFieldKey"));
      expect(passwordField, findsOneWidget);

      var loginButton = find.byKey(const Key("LoginContainer"));
      expect(loginButton, findsOneWidget);

      await tester.enterText(passwordField, r"""qQqQqQqQq1010!*&$""");
      expect(find.text(r"""qQqQqQqQq1010!*&$"""), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(
          find.text(
              r"""Password must be at least one digit [0-9], at least one lowercase character [a-z], at least one uppercase character [A-Z], at least one special character [!@#\$&*~], at least 8 characters in length."""),
          findsNothing);
    });

    testWidgets("Test2", (WidgetTester tester) async {});

    testWidgets("Test3", (WidgetTester tester) async {});

    testWidgets("Test4", (WidgetTester tester) async {});
  });

  group("Test invalid password", () {
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignInForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordFieldKey"));
      expect(passwordField, findsOneWidget);

      var loginButton = find.byKey(const Key("LoginContainer"));
      expect(loginButton, findsOneWidget);

      await tester.enterText(passwordField, r"""password123""");
      expect(find.text(r"""password123"""), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(
          find.text(
              r"""Password must be at least one digit [0-9], at least one lowercase character [a-z], at least one uppercase character [A-Z], at least one special character [!@#\$&*~], at least 8 characters in length."""),
          findsOneWidget);
    });
  });
}
