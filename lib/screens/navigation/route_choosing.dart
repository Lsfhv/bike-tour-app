// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'to_page.dart';



class JourneyData {
  final UserPosition _currentPosition;
  List<String> _destinations;

  JourneyData(this._currentPosition, this._destinations);
}

class RoutingMap extends StatefulWidget {
  const RoutingMap({Key? key}) : super(key: key);
  static const routeName = '/routingMap';
  @override
  _RoutingMap createState() => _RoutingMap();
}

class _RoutingMap extends State<RoutingMap> {
  late GoogleMapController mapController;

  //Set<BikeMarker> _markers_start = {};
  //Set<BikeMarker> _markers_end = {};
  final LatLng _center = const LatLng(51.507399, -0.127689);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  void initState() {
    super.initState();
   // _markers_start = FirebaseFunctions.instance.httpsCallable('fetch_nearby_bicycle_from_starting_point') as Set<BikeMarker>;
    // _markers_end =  FirebaseFunctions.instance.httpsCallable('fetch_nearby_bicycle_from_destination') as Set<BikeMarker>;
  }

  @override
  void dispose() {
    //_markers_start.clear();
    //_markers_end.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as JourneyData;
    return MaterialApp(
      home: Scaffold(
          body: Center(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 15),
            ),
          )
      )
    );
  }
}
