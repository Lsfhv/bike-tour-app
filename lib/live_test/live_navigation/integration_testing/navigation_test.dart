

import 'dart:async';
import 'dart:math';

import 'package:bike_tour_app/models/journey_data_with_route_model.dart';
import 'package:bike_tour_app/models/route_model.dart';
import 'package:bike_tour_app/models/user_data.dart';
import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../src/DynamicTestingNavigation.dart';
import '../src/data/Test_Data_model.dart';




class NavigationTest extends StatefulWidget {
  const NavigationTest({ Key? key }) : super(key: key);
  static String routeName = 'navtigationTest/';
  @override
  State<NavigationTest> createState() => _NavigationTestState();
}

class _NavigationTestState extends State<NavigationTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title :  Text('DEMO RUNS', style: GoogleFonts.lato(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.bold),),
        backgroundColor: STANDARD_COLOR,
        )
        
        ,
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Align(
              alignment: Alignment(0, 0.6),
              child: SizedBox(
                width: 250.0,
                height: 75.0,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Text(
                    'Live Navigation Demo',
                    style:
                        GoogleFonts.lato(color: Colors.white, fontSize: 16.5),
                  ),
                  color: Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  onPressed: () async => await test_1(),
                ),
              ),
            ),
          ]
      )  
    );
  }

  test_1() async{
    
    final String TEST_1 = '3324';
    final DocumentSnapshot<Map<String, dynamic>> test_data = await FirebaseFirestore.instance.collection('test_journeys').doc(TEST_1).get();
  String encodedPolyPoints = test_data['journey']['directions']['polyPoints_encoding'] as String;
    final List<PointLatLng> locationList = PolylinePoints().decodePolyline(encodedPolyPoints);
    final UserPosition test_user = UserPosition(LatLng(locationList[0].latitude, locationList[0].longitude));

    //StreamController<LatLng> controller = StreamController<LatLng>();
    List<LatLng> controller = [];
    var rng = Random(0);
    //range is 3

    int range = 3;
    double degreePerMeter = 1/111320;
    for(PointLatLng point in locationList){
      double off_set_lat = (rng.nextInt(2*range) - range) * degreePerMeter;
      double off_set_lon = (rng.nextInt(2*range) - range) * degreePerMeter;
      controller.add(LatLng(point.latitude + off_set_lat, point.longitude + off_set_lon));
    }
  
    //Stream<LatLng> locationStream = controller.stream; 
    //Stream<LatLng> locationStream = await simluateMovement(locationList);

    
    final jdwr = JourneyDataWithRoute.fromFS(test_data.data() as Map<String,dynamic> , test_user);
    if(jdwr !=null){
      Navigator.pushNamed(context, DynamicNavigation_Test.routeName, arguments : TestData(data:RouteData(user_loc: test_user , jdwr : jdwr as JourneyDataWithRoute), locationStream: controller));

    }


  }




  Stream<LatLng> simluateMovement(List<PointLatLng> source) async* {
    for(PointLatLng point in source){
      yield LatLng(point.latitude, point.longitude);
      print('Location : $point');
      await Future.delayed(Duration(seconds: 1));
  
    }
  }
}