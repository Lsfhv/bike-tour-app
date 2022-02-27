import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';

class BikeMarker extends Marker {
  final BikeDockPoint station;
  BikeMarker({required this.station})
    : super(markerId: MarkerId(""+station.referenceId) ,draggable: false, position: LatLng(station.lat, station.lon));





  
    


}
