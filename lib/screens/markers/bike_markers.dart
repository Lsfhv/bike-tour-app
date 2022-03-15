import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';
import 'package:bike_tour_app/models/tfl-api/bike_point_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';

class BikeMarker extends Marker {
  final BikePointModel station;
  BikeMarker({required this.station})
    : super(markerId: MarkerId(station.id as String) ,draggable: false, position: LatLng(station.lat, station.lon),
    icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));





  
    


}
