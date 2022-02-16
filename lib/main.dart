// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:bike_tour_app/screens/authenticate/authenticate.dart';
import 'package:bike_tour_app/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'config/config.dart';

void main() async {
  var config = Config();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //       apiKey: config.apiKey,
  //       appId: config.appId,
  //       messagingSenderId: config.messagingSenderId,
  //       projectId: config.projectId),
  // );
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
