import 'package:bike_tour_app/screens/authenticate/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing that the text form fields in the sign up page actually exist', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SignUpForm(),),));
    
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

    assert(0==0);
  });

  testWidgets("The text form fields are fillable", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SignUpForm(),),));

    // retreive the text form fields like how its done in the ifrst test, fill them and test that it has indeed been filled 



    assert(0==0);
  });

  testWidgets("Sign up form plays nicely with firebase", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SignUpForm(),),));

    // enter the data into fake_firebase database, read the link below
    // https://firebase.flutter.dev/docs/testing/testing/


    assert(0==0);
  });
  
  testWidgets("Test email is valid", (WidgetTester tester) async {
    final emailField = find.byKey(const Key("EmailField"));
    final signUpContainer = find.text('Register');

    await tester.pumpWidget(const SignUpForm());

    await tester.enterText(emailField, "T");
    await tester.tap(signUpContainer);
    await tester.pump();

    expect(find.text("T"), 'Not a valid email');
  });


}

