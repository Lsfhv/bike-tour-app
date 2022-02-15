// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:bike_tour_app/screens/authenticate/authenticate.dart';
import 'package:bike_tour_app/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'config/config.dart';

void main() async {
  // final _auth = FirebaseAuth.instance;

  // var x = FirebaseAuth.instance;
  var config = Config();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: config.apiKey,
    appId: config.appId,
    messagingSenderId: config.messagingSenderId,
    projectId: config.projectId,
  ));
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



// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late GoogleMapController mapController;

//   final LatLng _center = const LatLng(51.507399, -0.127689);

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           body: Center(
//             child: GoogleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(target: _center, zoom: 15),
//             ),
//           ),
//           floatingActionButton: Stack(
//             children: <Widget>[
//               Align(
//                 alignment: Alignment(1, -0.8),
//                 child: FloatingActionButton(
//                   onPressed: () {},
//                   backgroundColor: Color.fromARGB(202, 85, 190, 56),
//                   child: const Icon(Icons.settings),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment(-0.8, -0.8),
//                 child: FloatingActionButton(
//                   onPressed: () {},
//                   backgroundColor: Color.fromARGB(202, 85, 190, 56),
//                   child: const Icon(Icons.person),
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }
