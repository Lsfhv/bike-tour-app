 // ignore_for_file: prefer_const_constructors
import 'package:bike_tour_app/live_test/live_navigation/src/DynamicTestingNavigation.dart';
import 'package:bike_tour_app/screens/groupRouting/join_page.dart';
import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:bike_tour_app/screens/navigation/dynamic_navigation.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:bike_tour_app/screens/wrapper.dart';
import 'package:bike_tour_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:bike_tour_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'live_test/live_navigation/integration_testing/navigation_test.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _postJson = [];
  final url = "https://api.tfl.gov.uk/BikePoint/";
  // bool isNewUser=false;

  // checkIfNewUser() async{
  //   AuthCredential credential = AuthCredential(providerId: EmailAuthProvider.PROVIDER_ID, signInMethod: EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD );
  //   User? firebaseUser =Provider.of<User?>(context, listen: false);
  //   isNewUser = (await firebaseUser!.linkWithCredential(credential)).additionalUserInfo!.isNewUser;
  // }

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
    // SchedulerBinding.instance!.addPostFrameCallback((_) {
    //   runInitTasks();
    // });

  }

  // @protected
  // Future runInitTasks() async {
  //   List<dynamic> initializers = [checkIfNewUser(), ];
  //   /// Run each initializer method sequentially
  //   Future.forEach(initializers, (init) => init!).whenComplete(() => print('done'));
  // }


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
          MainMap.routeName :(context) => const MainMap(),
          ToPage.routeName : (context) => const ToPage(),
          RoutingMap.routeName : (context) => const RoutingMap(),
          DynamicNavigation.routeName : (context) => const DynamicNavigation(),
          JoiningPage.routeName : (context) => const JoiningPage(),
          NavigationTest.routeName : (context) => const NavigationTest(),
          DynamicNavigation_Test.routeName : (context) => const DynamicNavigation_Test(),

        },
          title: 'London Cycle',
          theme: ThemeData(
            primaryColor: STANDARD_COLOR ,
          ),
          home: Wrapper(),
        ));
  }
}
