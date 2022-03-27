import 'dart:async';
import 'dart:math';

import 'package:bike_tour_app/models/instruction_model.dart';
import 'package:bike_tour_app/repository/direction.dart';
import 'package:bike_tour_app/screens/markers/user_location_marker.dart';
import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:bike_tour_app/screens/widgets/instruction_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:flutter_tts/flutter_tts.dart';


import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

import '../../models/directions_model.dart';
import '../../models/tfl-api/get_api.dart';

class RouteData{
  // final Directions directions;
  // final UserPosition user_loc;
  // final Set<Marker> markers;
  // final List<LatLng> waypoints;

  final UserPosition user_loc;
  final JourneyDataWithRoute jdwr;

  RouteData({ required this.user_loc, required this.jdwr});
}

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
  JourneyDataWithRoute? jdwr;
  final loc.Location location = loc.Location();
  late loc.LocationData current_position;
  late LatLng nextCheckPoint;
  late Instruction? current_instruction =null;
  late Instructions instructions;
  late List<PointLatLng> polylinepoints;
  late GoogleMapController mapController;
  StreamSubscription<loc.LocationData>? _locationSubscription;
  Set<Marker> _markers = {};
  Directions? _info;
  double CAMERA_ZOOM = 15;
  double CAMERA_TILT = 1;
  double CAMERA_BEARING = 45;
  bool reached = false;
  bool cancelled = false;
  List<LatLng> past_journeys =[];
  bool muted = false;

  var ttsState;

  

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }

  Future<bool> enableBackgroundMode() async {
    bool _bgModeEnabled = await location.isBackgroundModeEnabled();
    if (_bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        _bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      print(_bgModeEnabled); //True!
      return _bgModeEnabled;
 }
}

  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    enableBackgroundMode(); // CALLED BY THIS
    _listenLocation();
  }
  
  Set<Polyline> _polyline(){
    return {
      Polyline(
      polylineId: const PolylineId('past_journey'),
      color: Colors.grey,
      width: 5,
      points: past_journeys
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList(),
      ),
      Polyline(
        polylineId: const PolylineId('rest_of_journey'),
        color: STANDARD_COLOR,
        width: 5,
        points: polylinepoints
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList(),
      ),
    };
  }

  _cancelTrip(){
    setState(() {
      cancelled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(polylinepoints.first.toString());
    final args = ModalRoute.of(context)!.settings.arguments as RouteData;
    _info = args.jdwr.route;
    jdwr = args.jdwr;
    instructions = _info!.instruction as Instructions;
    polylinepoints = _info!.polylinePoints;
    if(current_instruction == null){
      current_instruction = instructions.get(0);
      nextCheckPoint = current_instruction!.end_loc;
    }
    _center = args.user_loc.center as LatLng;
    _markers = args.jdwr.journeyData.markers;
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
              polylines: _info != null ? _polyline() : {},
            ),
          Positioned(
            child: IconButton(
              iconSize: 20,
              icon: Icon(Icons.backspace),
              onPressed: ()async => await _cancelTrip(),
            ),
            left: 10,
            bottom: 10,
          ),
          Positioned(
            child: IconButton(
              icon: Icon(Icons.redo_rounded),
              iconSize: 20,
              onPressed: () async => await _reroute(),
            ),
            left :40,
            bottom: 10,
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
   
    if(mounted){
      _pastPoint();
      setState(() {
        _center = LatLng(current_position.latitude as double, current_position.longitude as double);
        _markers.removeWhere((m) => m.markerId.value == 'current_location');
        Marker _new_marker = UserMarker(user: UserPosition(_center) );
        _markers.add(_new_marker);
        if(instructions != null && nextCheckPoint !=null ){
          print(nextCheckPoint); 
        }
      });
      if(_reached_next_check_point()){
        _update_instruction();
        if(!muted){
          await _speak();
      }
      }    
      
    }
}

  String _editString(String s){
    RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
    return s.replaceAll(exp, ' ');
  }

  _speak() async{
    final flutterTts = FlutterTts();
    
    var result = await flutterTts.speak(_editString(current_instruction!.instruction));
  }


  bool is_on_route(){
    LatLng cur_pos = LatLng(current_position.latitude as double, current_position.longitude as double);
    const double TOLERANCE = 10;
    int len = _info!.polylinePoints.length;
    List<PointLatLng> points = _info!.polylinePoints.sublist((len/4).toInt(),(3*len/4 ).toInt());
    for(PointLatLng point in points){
      LatLng latlng = LatLng(point.latitude, point.longitude);
      double distance = _calculate_distance(from: cur_pos, to: latlng);
      if(distance <= TOLERANCE){
        return true;
      }
    }
    return false;
  }

  _reroute() async{
    //fetch directions to latest endpoint
    LatLng curr_pos = LatLng(current_position.latitude as double, current_position.longitude as double);
    LatLng end_point = current_instruction!.end_loc;
    LatLng start_point = current_instruction!.start_loc;
    final reroute_directions = await DirectionsRepository().getDirections(origin: curr_pos, destinations: [], ending_bike_dock: end_point);
    Instructions reroute_instructions = reroute_directions!.instruction;
    
    //Clear all previous trip

    // Now we need to identify where old trip was disrupted and remove irrelevant polyline and instructions
    const double TOLERANCE = 20;
    List<PointLatLng> polypoints = [];
    polypoints.addAll(_info!.polylinePoints);
    for(PointLatLng point in _info!.polylinePoints){
      final latlng = LatLng(point.latitude,point.longitude);
      if(_calculate_distance(from: end_point, to: latlng)<= TOLERANCE){
        break;
      }
      polypoints.remove(point);
    }

    //we remove current_instruction as it is now irrelevant,
    Instructions new_instructions = Instructions(instructions: instructions.instructions.sublist(instruction_index+=1));
    new_instructions = reroute_instructions + new_instructions;
    
    //now polyline and instruction reloaded,
    setState(() {
      polylinepoints = polypoints;
      past_journeys =[]; //since rerouting clear all pass journey
      instructions = new_instructions;
      instruction_index = 0;
    });

  }

  void _update_instruction(){
    LatLng cur_pos = LatLng(current_position.latitude as double, current_position.longitude as double);
    bool onRoute = is_on_route();
    bool stillOnCurrentInstruction = _reached_next_check_point();//current_instruction!.stillInInstruction(cur_pos);
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
    else if(!stillOnCurrentInstruction){
      if(!onRoute){
      current_instruction = instructions.get(instruction_index);
      nextCheckPoint = current_instruction!.end_loc;
      instruction_index++;
      }  
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
    double tolerance = 20;
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

  Future<void> _handleError() async{
    _locationSubscription?.cancel();
    await _requestPermission();
  }

  _pastPoint()  {
    LatLng cur_point = LatLng(current_position.latitude as double, current_position.longitude as double);
    const int TOLEARANCE =50;
    LatLng reached_point = LatLng(_info!.polylinePoints.first.latitude, _info!.polylinePoints.first.longitude);
    print(_calculate_distance(from: cur_point, to: reached_point));
    if(_calculate_distance(from: cur_point, to: reached_point) <= TOLEARANCE ){
      setState(()  {
        PointLatLng past_point = _info!.polylinePoints.removeAt(0);
        past_journeys.add(LatLng(past_point.latitude, past_point.longitude));
      });
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) async {
      print(onError);
      await _handleError();
    }).listen((loc.LocationData cLoc) async {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      current_position = cLoc;
      updatePinOnMap();
      if(reached || cancelled){
        _stopListening();
        await jdwr!.journeyData.endTrip();
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

