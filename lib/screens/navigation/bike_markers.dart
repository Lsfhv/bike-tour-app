import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bike_points.dart'

class BikeMarker extends StatelessWidget {
  final BikeDockPoint station;
  final Marker marker;
  BikeMarker({Key? key, required this.station})
    : super(key: key){
      LatLng latlng = LatLng(station.lat, station.lon);
      marker = Marker(markerId: station.referenceId ,draggable: false, position: latlng);
  }

  


  
    


}
