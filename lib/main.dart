// ignore_for_file: prefer_const_constructors
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:bike_tour_app/screens/wrapper.dart';
import 'package:bike_tour_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:bike_tour_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';



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
    return MultiProvider(      
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null,
          ),
        ],
        child: MaterialApp(
        routes : {
          ToPage.routeName : (context) => const ToPage(),
          RoutingMap.routeName : (context) => const RoutingMap(),
        },
          title: 'London Cycle',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: Wrapper(),
        ));
  }
}
