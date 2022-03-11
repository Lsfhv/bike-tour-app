// ignore_for_file: prefer_const_constructors
//import 'dart:html';

import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';
import 'package:bike_tour_app/models/tfl-api/bike_point_model.dart';
import 'package:bike_tour_app/models/tfl-api/get_api.dart';
import 'package:bike_tour_app/repository/direction.dart';
import 'package:bike_tour_app/screens/markers/bike_markers.dart';
import 'package:bike_tour_app/screens/markers/destination_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/directions_model.dart';
import 'to_page.dart';
import '../../.env.dart';


class JourneyData {
  final UserPosition _currentPosition;
  List<Destination> _destinations;
  GetApi bike_api = GetApi();
  List<LatLng> waypoints = [];
  Set<Marker> markers = {};

  JourneyData(this._currentPosition, this._destinations);


  _init_() async{
    await bike_api.fetchBikePoints();
    waypoints = [];
    markers = {};

    //init starting loc in red 
    markers.add(Marker(markerId: MarkerId("curr loc"), position : _currentPosition.center as LatLng, icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
    waypoints.add(_currentPosition.center as LatLng);
    //first choose starting points
    /*BikePointModel? starting_dock = _choosingDock(bike_api.getNearbyDocks(_currentPosition.center as LatLng));
    if(starting_dock != null){
      LatLng start_dock_latlng = LatLng(starting_dock.lat,starting_dock.lon);
      //add waypoints
      waypoints.add(start_dock_latlng); 
      markers.add(BikeMarker(station: starting_dock as BikePointModel));
    }
    

    //add marker
  

    //first choose a dock for each location
    (for(Destination _destination in _destinations){
      BikePointModel parking_dock = _choosingDock(bike_api.getNearbyDocks(_currentPosition.center as LatLng));
      BikePointModel starting_dock = _choosingDock(bike_api.getNearbyDocks(_destination.position));
      
      //update waypoints and markers for parking dock
      waypoints.add(LatLng(parking_dock.lat,parking_dock.lon));
      markers.add(BikeMarker(station: parking_dock));

      //update waypoints and markers for destination
      waypoints.add(_destination.position);
      markers.add(DestinationMarker(destination: _destination));

      //update waypoints and markers for starting dock
      waypoints.add(LatLng(starting_dock.lat,starting_dock.lon));
      markers.add(BikeMarker(station: starting_dock));
    }

    //remove last addition bc not starting again
    waypoints.removeLast();
    markers.remove(markers.last);
  */
    for(int i =0; i < _destinations.length -1; i++){
      var start; 
      Destination end;
      BikePointModel? starting_dock;
      BikePointModel? ending_dock;
      if(i==0){
        start = _currentPosition;
        end = _destinations[i];
        starting_dock = _choosingDock(bike_api.getNearbyDocks((start as UserPosition).center as LatLng));
      }
      else{
        start =  _destinations[i].position;
        end = _destinations[i+1];
        starting_dock = _choosingDock(bike_api.getNearbyDocks((start as Destination).position));
      }
      if(starting_dock != null){
        ending_dock = _choosingDock(bike_api.getNearbyDocks(end.position));
        if(ending_dock != null){
          //add starting_dock,destination,ending_dock
          waypoints.add(LatLng(starting_dock.lat, starting_dock.lon));
          waypoints.add(end.position);
          waypoints.add(LatLng(ending_dock.lat,ending_dock.lon));

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


  
  BikePointModel? _choosingDock(Set<BikePointModel> docks){
    if(docks.isEmpty){
      return null;
    }
    return docks.first;
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
  //Set<BikeMarker> _markers_start = {};
  //Set<BikeMarker> _markers_end = {};
  final LatLng _center = const LatLng(51.507399, -0.127689);
  Directions? _info;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }
  void _generateRoute(JourneyData args) async{
    await args._init_();
    print(args._destinations.length);
    LatLng origin = args._currentPosition.center as LatLng;
    LatLng destination = args._getLastDockingStation();
    final directions = await DirectionsRepository().getDirections(origin: origin, ending_bike_dock: destination, destinations: args.waypoints);
    setState(() {
      _info = directions;
      _markers = args.markers;
    });
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
    
    return MaterialApp(
      home: Scaffold(
          bottomNavigationBar: TextButton(onPressed:() => _generateRoute(args), child : Text("Generate Route")),          
          /*body: Center(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 15),
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
          )
          */
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

