import 'dart:async';
import 'dart:math';

import 'package:bike_tour_app/models/instruction_model.dart';
import 'package:bike_tour_app/screens/markers/user_location_marker.dart';
import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:bike_tour_app/screens/widgets/instruction_widget.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis/admob/v1.dart';


import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

import '../../models/directions_model.dart';
import 'mymap.dart';

class RouteData{
  final Directions directions;
  final UserPosition user_loc;
  final Set<Marker> markers;
  final List<LatLng> waypoints;

  RouteData({required this.directions,required this.user_loc, required this.markers, required this.waypoints});
}

// class DynamicNavigation extends StatefulWidget {
//   const DynamicNavigation({Key? key}) : super(key: key);
//   static const routeName = '/dynamicNavigation';
//   @override
//   _DynamicNavigationState createState() => _DynamicNavigationState();
// }

// class _DynamicNavigationState extends State<DynamicNavigation> {
//   //Completer<GoogleMapController> _controller = Completer();
// //Set<Marker> _markers = Set<Marker>();
// // for my drawn routes on the map
// // Set<Polyline> _polylines = Set<Polyline>();
// // List<LatLng> polylineCoordinates = [];
// // PolylinePoints polylinePoints;
// // wrapper around the location API

//   final loc.Location location = loc.Location();
//   late loc.LocationData current_position;
//   late LatLng nextCheckPoint;
//   late Instruction current_instruction;
//   StreamSubscription<loc.LocationData>? _locationSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _requestPermission();
//     location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
//     location.enableBackgroundMode(enable: true);
//     location.onLocationChanged.listen((loc.LocationData cLoc) {
//       // cLoc contains the lat and long of the
//       // current user's position in real time,
//       // so we're holding on to it
//       current_position = cLoc;
//    });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     _getLocation();
//     _listenLocation();
//     final args = ModalRoute.of(context)!.settings.arguments as RouteData;
//     return Stack(
//       alignment: Alignment.center,
//       children: [      
//       InstructionWidget(instruction: current_instruction),
//       StreamBuilder(
//         stream:
//             FirebaseFirestore.instance.collection('location').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//             return MyMap(snapshot.data!.docs.last.id);
//         },
//       )],
//     );
//   }

//   void _update_instruction(){

//   }

//   _showNextInstruction(RouteData args){
//     current_instruction = args;
//   }

//   _getLocation() async {
//     try {
//       final loc.LocationData _locationResult = await location.getLocation();
//       await FirebaseFirestore.instance.collection('location').doc('user1').set({
//         'latitude': _locationResult.latitude,
//         'longitude': _locationResult.longitude,
//         'name': 'john'
//       }, SetOptions(merge: true));
//     } catch (e) {
//       print(e);
//     }
//   }

//   double _calculate_distance({required LatLng from,required LatLng to}){
//       double distance = 0;
//       const double RADIUS_OF_EARTH = 6371000;
//       double a1 = from.latitude * pi/180;
//       double a2 = to.latitude * pi/180;
//       double b1 = (to.latitude - from.latitude) * pi/180;
//       double b2 = (to.longitude - from.longitude) * pi/180;

//       double k = sin(b1/2) * sin(b1/2) +
//                 cos(a1) * cos(a2) *
//                 sin(b2/2) * sin(b2/2);
//       double c = 2 * atan2(sqrt(k), sqrt(1-k));

//       distance = c * RADIUS_OF_EARTH;
      

//       return distance;
//   }

//   bool _reached_next_check_point(){
//     double tolerance = 2;
//     if(nextCheckPoint != null){
//       double distance =  _calculate_distance(
//         from: LatLng(current_position.latitude as double, current_position.longitude as double,),
//         to: nextCheckPoint
//       );
//       return distance <= tolerance || distance >= -(tolerance);
//     }
//     else{
//       return true;
//     }
//   }

//   Future<void> _listenLocation() async {
//     _locationSubscription = location.onLocationChanged.handleError((onError) {
//       print(onError);
//       _locationSubscription?.cancel();
//       setState(() {
//         _locationSubscription = null;
//       });

//     }).listen((loc.LocationData currentlocation) async {
//       await FirebaseFirestore.instance.collection('location').doc('user1').set({
//         'latitude': currentlocation.latitude,
//         'longitude': currentlocation.longitude,
//         'name': 'john'
//       }, SetOptions(merge: true));
//     });
//   }

//   _stopListening() {
//     _locationSubscription?.cancel();
//     setState(() {
//       _locationSubscription = null;
//     });
//   }

//   _requestPermission() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       print('done');
//     } else if (status.isDenied) {
//       _requestPermission();
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
// }

class DynamicNavigation extends StatefulWidget {
  const DynamicNavigation({Key? key}) : super(key: key);
  static const routeName = '/dynamicNavigation';
  @override
  _DynamicNavigationState createState() => _DynamicNavigationState();
}

class _DynamicNavigationState extends State<DynamicNavigation> {
  //Completer<GoogleMapController> _controller = Completer();
  int instruction_index = 1;
  late LatLng _center;
  final loc.Location location = loc.Location();
  late loc.LocationData current_position;
  late LatLng nextCheckPoint;
  late Instruction? current_instruction =null;
  late Instructions instructions;
  late GoogleMapController mapController;
  StreamSubscription<loc.LocationData>? _locationSubscription;
  Set<Marker> _markers = {};
  Directions? _info;
  double CAMERA_ZOOM = 15;
  double CAMERA_TILT = 1;
  double CAMERA_BEARING = 45;
  bool reached = false;
  

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true); // CALLED BY THIS
    _listenLocation();
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as RouteData;
    _info = args.directions;
    instructions = _info!.instruction as Instructions;
    if(current_instruction == null){
      current_instruction = instructions.get(0);
      nextCheckPoint = current_instruction!.end_loc;
    }
    _center = args.user_loc.center as LatLng;
    _markers = args.markers;
    return Scaffold(
      body : Stack(
        alignment: Alignment.center,
        children: [ 
        GoogleMap(
              myLocationButtonEnabled: false,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition:CameraPosition(target: _center, zoom: 15),
              onMapCreated: _onMapCreated,
              markers: _markers,
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _info!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
            ),
        if(_locationSubscription != null)
        Positioned(
          child:  InstructionWidget(instruction: current_instruction as Instruction),
          top :0,
          left :0,
          right : 0,
        ),
        ],
      )
    );
  }
  void updatePinOnMap() async {
   
   // create a new CameraPosition instance
   // every time the location changes, so the camera
   // follows the pin as it moves with an animation
  //  CameraPosition cPosition = CameraPosition(
  //  zoom: CAMERA_ZOOM,
  //  tilt: CAMERA_TILT,
  //  bearing: CAMERA_BEARING,
  //  target: _center,
  //  );
 
  // mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));
   // do this inside the setState() so Flutter gets notified
   // that a widget update is due
    if(mounted){
    setState(() {
      _center = LatLng(current_position.latitude as double, current_position.longitude as double);
      _markers.removeWhere((m) => m.markerId.value == 'current_location');
      Marker _new_marker = UserMarker(user: UserPosition(_center) );
      _markers.add(_new_marker);
      if(instructions != null && nextCheckPoint !=null ){
        print(nextCheckPoint);
        if(_reached_next_check_point()){
          _update_instruction();
          }     
      }
    });
    }
    else{
        _center = LatLng(current_position.latitude as double, current_position.longitude as double);
        _markers.removeWhere((m) => m.markerId.value == 'current_location');
        Marker _new_marker = UserMarker(user: UserPosition(_center) );
        _markers.add(_new_marker);
        if(instructions != null && nextCheckPoint !=null ){
          print(nextCheckPoint);
          if(_reached_next_check_point()){
            _update_instruction();
            }     
        }
      }
      // if(reached){
      //   setState(() {
      //      current_instruction = Instruction.set(
      //        "You have reached your destination",
      //        start_loc : cur
      //        );
      //   });
      // }
}

  void _update_instruction(){
    if(instruction_index < instructions.instructions.length){
      current_instruction = instructions.get(instruction_index);
      nextCheckPoint = current_instruction!.end_loc;
      instruction_index++;
    }
    else if(_locationSubscription == null){
      //set ERROR
    }
    else if(reached){
      current_instruction = REACHED_INSTRUCTION;
      nextCheckPoint = REACHED_LOC;
    }
    else{
      //indicate reached location
      reached = true;
    }
  }

  double _calculate_distance({required LatLng from,required LatLng to}){
      double distance = 0;
      const double RADIUS_OF_EARTH = 6371000;
      double a1 = from.latitude * pi/180;
      double a2 = to.latitude * pi/180;
      double b1 = (to.latitude - from.latitude) * pi/180;
      double b2 = (to.longitude - from.longitude) * pi/180;

      double k = sin(b1/2) * sin(b1/2) +
                cos(a1) * cos(a2) *
                sin(b2/2) * sin(b2/2);
      double c = 2 * atan2(sqrt(k), sqrt(1-k));

      distance = c * RADIUS_OF_EARTH;
      

      return distance;
  }

  bool _reached_next_check_point(){
    double tolerance = 2;
    if(nextCheckPoint != null){
      double distance =  _calculate_distance(
        from: LatLng(current_position.latitude as double, current_position.longitude as double,),
        to: nextCheckPoint
      );
      return distance <= tolerance;
    }
    else{
      return true;
    }
  }

  void _handleError() async{
    _locationSubscription?.cancel();
    await _requestPermission();
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _handleError();
    }).listen((loc.LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      current_position = cLoc;
      updatePinOnMap();
      if(reached){
        _stopListening();
      }
   });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      AppSettings.openLocationSettings;  
    }
  }
}

class STANDARD_COLOR {
}