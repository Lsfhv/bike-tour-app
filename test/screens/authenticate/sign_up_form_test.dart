import 'package:bike_tour_app/screens/authenticate/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'Testing that the text form fields in the sign up page actually exist',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SignUpForm(),
      ),
    ));

    var firstNameField = find.byKey(const Key("FirstNameField"));
    expect(firstNameField, findsOneWidget);

    var lastNameField = find.byKey(const Key("LastNameField"));
    expect(lastNameField, findsOneWidget);

    var emailField = find.byKey(const Key("EmailField"));
    expect(emailField, findsOneWidget);

    var passwordField = find.byKey(const Key("PasswordField"));
    expect(passwordField, findsOneWidget);

    var passwordConfirmField = find.byKey(const Key("PasswordConfirmField"));
    expect(passwordConfirmField, findsOneWidget);
  });

  testWidgets("Test that the parent form exists", (WidgetTester tester) async {
    // await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SignUpForm(),),));

    // var form = find.byKey(const Key("Form"));
    // expect(form, findsOneWidget);

    // FIND OUT A WAY TO RETRIEVE _FORMKEY HERE!!!!!!!!!!KJASKJDFAJKSDLFHALSDFIKHKJFSDHUK

    assert(0 == 0);
  });

  testWidgets("The text form fields are fillable", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SignUpForm(),
      ),
    ));

    // retreive the text form fields like how its done in the ifrst test, fill them and test that it has indeed been filled

    assert(0 == 0);
  });

  testWidgets("Sign up form plays nicely with firebase",
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SignUpForm(),
      ),
    ));

    // enter the data into fake_firebase database, read the link below
    // https://firebase.flutter.dev/docs/testing/testing/

    assert(0 == 0);
  });

  //TO DO: Remove code duplication, setUp?
  group("Return error when given invalid email", () {
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var emailField = find.byKey(const Key("EmailField"));
      expect(emailField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(emailField, "Abc.example.com");
      expect(find.text("Abc.example.com"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(find.text('Not a valid email'), findsOneWidget);
    });

    testWidgets("Test2", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var emailField = find.byKey(const Key("EmailField"));
      expect(emailField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(emailField, "A@b@c@example.com");
      expect(find.text("A@b@c@example.com"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(find.text('Not a valid email'), findsOneWidget);
    });

    testWidgets("Test3", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var emailField = find.byKey(const Key("EmailField"));
      expect(emailField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester
          .enterText(emailField, r"""a"b(c)d,e:f;g<h>i[j\k]l@example.com""");
      expect(find.text(r"""a"b(c)d,e:f;g<h>i[j\k]l@example.com"""),
          findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(find.text('Not a valid email'), findsOneWidget);
    });

    testWidgets("Test4", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var emailField = find.byKey(const Key("EmailField"));
      expect(emailField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester
          .enterText(emailField, r"""this is"not\allowed@example.com""");
      expect(find.text(r"""this is"not\allowed@example.com"""), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(find.text('Not a valid email'), findsOneWidget);
    });
  });

  group("Accept valid emails", () {
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var emailField = find.byKey(const Key("EmailField"));
      expect(emailField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(emailField, "example@example.org");
      expect(find.text("example@example.org"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(find.text('Not a valid email'), findsNothing);
    });

    testWidgets("Test2", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var emailField = find.byKey(const Key("EmailField"));
      expect(emailField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(emailField, "firstname.lastname@example.com");
      expect(find.text("firstname.lastname@example.com"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(find.text('Not a valid email'), findsNothing);
    });

    testWidgets("Test3", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var emailField = find.byKey(const Key("EmailField"));
      expect(emailField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(emailField, "email@subdomain.example.com");
      expect(find.text("email@subdomain.example.com"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(find.text('Not a valid email'), findsNothing);
    });

    testWidgets("Test4", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var emailField = find.byKey(const Key("EmailField"));
      expect(emailField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(emailField, "firstname+lastname@domain.com");
      expect(find.text("firstname+lastname@domain.com"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(find.text('Not a valid email'), findsNothing);
    });
  });

  group("Reject invalid passwords", () {
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordField"));
      expect(passwordField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(passwordField, "123");
      expect(find.text("123"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(
          find.text(
              r"""Password must be at least one digit [0-9], at least one lowercase character [a-z], at least one uppercase character [A-Z], at least one special character [!@#\$&*~], at least 8 characters in length, but no more than 32."""),
          findsOneWidget);
    });

    testWidgets("Test2", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordField"));
      expect(passwordField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(passwordField, "abcdeF");
      expect(find.text("abcdeF"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(
          find.text(
              r"""Password must be at least one digit [0-9], at least one lowercase character [a-z], at least one uppercase character [A-Z], at least one special character [!@#\$&*~], at least 8 characters in length, but no more than 32."""),
          findsOneWidget);
    });

    testWidgets("Test3", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordField"));
      expect(passwordField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(
          passwordField, "abcdefghijklmnopqrstuvwxyz1234567890");
      expect(find.text("abcdefghijklmnopqrstuvwxyz1234567890"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(
          find.text(
              r"""Password must be at least one digit [0-9], at least one lowercase character [a-z], at least one uppercase character [A-Z], at least one special character [!@#\$&*~], at least 8 characters in length, but no more than 32."""),
          findsOneWidget);
    });
    testWidgets("Test4", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordField"));
      expect(passwordField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(passwordField, r"""ABCDEFG1234567890!"£$%^&*()""");
      expect(find.text(r"""ABCDEFG1234567890!"£$%^&*()"""), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(
          find.text(
              r"""Password must be at least one digit [0-9], at least one lowercase character [a-z], at least one uppercase character [A-Z], at least one special character [!@#\$&*~], at least 8 characters in length, but no more than 32."""),
          findsOneWidget);
    });
  });

  group("Accept valid passwords", () {
    testWidgets("Test1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordField"));
      expect(passwordField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(passwordField, "Aaaaaa#0");
      expect(find.text("Aaaaaa#0"), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(
          find.text(
              r"""Password must be at least one digit [0-9], at least one lowercase character [a-z], at least one uppercase character [A-Z], at least one special character [!@#\$&*~], at least 8 characters in length, but no more than 32."""),
          findsNothing);
    });

    testWidgets("Test2", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordField"));
      expect(passwordField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(passwordField, r"""gk26A!a@j~\&""");
      expect(find.text(r"""gk26A!a@j~\&"""), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(
          find.text(
              r"""Password must be at least one digit [0-9], at least one lowercase character [a-z], at least one uppercase character [A-Z], at least one special character [!@#\$&*~], at least 8 characters in length, but no more than 32."""),
          findsNothing);
    });

    testWidgets("Test3", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: SignUpForm(),
      )));

      var passwordField = find.byKey(const Key("PasswordField"));
      expect(passwordField, findsOneWidget);

      var register = find.text("Register");
      expect(register, findsOneWidget);

      await tester.enterText(passwordField, r"""hyWD62$~~!""");
      expect(find.text(r"""hyWD62$~~!"""), findsOneWidget);

      await tester.tap(register);
      await tester.pump();

      expect(
          find.text(
              r"""Password must be at least one digit [0-9], at least one lowercase character [a-z], at least one uppercase character [A-Z], at least one special character [!@#\$&*~], at least 8 characters in length, but no more than 32."""),
          findsNothing);
    });
  });
}
