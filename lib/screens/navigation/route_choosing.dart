// ignore_for_file: prefer_const_constructors
//import 'dart:html';

import 'package:bike_tour_app/repository/direction.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/directions_model.dart';
import 'to_page.dart';



class JourneyData {
  final UserPosition _currentPosition;
  List<LatLng> _destinations_cords;

  JourneyData(this._currentPosition, this._destinations_cords);

  
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
    LatLng origin = args._currentPosition.center as LatLng;
    LatLng destination = args._destinations_cords.first;
    final directions = await DirectionsRepository().getDirections(origin: origin, destination: destination);
    setState(() {
      _info = directions;
      _markers = {Marker(markerId: MarkerId('curr-loc'), position: origin), Marker(markerId: MarkerId('destionation'), position: destination) };
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

