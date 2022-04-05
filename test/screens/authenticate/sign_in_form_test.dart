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
              "Password must be at least one digit [0-9],\nat least one lowercase character [a-z],\nat least one uppercase character [A-Z],\nat least one special character[!@#\\\$&*~],\nat least 8 characters in length."),
          findsNothing);
    });

    testWidgets("Test2", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignInForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordFieldKey"));
      expect(passwordField, findsOneWidget);

      var loginButton = find.byKey(const Key("LoginContainer"));
      expect(loginButton, findsOneWidget);

      await tester.enterText(passwordField, r"""\\\$$$aA1""");
      expect(find.text(r"""\\\$$$aA1"""), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(
          find.text(
              "Password must be at least one digit [0-9],\nat least one lowercase character [a-z],\nat least one uppercase character [A-Z],\nat least one special character[!@#\\\$&*~],\nat least 8 characters in length."),
          findsNothing);
    });

    testWidgets("Test3", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignInForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordFieldKey"));
      expect(passwordField, findsOneWidget);

      var loginButton = find.byKey(const Key("LoginContainer"));
      expect(loginButton, findsOneWidget);

      await tester.enterText(passwordField, r"""$$$$qQ1$$$""");
      expect(find.text(r"""$$$$qQ1$$$"""), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(
          find.text(
              "Password must be at least one digit [0-9],\nat least one lowercase character [a-z],\nat least one uppercase character [A-Z],\nat least one special character[!@#\\\$&*~],\nat least 8 characters in length."),
          findsNothing);
    });

    testWidgets("Test4", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignInForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordFieldKey"));
      expect(passwordField, findsOneWidget);

      var loginButton = find.byKey(const Key("LoginContainer"));
      expect(loginButton, findsOneWidget);

      await tester.enterText(passwordField, r"""\$\$aaaAAA111!!!@@2""");
      expect(find.text(r"""\$\$aaaAAA111!!!@@2"""), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(
          find.text(
              "Password must be at least one digit [0-9],\nat least one lowercase character [a-z],\nat least one uppercase character [A-Z],\nat least one special character[!@#\\\$&*~],\nat least 8 characters in length."),
          findsNothing);
    });
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
              "Password must be at least one digit [0-9],\nat least one lowercase character [a-z],\nat least one uppercase character [A-Z],\nat least one special character[!@#\\\$&*~],\nat least 8 characters in length."),
          findsOneWidget);
    });
    testWidgets("Test2", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignInForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordFieldKey"));
      expect(passwordField, findsOneWidget);

      var loginButton = find.byKey(const Key("LoginContainer"));
      expect(loginButton, findsOneWidget);

      await tester.enterText(passwordField, r"""\""");
      expect(find.text(r"""\"""), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(
          find.text(
              "Password must be at least one digit [0-9],\nat least one lowercase character [a-z],\nat least one uppercase character [A-Z],\nat least one special character[!@#\\\$&*~],\nat least 8 characters in length."),
          findsOneWidget);
    });

    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignInForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordFieldKey"));
      expect(passwordField, findsOneWidget);

      var loginButton = find.byKey(const Key("LoginContainer"));
      expect(loginButton, findsOneWidget);

      await tester.enterText(passwordField, r"""\$""");
      expect(find.text(r"""\$"""), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(
          find.text(
              "Password must be at least one digit [0-9],\nat least one lowercase character [a-z],\nat least one uppercase character [A-Z],\nat least one special character[!@#\\\$&*~],\nat least 8 characters in length."),
          findsOneWidget);
    });
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignInForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordFieldKey"));
      expect(passwordField, findsOneWidget);

      var loginButton = find.byKey(const Key("LoginContainer"));
      expect(loginButton, findsOneWidget);

      await tester.enterText(passwordField, r"""111111111""");
      expect(find.text(r"""111111111"""), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(
          find.text(
              "Password must be at least one digit [0-9],\nat least one lowercase character [a-z],\nat least one uppercase character [A-Z],\nat least one special character[!@#\\\$&*~],\nat least 8 characters in length."),
          findsOneWidget);
    });
  });
}
