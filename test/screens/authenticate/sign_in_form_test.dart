import 'dart:math';

import 'package:bike_tour_app/firebase_options.dart';
import 'package:bike_tour_app/main.dart';
import 'package:bike_tour_app/screens/authenticate/sign_in.dart';
import 'package:bike_tour_app/screens/authenticate/sign_in_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing sign in', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SignInForm(),),));
    await tester.pumpAndSettle();
    var x = find.byKey(Key("1"));
    expect(x, findsOneWidget);
    assert(1==1);
    });
}