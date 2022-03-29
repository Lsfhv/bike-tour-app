// ignore_for_file: prefer_const_constructors, prefer_for_elements_to_map_fromiterable
//import 'dart:html';



import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:bike_tour_app/screens/navigation/dynamic_navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/directions_model.dart';
import '../../models/journey_data_with_route_model.dart';
import '../../models/route_model.dart';
import '../../models/user_data.dart';
// import '../../.env.dart';






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

