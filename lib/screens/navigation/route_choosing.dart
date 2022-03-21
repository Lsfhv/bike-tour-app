// ignore_for_file: prefer_const_constructors
//import 'dart:html';

import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';
import 'package:bike_tour_app/models/tfl-api/bike_point_model.dart';
import 'package:bike_tour_app/models/tfl-api/get_api.dart';
import 'package:bike_tour_app/repository/direction.dart';
import 'package:bike_tour_app/screens/markers/bike_markers.dart';
import 'package:bike_tour_app/screens/markers/destination_marker.dart';
import 'package:bike_tour_app/screens/navigation/dynamic_navigation.dart';
import 'package:bike_tour_app/screens/widgets/compass.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/directions_model.dart';
import '../markers/user_location_marker.dart';
import 'to_page.dart';
// import '../../.env.dart';


class JourneyData {
  final UserPosition _currentPosition;
  List<Destination> _destinations;
  late List<Destination> _formated_list;
  GetApi bike_api = GetApi();
  List<LatLng> waypoints = [];
  Set<Marker> markers = {};
  Compass compass = Compass();
  JourneyData(this._currentPosition, this._destinations);


  _rerouteWaypoints(Directions? args){
    List<Destination> buffer=List.of(_destinations);
    //_destinations.clear();
    for(var i in args!.waypointsOrder){
      _destinations.add(buffer[i]);
    }
  }

  _routeOptimize() async {
    //choose the last destination
    List<LatLng> list = List<LatLng>.generate(_destinations.length, (i)=> _destinations[i].position);
    await DirectionsRepository().getDirections(origin: _currentPosition.center as LatLng, ending_bike_dock: _currentPosition.center as LatLng , destinations: list, optimize: true).
    then((value) => {
      _rerouteWaypoints(value)
    });
    //get directions
    //
  }
  _init_() async{
    Set<BikePointModel> bikePoints = await bike_api.fetchBikePoints();
    if(_destinations.length > 1){
      await _routeOptimize();
    }
    waypoints = [];
    markers = {};

    //init starting loc in red 
    markers.add(UserMarker(user : UserPosition(_currentPosition.center as LatLng)));
    waypoints.add(_currentPosition.center as LatLng);
    
    for(int i = -1; i < _destinations.length -1; i++){
      var start; 
      Destination end;
      BikePointModel? starting_dock;
      BikePointModel? ending_dock;
      if(i== -1){
        start = _currentPosition;
        end = _destinations[0];
        starting_dock = _choosingDock(await bike_api.getNearbyBikingDocks((start as UserPosition).center as LatLng));
      }
      else{
        start =  _destinations[i];
        end = _destinations[i+1];
        starting_dock = _choosingDock(await bike_api.getNearbyBikingDocks((start as Destination).position));
      }

      if(starting_dock != null){
        ending_dock = _choosingDock(await bike_api.getNearbyParkingDocks(end.position));
        if(ending_dock != null){
          //add starting_dock,destination,ending_dock
          waypoints.add(LatLng(starting_dock.lat, starting_dock.lon));
          waypoints.add(LatLng(ending_dock.lat,ending_dock.lon));
          waypoints.add(end.position);

          markers.add(BikeMarker(station: starting_dock));
          markers.add(DestinationMarker(destination: end));
          markers.add(BikeMarker(station: ending_dock));
        }
      }
      else{
        waypoints.add(end.position);
        markers.add(DestinationMarker(destination: end));
      }
    } 
  }


  
  BikePointModel? _choosingDock(Set<BikePointModel> docks){ //update to accommodate number restriction
    if(docks.isEmpty){
      return null;
    }
    else{
      BikePointModel chosen = docks.first; 
      for(BikePointModel dock in docks){
        if(dock.distance < chosen.distance){
          chosen = dock;
        }
      }
      return chosen;
    }
  }

  LatLng _getLastDockingStation(){
    return waypoints.last;
  }

}

class RoutingMap extends StatefulWidget {
  const RoutingMap({Key? key}) : super(key: key);
  
  static const routeName = '/routingMap';
  @override
  _RoutingMap createState() => _RoutingMap();
}

class _RoutingMap extends State<RoutingMap> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  bool _routeGenerated = false;
  //Set<BikeMarker> _markers_start = {};
  //Set<BikeMarker> _markers_end = {};
  late LatLng _center = const LatLng(51.507399, -0.127689);
  Directions? _info;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }
  Future<void> _generateRoute(JourneyData args) async{
    await args._init_();
    LatLng origin = args._currentPosition.center as LatLng;
    LatLng destination = args._getLastDockingStation();
    final directions = await DirectionsRepository().getDirections(origin: origin, ending_bike_dock: destination, destinations: args.waypoints);
    //error here    
    if(mounted){
      setState(() {
        _info = directions;
        _markers = args.markers;
        _routeGenerated = true;
      });
    }
    else{
      _info = directions;
      _markers = args.markers;
      _routeGenerated = true;
    }
    if(args == null){
      //if no found route, do something here! maybe go back to rechoose destination?
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("There is no found Route!"),
      actions : <Widget>[
        TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
      ]
    ));
    Navigator.pop(context); //go back to original page?
    }
    else{
      
    }
  }

  _start_navigation(Directions? args, JourneyData? jd){
    //write data to 
    if(args == null){
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("There is no found Route!"),
      actions : <Widget>[
        TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
      ]
    ));
    }
    else{
      Navigator.pushNamed(context, DynamicNavigation.routeName, arguments : RouteData(markers: _markers, directions: args, user_loc: UserPosition(_center), waypoints : jd!.waypoints));
    }
  }

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as JourneyData;
    _center = args._currentPosition.center as LatLng;
    if(!_routeGenerated){
      _generateRoute(args);
    }
    return MaterialApp(
      home: Scaffold(
          bottomNavigationBar: TextButton(onPressed:() => _start_navigation(_info,args), child : Text("Lets Go")),          
          body: Stack(
            alignment: Alignment.center,
            children: [
            if(!_routeGenerated) CircularProgressIndicator(),
          GoogleMap(
            myLocationButtonEnabled: false,
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
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      )
    )
    );
  }
}

