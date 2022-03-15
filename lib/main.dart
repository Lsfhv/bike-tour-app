// ignore_for_file: prefer_const_constructors
import 'package:bike_tour_app/screens/navigation/dynamic_navigation.dart';
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:bike_tour_app/screens/wrapper.dart';
import 'package:bike_tour_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
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
  //trying source control
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _postJson = [];
  final url = "https://api.tfl.gov.uk/BikePoint/";
  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        _postJson = jsonData;
      });
    } catch (err) {}
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

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
          DynamicNavigation.routeName : (context) => const DynamicNavigation(),
        },
          title: 'London Cycle',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: Wrapper(),
        ));
  }
}
