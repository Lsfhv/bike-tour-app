import 'package:bike_tour_app/screens/authenticate/forgot_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bike_tour_app/services/auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockUser extends Mock implements User{}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]); //stream from iterable
  }
}


void main() {
  group("Test", () {  
    
    testWidgets("Check widgets existence", (WidgetTester tester) async{
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: ForgotPasswordFrom(),
      )));

      var emailField = find.byKey(const Key("EmailKey"));
      expect(emailField, findsOneWidget);

      var resetButton = find.byKey(const Key("ResetKey"));  
      expect(resetButton, findsOneWidget);

      await tester.enterText(emailField, "happy@example.com");
      expect(find.text("happy@example.com"), findsOneWidget);
      
      // await tester.tap(resetButton);
      // await tester.pumpAndSettle();
      // expect(find.text('Please check your email to reset you password'), findsOneWidget);
    });

    testWidgets("Test2", (WidgetTester tester) async {});

    testWidgets("Test3", (WidgetTester tester) async {});

    testWidgets("Test4", (WidgetTester tester) async {});
  });
}
