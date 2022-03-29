import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:bike_tour_app/screens/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/journey_data_with_route_model.dart';
import '../../models/user_data.dart';
import '../navigation/route_choosing.dart';

class JoiningPage extends StatefulWidget {
  const JoiningPage({ Key? key }) : super(key: key);
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
  Future<void> _getCurrentLocation() async{
    locationPermission = (await Permission.location.request().isGranted) || (await Permission.locationWhenInUse.serviceStatus.isEnabled);
    if(locationPermission){
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
            pos = UserPosition(LatLng(position.latitude, position.longitude));
          }); 
    }
   }

  bool _gotJourney(DocumentSnapshot<Map<String, dynamic>> value){
    try{
      value.data()!["journey"];
    }
    on StateError catch (_){
      return false;
    }
    on NullThrownError catch (_){
      return false;
    }
    jdwr = JourneyDataWithRoute.fromFS(value.data() as Map<String,dynamic> , pos);
    return true;
  }

  Future<bool> _checkValidityOfCode(String code)async {
  
    try{
      bool exist = false;
      print(code);
      await FirebaseFirestore.instance.collection("group_journey").doc(code).get().then((value) => {
        if(value.exists){
          exist = true
        }
      });
      return exist;
    }
    on StateError catch (_){
      print(_);
      return false;
    }
  }

  _waitForJourney(String code) async {
    setState(() {
      loading = true;
    });
    bool gotData = false;
    if(await _checkValidityOfCode(code)){
      while(!gotData){
        await FirebaseFirestore.instance.collection("group_journey").doc(code).get().then(
        (value) => gotData = _gotJourney(value)
        );
      }
    }
    else{
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


  _grabJourney(String code) async{
    await _getCurrentLocation();
    await _waitForJourney(code);
    if(jdwr !=null){
      Navigator.pushNamed(context, RoutingMap.routeName, arguments : jdwr);
    }

  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
    body : Stack(
      children :[ 
        if(!loading) Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Card(
            child : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                  hintText: 'Enter the Code',
                  hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                  ),
                  style: TextStyle(
                  color: Colors.white,
                  ),
                  onSubmitted: (value) => _grabJourney(value),
                )
              ],
            ),
          color: STANDARD_COLOR,
          )
         ),
        if(loading) LoadingWidget( loading_text: "Waiting for Leader to generate route",),
      ]
    )
    );
  }
}