import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:bike_tour_app/screens/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis/trafficdirector/v2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bike_tour_app/screens/groupRouting/group_routing.dart';
import 'package:google_fonts/google_fonts.dart';

import '../navigation/route_choosing.dart';

class JoiningPage extends StatefulWidget {
  const JoiningPage({Key? key}) : super(key: key);
  static String routeName = "/JoiningPage";
  @override
  State<JoiningPage> createState() => _JoiningPageState();
}

class _JoiningPageState extends State<JoiningPage> {
  bool locationPermission = false;
  JourneyDataWithRoute? jdwr = null;
  late UserPosition pos;
  String group_code = "";
  bool loading = false;
  Future<void> _getCurrentLocation() async {
    locationPermission = (await Permission.location.request().isGranted) ||
        (await Permission.locationWhenInUse.serviceStatus.isEnabled);
    if (locationPermission) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        pos = UserPosition(LatLng(position.latitude, position.longitude));
      });
    }
  }

  bool _gotJourney(DocumentSnapshot<Map<String, dynamic>> value) {
    try {
      value.data()!["journey"];
    } on StateError catch (_) {
      return false;
    } on NullThrownError catch (_) {
      return false;
    }
    jdwr =
        JourneyDataWithRoute.fromFS(value.data() as Map<String, dynamic>, pos);
    return true;
  }

  Future<bool> _checkValidityOfCode(String code) async {
    try {
      bool exist = false;
      print(code);
      await FirebaseFirestore.instance
          .collection("group_journey")
          .doc(code)
          .get()
          .then((value) => {
                if (value.exists) {exist = true}
              });
      return exist;
    } on StateError catch (_) {
      print(_);
      return false;
    }
    return false;
  }

  _waitForJourney(String code) async {
    setState(() {
      loading = true;
    });
    bool gotData = false;
    if (await _checkValidityOfCode(code)) {
      while (!gotData) {
        await FirebaseFirestore.instance
            .collection("group_journey")
            .doc(code)
            .get()
            .then((value) => gotData = _gotJourney(value));
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text("Group code is not valid!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context, "ok"),
                        child: const Text("Ok!"))
                  ]));
      setState(() {
        loading = false;
      });
    }
  }

  _grabJourney(String code) async {
    await _getCurrentLocation();
    await _waitForJourney(code);
    if (jdwr != null) {
      Navigator.pushNamed(context, RoutingMap.routeName, arguments: jdwr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Align(
        alignment: Alignment(-0.9, -0.85),
        child: FloatingActionButton(
          heroTag: "Home",
          onPressed: () {
            // the settings button
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GroupRoutingPage()));
          },
          backgroundColor: Color.fromARGB(202, 85, 190, 56).withOpacity(1),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      if (!loading)
        Align(
          alignment: Alignment(0.0, 0.0),
          child: Container(
            margin: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(30),
                  child: Text(
                    "Enter group code",
                    style: GoogleFonts.lato(
                        fontSize: 30,
                        color: Color.fromARGB(
                          202,
                          85,
                          190,
                          56,
                        ),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  onChanged: (value) => group_code = value,
                  decoration: InputDecoration(
                      hintText: "Enter group code",
                      border: OutlineInputBorder(),
                      labelText: "Group code",
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: GoogleFonts.lato().fontFamily)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    disabledColor: Colors.grey,
                    onPressed: () {
                      _grabJourney(group_code);
                    },
                    child: Text(
                      "Join",
                      style:
                          GoogleFonts.lato(fontSize: 20, color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      // Align(
      //     alignment: Alignment(0, 0),
      //     child: TextField(
      //       onChanged: (value) => group_code = value,
      //       decoration: InputDecoration(
      //           hintText: "Enter group code",
      //           border: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(10)),),
      //       onSubmitted: (value) => _grabJourney(value),
      //     )),
      if (loading)
        LoadingWidget(
          loading_text: "Waiting for Leader to generate route",
        ),
    ]));
  }
}
