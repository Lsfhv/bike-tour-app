// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:bike_tour_app/firebase_options.dart';
import 'package:bike_tour_app/screens/authenticate/authenticate.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'London Cycle',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Authenticate(),
      },
    );
  }
}
