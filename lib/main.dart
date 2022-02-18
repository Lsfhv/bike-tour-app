// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:bike_tour_app/screens/authenticate/authenticate.dart';
import 'package:bike_tour_app/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

//void main() => runApp(MyApp());

//import 'config/config.dart';

void main() async {
 // var config = Config();
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
    //fetchPosts();
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
            itemCount: _postJson.length,
            itemBuilder: (context, i) {
              final post = _postJson[i];
              return Text("Street name: ${post["commonName"]}\n lat: ${post["lat"]}\n lon: ${post["lon"]}\n\n");
            }),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Authenticate(),
      },
    );
  }
}

class MyApp1 extends StatefulWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  _MyAppState1 createState() => _MyAppState1();
}

class _MyAppState1 extends State<MyApp1> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(51.507399, -0.127689);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override       
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 15),
            ),
          ),
          floatingActionButton: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(1, -0.8),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Color.fromARGB(202, 85, 190, 56),
                  child: const Icon(Icons.settings),
                ),
              ),
              Align(
                alignment: Alignment(-0.8, -0.8),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Color.fromARGB(202, 85, 190, 56),
                  child: const Icon(Icons.person),
                ),
              ),
            ],
          )),
    );
  }
}
