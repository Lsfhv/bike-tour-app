import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Destination {
  LatLng position;
  String name;
  final String postcode;
  Destination({required this.position, required this.name, required this.postcode});


  Map<String,dynamic> toJson(){
    return {
      "location" : new GeoPoint(position.latitude, position.longitude),
      "name" : name,
      "postcode" : postcode,
    };
  }

  factory Destination.fromFS(Map<String, dynamic> value){
    GeoPoint gp = value["location"];
    String name = value["name"];
    String postcode = value['postcode'];
    LatLng pos = LatLng(gp.latitude, gp.longitude);
    return Destination(position: pos, name: name, postcode: postcode);

  }

  bool equal(Destination other){
    const int tolerance = 50; // consider anywhere within 5 min to be the same destination
    return _calculate_distance(from : this.position, to : other.position) <= tolerance;

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
}