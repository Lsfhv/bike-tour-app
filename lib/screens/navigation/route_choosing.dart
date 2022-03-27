// ignore_for_file: prefer_const_constructors
//import 'dart:html';


import 'package:bike_tour_app/models/tfl-api/bike_point_model.dart';
import 'package:bike_tour_app/models/tfl-api/get_api.dart';
import 'package:bike_tour_app/repository/direction.dart';
import 'package:bike_tour_app/screens/markers/bike_markers.dart';
import 'package:bike_tour_app/screens/markers/destination_marker.dart';
import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:bike_tour_app/screens/navigation/dynamic_navigation.dart';
import 'package:bike_tour_app/screens/widgets/compass.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/directions_model.dart';
import '../markers/user_location_marker.dart';
import 'to_page.dart';
// import '../../.env.dart';


class JourneyData {
  final UserPosition currentPosition;
  List<Destination> destinations;
  late List<Destination> formated_list;
  GetApi bike_api = GetApi();
  List<LatLng> waypoints = [];
  Set<Marker> markers = {};
  Compass compass = Compass();
  int number_of_bikers = 1;
  JourneyData(this.currentPosition, this.destinations);


  rerouteWaypoints(Directions? args){
    List<Destination> buffer=List.of(destinations);
    //_destinations.clear();
    for(var i in args!.waypointsOrder){
      destinations.add(buffer[i]);
    }
  }

  routeOptimize() async {
    //choose the last destination
    List<LatLng> list = List<LatLng>.generate(destinations.length, (i)=> destinations[i].position);
    await DirectionsRepository().getDirections(origin: currentPosition.center as LatLng, ending_bike_dock: currentPosition.center as LatLng , destinations: list, optimize: true).
    then((value) => {
      rerouteWaypoints(value)
    });
    //get directions
    //
  }
  init() async{
    Set<BikePointModel> bikePoints = await bike_api.fetchBikePoints();
    if(destinations.length > 1){
      await routeOptimize();
    }
    waypoints = [];
    markers = {};

    //init starting loc in red 
    markers.add(UserMarker(user : UserPosition(currentPosition.center as LatLng)));
    //waypoints.add(currentPosition.center as LatLng); //think about this again yo
    
    for(int i = -1; i < destinations.length -1; i++){
      var start; 
      Destination end;
      BikePointModel? starting_dock;
      BikePointModel? ending_dock;
      if(i== -1){
        start = currentPosition;
        end = destinations[0];
        starting_dock = choosingDock(await bike_api.getNearbyBikingDocks((start as UserPosition).center as LatLng, bikePoints, uses: number_of_bikers));
      }
      else{
        start =  destinations[i];
        end = destinations[i+1];
        starting_dock = choosingDock(await bike_api.getNearbyBikingDocks((start as Destination).position, bikePoints,uses: number_of_bikers));
      }

      if(starting_dock != null){
        ending_dock = choosingDock(await bike_api.getNearbyParkingDocks(end.position, bikePoints, uses: number_of_bikers));
        if(ending_dock != null){
          //add starting_dock,destination,ending_dock
          waypoints.add(LatLng(starting_dock.lat, starting_dock.lon));
          waypoints.add(LatLng(ending_dock.lat,ending_dock.lon));
          waypoints.add(end.position);

          markers.add(BikeMarker(station: starting_dock));
          markers.add(DestinationMarker(destination: end));
          markers.add(BikeMarker(station: ending_dock));

          await bike_api.increaseBikeUsed(starting_dock, number: number_of_bikers);
          await bike_api.increaseParkingUsed(ending_dock, number: number_of_bikers);
        }
      }
      else{
        waypoints.add(end.position);
        markers.add(DestinationMarker(destination: end));
      }
    } 
  }


  
  BikePointModel? choosingDock(Set<BikePointModel> docks){ //update to accommodate number restriction
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

  LatLng getLastDockingStation(){
    return waypoints.last;
  }

 endTrip() async{
   for(int i =0; i < markers.length; i++){
     if(markers.elementAt(i).runtimeType == BikeMarker){
      BikePointModel starting_dock = (markers.elementAt(i) as BikeMarker).station;
      BikePointModel end_dock = (markers.elementAt(i+2) as BikeMarker).station;

      i = i+2;

      bike_api.decreaseBikeUsed(starting_dock, number: number_of_bikers);
      bike_api.decreaseParkingUsed(end_dock, number: number_of_bikers);
     }
   }
 }
}


class JourneyDataWithRoute {
  final JourneyData journeyData;
  final Directions? route;

  JourneyDataWithRoute({required this.journeyData, required this.route});
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
  late LatLng _center = const LatLng(51.507399, -0.127689);
  Directions? _info;
  bool navigating = true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }

  _start_navigation(Directions? args, JourneyDataWithRoute? jdwr){
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
      Navigator.pushNamed(context, DynamicNavigation.routeName, arguments : RouteData( user_loc: UserPosition(_center), jdwr : jdwr as JourneyDataWithRoute));
    }
  }

  _endtrip(JourneyDataWithRoute? jdwr) async{
    setState(() {
      navigating = false;
    });
    await jdwr!.journeyData.endTrip();
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
    final args = ModalRoute.of(context)!.settings.arguments as JourneyDataWithRoute;
    _center = args.journeyData.currentPosition.center as LatLng;
    _info = args.route;
    _markers = args.journeyData.markers;
    return MaterialApp(
      home: Scaffold(
          bottomNavigationBar: TextButton(onPressed:() => _start_navigation(_info,args), child : Text("Lets Go")),          
          body: Stack(
            alignment: Alignment.center,
            children: [
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
                  color: STANDARD_COLOR,
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

