

import 'dart:async';

import 'package:bike_tour_app/models/journey_data_with_route_model.dart';
import 'package:bike_tour_app/models/route_model.dart';
import 'package:bike_tour_app/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
      body: Stack(

        children : [
          Align(
            alignment: Alignment(0.8, 0.8),
            child: FloatingActionButton(
              heroTag: "Test 1",
              onPressed: () async => await test_1(),
              backgroundColor:
                  Color.fromARGB(202, 85, 190, 56).withOpacity(1),
              child: const Icon(Icons.start),
            
            ),
          ),

          
        ]
    ),
    );
  }

  test_1() async{
    
    final String TEST_1 = '1585';
    final DocumentSnapshot<Map<String, dynamic>> test_data = await FirebaseFirestore.instance.collection('test_journeys').doc(TEST_1).get();
  String encodedPolyPoints = test_data['journey']['directions']['polyPoints_encoding'] as String;
    final List<PointLatLng> locationList = PolylinePoints().decodePolyline(encodedPolyPoints);
    final UserPosition test_user = UserPosition(LatLng(locationList[0].latitude, locationList[0].longitude));

    //StreamController<LatLng> controller = StreamController<LatLng>();
    List<LatLng> controller = [];
    for(PointLatLng point in locationList){
      controller.add(LatLng(point.latitude, point.longitude));
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